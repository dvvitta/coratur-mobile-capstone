import 'package:flutter/material.dart';

import '../models/badge_item.dart';

abstract interface class BadgeRepository {
  Future<List<BadgeItem>> fetchBadges();
}

class MockBadgeRepository implements BadgeRepository {
  const MockBadgeRepository();

  @override
  Future<List<BadgeItem>> fetchBadges() async {
    return const [
      BadgeItem(id: 'pelukis_hebat', name: 'Pelukis Hebat', assetPath: 'assets/badge/pelukis hebat.png', description: 'Tunjukkan kemampuan menggambarmu.', status: BadgeStatus.owned, cardColor: Color(0xFFFFF5D9), requirement: 'Selesaikan tantangan menggambar.', obtainedDate: '12 Apr 2025'),
      BadgeItem(id: 'kreatif_banget', name: 'Kreatif Banget', assetPath: 'assets/badge/kreatif banget.png', description: 'Ide kreatifmu semakin hebat.', status: BadgeStatus.locked, cardColor: Color(0xFFEEE8FF), requirement: 'Selesaikan 3 Sketch Challenge.', progress: 0.0),
      BadgeItem(id: 'penjelajah_cilik', name: 'Penjelajah Cilik', assetPath: 'assets/badge/penjelajah cilik.png', description: 'Jelajahi dunia belajar dengan berani.', status: BadgeStatus.locked, cardColor: Color(0xFFEAF3FF), requirement: 'Selesaikan 5 Jelajah Cilik.', progress: 0.0),
      BadgeItem(id: 'master_misi', name: 'Master Misi', assetPath: 'assets/badge/master misi.png', description: 'Kamu jago menyelesaikan misi.', status: BadgeStatus.locked, cardColor: Color(0xFFE7F8ED), requirement: 'Selesaikan 10 Misi.', progress: 0.0),
      BadgeItem(id: 'si_jago_cerita', name: 'Si Jago Cerita', assetPath: 'assets/badge/si jago cerita.png', description: 'Ceritakan ide hebatmu.', status: BadgeStatus.locked, cardColor: Color(0xFFFCEBFA), requirement: 'Selesaikan 5 Sketch-to-Story.', progress: 0.0),
      BadgeItem(id: 'coming_soon', name: 'Coming Soon', assetPath: 'assets/badge/coming soon.png', description: 'Badge baru akan segera hadir.', status: BadgeStatus.comingSoon, cardColor: Color(0xFFEEE8FF), requirement: 'Nantikan update terbaru!'),
    ];
  }
}
