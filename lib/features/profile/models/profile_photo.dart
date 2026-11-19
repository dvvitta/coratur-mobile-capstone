import 'dart:convert';
import 'dart:typed_data';

import '../../../core/constants/asset_paths.dart';

/// Sumber foto profil yang sedang dipakai.
enum ProfilePhotoKind { builtIn, custom }

/// Foto profil aktif: avatar bawaan aplikasi atau foto hasil kamera/galeri.
class ProfilePhoto {
  const ProfilePhoto._({required this.kind, this.assetPath, this.bytes});

  factory ProfilePhoto.builtIn(String assetPath) =>
      ProfilePhoto._(kind: ProfilePhotoKind.builtIn, assetPath: assetPath);

  factory ProfilePhoto.custom(Uint8List bytes) =>
      ProfilePhoto._(kind: ProfilePhotoKind.custom, bytes: bytes);

  /// Foto default saat pengguna belum pernah mengganti avatar.
  static const ProfilePhoto fallback = ProfilePhoto._(
    kind: ProfilePhotoKind.builtIn,
    assetPath: AssetPaths.avatarKucing,
  );

  final ProfilePhotoKind kind;
  final String? assetPath;
  final Uint8List? bytes;

  bool get isCustom => kind == ProfilePhotoKind.custom;

  Map<String, dynamic> toJson() => {
    'kind': kind.name,
    if (assetPath != null) 'asset': assetPath,
    if (bytes != null) 'data': base64Encode(bytes!),
  };

  static ProfilePhoto? fromJson(Map<String, dynamic> json) {
    if (json['kind'] == ProfilePhotoKind.custom.name) {
      final data = json['data'];
      if (data is! String || data.isEmpty) return null;
      try {
        return ProfilePhoto.custom(base64Decode(data));
      } on FormatException {
        return null;
      }
    }

    final asset = json['asset'];
    if (asset is! String || asset.isEmpty) return null;
    return ProfilePhoto.builtIn(asset);
  }

  String toSerializedString() {
    if (isCustom) {
      return jsonEncode(toJson());
    }
    return assetPath ?? ProfilePhoto.fallback.assetPath!;
  }

  static ProfilePhoto? fromString(String raw) {
    if (raw.trim().isEmpty) return null;
    if (raw.trim().startsWith('{')) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          return ProfilePhoto.fromJson(decoded);
        }
      } catch (_) {}
    }
    return ProfilePhoto.builtIn(raw.trim());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfilePhoto &&
        other.kind == kind &&
        other.assetPath == assetPath;
  }

  @override
  int get hashCode => Object.hash(kind, assetPath);
}
