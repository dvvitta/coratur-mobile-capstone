import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:curator/core/errors/app_failure.dart';
import 'package:curator/data/remote/remote_mission_repository.dart';
import 'package:curator/features/missions/models/mission_item.dart';

void main() {
  const baseUrl = 'http://localhost:3000/api/v1';

  group('RemoteMissionRepository - fetchMissions', () {
    test('mengirim Bearer token dan memetakan data backend', () async {
      late http.Request captured;
      final client = MockClient((request) async {
        captured = request;
        return http.Response(
          jsonEncode({
            'items': [
              {
                'id': 'm1',
                'title': 'Menggambar apel merah',
                'description': '',
                'activity_type': 'sketch_challenge',
                'progress': 0,
                'target': 1,
                'reward_points': 20,
                'status': 'not_started',
                'icon_key': 'apple',
                'completed_at': null,
              },
              {
                'id': 'm2',
                'title': 'Selesaikan 3 permainan',
                'description': '',
                'activity_type': 'mixed',
                'progress': 3,
                'target': 3,
                'reward_points': 20,
                'status': 'completed',
                'icon_key': null,
                'completed_at': '2026-10-26T08:00:00Z',
              },
              {
                'id': 'm3',
                'title': 'Pakai 5 warna berbeda',
                'activity_type': 'sketch_challenge',
                'progress': 3,
                'target': 5,
                'reward_points': 25,
                'status': 'in_progress',
                'icon_key': 'palette',
              },
            ],
            'next_cursor': null,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final repo = RemoteMissionRepository(
        baseUrl: baseUrl,
        tokenProvider: () => 'token-123',
        client: client,
      );

      final missions = await repo.fetchMissions();

      expect(captured.method, 'GET');
      expect(captured.url.toString(), '$baseUrl/missions?limit=50');
      expect(captured.headers['authorization'], 'Bearer token-123');

      expect(missions, hasLength(3));
      expect(missions.first.title, 'Menggambar apel merah');
      expect(missions.first.category, 'Sketch Challenge');
      expect(missions.first.status, MissionStatus.notStarted);
      expect(missions.first.actionLabel, 'Mulai');
      expect(missions.first.totalProgress, 1);

      expect(missions[1].isCompleted, isTrue);
      expect(missions[1].category, 'Petualangan hari ini');
      expect(missions[1].actionLabel, 'Selesai');

      expect(missions[2].status, MissionStatus.inProgress);
      expect(missions[2].actionLabel, 'Lanjut');
      expect(missions[2].currentProgress, 3);
      expect(missions[2].totalProgress, 5);
    });

    test('tanpa token aktif melempar AppFailure UNAUTHENTICATED', () async {
      final repo = RemoteMissionRepository(
        baseUrl: baseUrl,
        tokenProvider: () => null,
        client: MockClient((_) async => http.Response('{}', 200)),
      );

      expect(
        () => repo.fetchMissions(),
        throwsA(
          isA<AppFailure>().having((e) => e.code, 'code', 'UNAUTHENTICATED'),
        ),
      );
    });

    test('401 dari backend menjadi AppFailure UNAUTHENTICATED', () async {
      final client = MockClient((_) async {
        return http.Response(
          jsonEncode({
            'error': {
              'code': 'UNAUTHENTICATED',
              'message': 'Token tidak valid.',
            },
          }),
          401,
        );
      });

      final repo = RemoteMissionRepository(
        baseUrl: baseUrl,
        tokenProvider: () => 'expired-token',
        client: client,
      );

      expect(
        () => repo.fetchMissions(),
        throwsA(
          isA<AppFailure>()
              .having((e) => e.code, 'code', 'UNAUTHENTICATED')
              .having((e) => e.message, 'message', 'Token tidak valid.'),
        ),
      );
    });
  });
}
