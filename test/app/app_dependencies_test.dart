import 'package:flutter_test/flutter_test.dart';

import 'package:curator/app/app_dependencies.dart';

void main() {
  test('mode development memakai mock', () {
    final dependencies = AppDependencies.development();
    expect(dependencies.environment, AppEnvironment.mock);
    expect(dependencies.isMock, isTrue);
  });
}
