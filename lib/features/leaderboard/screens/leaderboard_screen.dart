import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/widgets/curator_bottom_nav.dart';
import '../controllers/leaderboard_controller.dart';
import '../models/leaderboard_entry.dart';
import '../repositories/leaderboard_repository.dart';
import '../widgets/leaderboard_header.dart';
import '../widgets/leaderboard_list_item.dart';
import '../widgets/leaderboard_motivation_card.dart';
import '../widgets/leaderboard_podium.dart';
import '../widgets/leaderboard_tab_bar.dart';

/// Halaman utama Leaderboard (Papan Peringkat SKETCHOO).
///
/// Bertanggung jawab sebagai View sesuai prinsip OOP / clean architecture.
/// State dikelola oleh [LeaderboardController].
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({
    super.key,
    this.isEmbedded = false,
    this.repository = const MockLeaderboardRepository(),
  });

  final bool isEmbedded;
  final LeaderboardRepository repository;

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late final LeaderboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LeaderboardController(repository: widget.repository);
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4EEFF),
        extendBody: !widget.isEmbedded,
        bottomNavigationBar: widget.isEmbedded
            ? null
            : CuratorBottomNav(
                selectedIndex: NavIndex.leaderboard,
                onDestinationSelected: (index) =>
                    CuratorBottomNav.navigateTo(context, index),
              ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE4D5FF),
                Color(0xFFF7F4FF),
                Color(0xFFEDE3FD),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => _Body(controller: _controller),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _Body — scrollable view dengan controller state
// ─────────────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({required this.controller});

  final LeaderboardController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) return const _LoadingView();
    if (controller.hasError) {
      return _ErrorView(
        message: controller.errorMessage ?? 'Gagal memuat data.',
        onRetry: controller.load,
      );
    }
    return _ContentView(controller: controller);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ContentView — slivers konten utama
// ─────────────────────────────────────────────────────────────────────────────

class _ContentView extends StatelessWidget {
  const _ContentView({required this.controller});

  final LeaderboardController controller;

  @override
  Widget build(BuildContext context) {
    final podium = controller.podiumEntries;
    final list = controller.listEntries;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── 1. Header visual (Top bar & Maskot gajah) ───────────────────────
        const SliverToBoxAdapter(child: LeaderboardHeader()),

        // ── 2. Judul "Papan Peringkat SKETCHOO" ────────────────────────────
        const SliverToBoxAdapter(child: _SectionTitle()),

        // ── 3. Tab Global / Teman (Dua pill terpisah berdampingan) ──────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: LeaderboardTabBar(
              activeTab: controller.activeTab,
              onTabChanged: controller.switchTab,
            ),
          ),
        ),

        // ── 4. Podium Tiga Besar ───────────────────────────────────────────
        if (podium.length == 3)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              child: LeaderboardPodium(entries: podium),
            ),
          ),

        // ── 5. Kartu Putih Berisi Daftar Peringkat 4+ dan Kamu ─────────────
        SliverToBoxAdapter(
          child: _LeaderboardCard(entries: list),
        ),

        // ── 6. Kartu Motivasi Bintang di Bagian Bawah ──────────────────────
        const SliverToBoxAdapter(child: LeaderboardMotivationCard()),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SectionTitle — Judul bagian + Subtitle
// ─────────────────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Papan Peringkat SKETCHOO',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1547),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Lihat siapa yang paling hebat di kelas kita!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF756A8F),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LeaderboardCard — Wadah kartu putih untuk daftar peringkat
// ─────────────────────────────────────────────────────────────────────────────

class _LeaderboardCard extends StatelessWidget {
  const _LeaderboardCard({required this.entries});

  final List<LeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C522CA6),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < entries.length; i++) ...[
            LeaderboardListItem(
              key: ValueKey(entries[i].rank),
              entry: entries[i],
            ),
            if (i < entries.length - 1 && !entries[i].isCurrentUser && !entries[i + 1].isCurrentUser)
              const Divider(height: 1, thickness: 1, color: Color(0xFFF3EDFC)),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LoadingView & _ErrorView
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF7C4DFF),
        strokeWidth: 3,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: Color(0xFFB0B0CC),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7A7A9A),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C4DFF),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
