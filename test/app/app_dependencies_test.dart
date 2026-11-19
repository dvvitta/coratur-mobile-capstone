import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:curator/app/app_dependencies.dart';

void main() {
  test('mode development tanpa URL memakai mock', () {
    final dependencies = AppDependencies.development();
    expect(dependencies.environment, AppEnvironment.mock);
    expect(dependencies.isMock, isTrue);
  });

  test('mode development dengan URL memakai remote', () {
    final dependencies = AppDependencies.development(
      apiBaseUrl: 'http://localhost:3000/api/v1',
    );
    expect(dependencies.environment, AppEnvironment.remote);
    expect(dependencies.isMock, isFalse);
    expect(dependencies.apiBaseUrl, 'http://localhost:3000/api/v1');
  });

  test('joinClassroom mengirim kode dan mengembalikan nama kelas & guru', () async {
    const baseUrl = 'http://localhost:3000/api/v1';
    final client = MockClient((request) async {
      expect(request.url.toString(), '$baseUrl/classrooms/join');
      expect(request.method, 'POST');
      final body = jsonDecode(request.body);
      expect(body['code'], 'KELD03');

      return http.Response(
        jsonEncode({
          'classroom_id': 'd03b72e4',
          'classroom_name': 'Kelas B1 (Bintang)',
          'teacher_name': 'depitt',
          'school_name': 'TK Sketchoo Ceria',
        }),
        201,
        headers: {'content-type': 'application/json'},
      );
    });

    final baseDeps = AppDependencies.mock();
    final deps = AppDependencies(
      environment: AppEnvironment.remote,
      apiBaseUrl: baseUrl,
      authRepository: baseDeps.authRepository,
      missionRepository: baseDeps.missionRepository,
      historyRepository: baseDeps.historyRepository,
      sketchChallengeLevelRepository: baseDeps.sketchChallengeLevelRepository,
      sketchChallengeCompleteRepository:
          baseDeps.sketchChallengeCompleteRepository,
      client: client,
    );

    final result = await deps.joinClassroom('KELD03');
    expect(result['className'], 'Kelas B1 (Bintang)');
    expect(result['teacherName'], 'Guru: depitt');
  });
}
