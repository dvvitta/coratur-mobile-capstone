import 'package:flutter_test/flutter_test.dart';

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
}
