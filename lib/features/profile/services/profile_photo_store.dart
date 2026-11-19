import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile_photo.dart';

/// Penyimpanan foto profil. Implementasi remote bisa ditambahkan tanpa
/// mengubah UI.
abstract class ProfilePhotoStore {
  Future<ProfilePhoto?> read();
  Future<void> write(ProfilePhoto photo);
  Future<void> clear();
}

/// Penyimpanan lokal sementara sampai backend/Supabase Storage tersedia.
class SharedPreferencesProfilePhotoStore implements ProfilePhotoStore {
  static const storageKey = 'sketchoo.profile_photo.v1';

  @override
  Future<ProfilePhoto?> read() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(storageKey);
      if (raw == null || raw.isEmpty) return null;
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return ProfilePhoto.fromJson(decoded);
    } on Object {
      // Penyimpanan lokal gagal: pakai avatar default.
      return null;
    }
  }

  @override
  Future<void> write(ProfilePhoto photo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, jsonEncode(photo.toJson()));
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
  }
}

/// Dipakai pada widget test agar tidak bergantung pada plugin platform.
class InMemoryProfilePhotoStore implements ProfilePhotoStore {
  ProfilePhoto? _photo;

  @override
  Future<ProfilePhoto?> read() async => _photo;

  @override
  Future<void> write(ProfilePhoto photo) async => _photo = photo;

  @override
  Future<void> clear() async => _photo = null;
}
