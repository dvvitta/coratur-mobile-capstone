import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

/// Avatar bawaan yang bisa dipilih pengguna.
class ProfileAvatarOption {
  const ProfileAvatarOption({
    required this.label,
    required this.assetPath,
    required this.background,
  });

  final String label;
  final String assetPath;

  /// Warna pastel kartu di belakang avatar.
  final Color background;

  static const List<ProfileAvatarOption> builtIn = [
    ProfileAvatarOption(
      label: 'Kucing',
      assetPath: AssetPaths.avatarKucing,
      background: Color(0xFFFFF2D9),
    ),
    ProfileAvatarOption(
      label: 'Panda',
      assetPath: AssetPaths.avatarPanda,
      background: Color(0xFFE4F8EA),
    ),
    ProfileAvatarOption(
      label: 'Dinosaurus',
      assetPath: AssetPaths.avatarDinosaurus,
      background: Color(0xFFDFF7E7),
    ),
    ProfileAvatarOption(
      label: 'Bebek',
      assetPath: AssetPaths.avatarBebek,
      background: Color(0xFFE8F4FF),
    ),
    ProfileAvatarOption(
      label: 'Pinguin',
      assetPath: AssetPaths.avatarPinguin,
      background: Color(0xFFEDE9FF),
    ),
    ProfileAvatarOption(
      label: 'Hamster',
      assetPath: AssetPaths.avatarHamster,
      background: Color(0xFFFFF0DE),
    ),
    ProfileAvatarOption(
      label: 'Beruang',
      assetPath: AssetPaths.avatarBeruang,
      background: Color(0xFFF1E4FF),
    ),
    ProfileAvatarOption(
      label: 'Rubah',
      assetPath: AssetPaths.avatarRubah,
      background: Color(0xFFF3E6FF),
    ),
  ];
}
