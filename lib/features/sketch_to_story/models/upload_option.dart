import 'package:flutter/material.dart';

/// Satu pilihan metode upload gambar.
class UploadOption {
  const UploadOption({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
  });

  final String id;
  final IconData icon;
  final String title;
  final String description;
}
