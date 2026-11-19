import 'package:flutter/foundation.dart';

import '../features/authentication/models/auth_user.dart';
import '../features/profile/models/profile_photo.dart';

/// Sesi aktif aplikasi (user + token akses).
///
/// Token hanya hidup di memori: belum ada penyimpanan permanen, refresh
/// otomatis, atau pemulihan sesi saat aplikasi dibuka ulang.
class SessionStore extends ChangeNotifier {
  AuthUser? _currentUser;
  String? _accessToken;
  ProfilePhoto? _profilePhoto;

  AuthUser? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  ProfilePhoto? get profilePhoto => _profilePhoto;

  String get displayName =>
      _currentUser?.name.isNotEmpty == true ? _currentUser!.name : 'Arka';

  void setSession({required AuthUser user, String? accessToken}) {
    _currentUser = user;
    _accessToken = accessToken;
    if (user.avatar != null && user.avatar!.isNotEmpty) {
      _profilePhoto = ProfilePhoto.fromString(user.avatar!);
    }
    notifyListeners();
  }

  void setProfilePhoto(ProfilePhoto? photo) {
    _profilePhoto = photo;
    notifyListeners();
  }

  void setUser(AuthUser? user) {
    _currentUser = user;
    if (user?.avatar != null && user!.avatar!.isNotEmpty) {
      _profilePhoto = ProfilePhoto.fromString(user.avatar!);
    }
    notifyListeners();
  }

  void clear() {
    _currentUser = null;
    _accessToken = null;
    _profilePhoto = null;
    notifyListeners();
  }
}
