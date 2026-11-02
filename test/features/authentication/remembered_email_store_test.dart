import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:curator/features/authentication/services/remembered_email_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferencesRememberedEmailStore', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('menyimpan, membaca, dan menghapus email', () async {
      const store = SharedPreferencesRememberedEmailStore();

      expect(await store.read(), isNull);

      await store.save('  arka@example.com  ');
      expect(await store.read(), 'arka@example.com');

      await store.clear();
      expect(await store.read(), isNull);
    });

    test('email kosong dianggap tidak tersimpan', () async {
      const store = SharedPreferencesRememberedEmailStore();

      await store.save('   ');
      expect(await store.read(), isNull);
    });
  });

  group('InMemoryRememberedEmailStore', () {
    test('menyimpan dan menghapus email di memori', () async {
      final store = InMemoryRememberedEmailStore();

      expect(await store.read(), isNull);
      await store.save('arka@example.com');
      expect(await store.read(), 'arka@example.com');
      await store.clear();
      expect(await store.read(), isNull);
    });
  });
}
