import 'package:flutter/foundation.dart';

import '../features/authentication/models/auth_user.dart';

/// Sesi aktif aplikasi (user + token akses).
///
/// Token hanya hidup di memori: belum ada penyimpanan permanen, refresh
/// otomatis, atau pemulihan sesi saat aplikasi dibuka ulang.
class SessionStore extends ChangeNotifier {
  AuthUser? _currentUser;
  String? _accessToken;

  AuthUser? get currentUser => _currentUser;
  String? get accessToken => _accessToken;

  String get displayName =>
      _currentUser?.name.isNotEmpty == true ? _currentUser!.name : 'Arka';

  void setSession({required AuthUser user, String? accessToken}) {
    _currentUser = user;
    _accessToken = accessToken;
    notifyListeners();
  }

  void setUser(AuthUser? user) {
    _currentUser = user;
    notifyListeners();
  }

  void clear() {
    _currentUser = null;
    _accessToken = null;
    notifyListeners();
  }
}
