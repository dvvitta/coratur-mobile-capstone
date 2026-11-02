import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/core/errors/app_failure.dart';
import 'package:curator/features/missions/models/mission_item.dart';
import 'package:curator/features/missions/repositories/mission_repository.dart';
import 'package:curator/features/missions/screens/missions_screen.dart';

class _StubMissionRepository implements MissionRepository {
  _StubMissionRepository(this.responses);

  /// Tiap pemanggilan memakai respons berikutnya; respons terakhir diulang.
  final List<Object> responses;
  int calls = 0;

  @override
  Future<List<MissionItem>> fetchMissions() async {
    final index = calls < responses.length ? calls : responses.length - 1;
    final response = responses[index];
    calls++;
    if (response is AppFailure) {
      throw response;
    }
    return response as List<MissionItem>;
  }
}

const _missions = [
  MissionItem(
    id: 'm1',
    title: 'Menggambar apel merah',
    category: 'Sketch Challenge',
    currentProgress: 0,
    totalProgress: 1,
    reward: 20,
    status: MissionStatus.notStarted,
    iconPath: 'assets/images/apell.png',
  ),
  MissionItem(
    id: 'm2',
    title: 'Selesaikan 3 permainan',
    category: 'Petualangan hari ini',
    currentProgress: 3,
    totalProgress: 3,
    reward: 20,
    status: MissionStatus.completed,
    iconPath: 'assets/images/permainan.png',
    actionLabel: 'Selesai',
  ),
];

void main() {
  testWidgets('menampilkan misi hasil integrasi backend', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MissionsScreen(repository: _StubMissionRepository([_missions])),
      ),
    );

    // Saat memuat, indikator progres tampil dan daftar belum dirender.
    expect(find.byKey(const Key('missions_loading')), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Menggambar apel merah'), findsOneWidget);
    expect(find.text('Selesaikan 3 permainan'), findsOneWidget);
    expect(find.text('1 dari 2 misi selesai'), findsOneWidget);
    expect(find.text('+20'), findsWidgets);
    expect(find.byKey(const Key('mission_item_m1')), findsOneWidget);
  });

  testWidgets('empty state saat backend tidak punya misi', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MissionsScreen(
          repository: _StubMissionRepository([<MissionItem>[]]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('missions_empty')), findsOneWidget);
    expect(find.text('Belum ada misi hari ini'), findsOneWidget);
    expect(find.text('Selesaikan semua misi'), findsNothing);
  });

  testWidgets('error menampilkan tombol coba lagi lalu memuat ulang', (
    tester,
  ) async {
    final repo = _StubMissionRepository([
      const AppFailure(
        message: 'Tidak bisa menghubungi server.',
        isRetryable: true,
      ),
      _missions,
    ]);

    await tester.pumpWidget(
      MaterialApp(home: MissionsScreen(repository: repo)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('missions_error')), findsOneWidget);
    expect(find.text('Tidak bisa menghubungi server.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('missions_retry')));
    await tester.pumpAndSettle();

    expect(repo.calls, 2);
    expect(find.text('Menggambar apel merah'), findsOneWidget);
    expect(find.byKey(const Key('missions_error')), findsNothing);
  });

  testWidgets('sesi berakhir menawarkan tombol masuk lagi', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MissionsScreen(
          repository: _StubMissionRepository([
            const AppFailure(
              message: 'Sesi kamu sudah berakhir. Silakan masuk lagi.',
              code: 'UNAUTHENTICATED',
            ),
          ]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('missions_login')), findsOneWidget);
    expect(find.byKey(const Key('missions_retry')), findsNothing);
  });
}
