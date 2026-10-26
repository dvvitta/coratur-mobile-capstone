import 'package:flutter/foundation.dart';
import '../features/authentication/models/auth_user.dart';

class SessionStore extends ChangeNotifier {
  AuthUser? _currentUser;

  AuthUser? get currentUser => _currentUser;
  String get displayName => _currentUser?.name.isNotEmpty == true
      ? _currentUser!.name
      : 'Arka';

  void setUser(AuthUser? user) {
    _currentUser = user;
    notifyListeners();
  }

  void clear() {
    _currentUser = null;
    notifyListeners();
  }
}
