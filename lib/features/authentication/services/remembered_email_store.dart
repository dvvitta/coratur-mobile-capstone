import 'package:shared_preferences/shared_preferences.dart';

/// Penyimpanan email login terakhir untuk fitur "Ingat saya".
///
/// Hanya email yang disimpan; password dan access token tetap di memori.
abstract interface class RememberedEmailStore {
  Future<String?> read();
  Future<void> save(String email);
  Future<void> clear();
}

/// Implementasi nyata: email disimpan di SharedPreferences perangkat.
class SharedPreferencesRememberedEmailStore implements RememberedEmailStore {
  const SharedPreferencesRememberedEmailStore();

  static const _key = 'auth.remembered_email';

  @override
  Future<String?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_key)?.trim();
    return email == null || email.isEmpty ? null : email;
  }

  @override
  Future<void> save(String email) async {
    final value = email.trim();
    if (value.isEmpty) {
      await clear();
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, value);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

/// Implementasi untuk test dan mode mock: tersimpan hanya selama proses hidup.
class InMemoryRememberedEmailStore implements RememberedEmailStore {
  InMemoryRememberedEmailStore([this._email]);

  String? _email;

  @override
  Future<String?> read() async => _email;

  @override
  Future<void> save(String email) async {
    final value = email.trim();
    _email = value.isEmpty ? null : value;
  }

  @override
  Future<void> clear() async {
    _email = null;
  }
}
