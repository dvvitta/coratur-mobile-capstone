import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/curator_bottom_nav.dart';
import '../../home/widgets/home_background.dart';
import '../models/badge_item.dart';
import '../repositories/badge_repository.dart';

enum BadgeFilter { all, locked, owned }

class BadgeCollectionScreen extends StatefulWidget {
  const BadgeCollectionScreen({super.key, this.repository = const MockBadgeRepository()});
  final BadgeRepository repository;
  @override
  State<BadgeCollectionScreen> createState() => _BadgeCollectionScreenState();
}

class _BadgeCollectionScreenState extends State<BadgeCollectionScreen> {
  List<BadgeItem> _badges = const [];
  BadgeFilter _filter = BadgeFilter.all;
  bool _loading = true;

  @override
  void initState() { super.initState(); _loadBadges(); }

  Future<void> _loadBadges() async {
    final badges = await widget.repository.fetchBadges();
    if (!mounted) return;
    setState(() { _badges = badges; _loading = false; });
  }

  List<BadgeItem> get _visibleBadges => _badges.where((badge) {
    return switch (_filter) {
      BadgeFilter.all => true,
      BadgeFilter.locked => badge.status == BadgeStatus.locked,
      BadgeFilter.owned => badge.status == BadgeStatus.owned,
    };
  }).toList();

  int get _ownedCount => _badges.where((b) => b.status == BadgeStatus.owned).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeBackground.baseColor,
      extendBody: true,
      bottomNavigationBar: CuratorBottomNav(
        selectedIndex: 2,
        onDestinationSelected: (index) {
          if (index == 0) Navigator.of(context).pushReplacementNamed(AppRoutes.home);
          if (index == 1) Navigator.of(context).pushReplacementNamed(AppRoutes.history);
          if (index == 2) Navigator.of(context).pushReplacementNamed(AppRoutes.profile);
        },
      ),
      body: HomeBackground(
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverPadding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), sliver: SliverToBoxAdapter(child: _Header(onBack: () => Navigator.of(context).pop()))),
              SliverPadding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 0), sliver: SliverToBoxAdapter(child: _Summary(owned: _ownedCount, total: _badges.length))),
              SliverPadding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 0), sliver: SliverToBoxAdapter(child: _Filters(selected: _filter, onSelected: (filter) => setState(() => _filter = filter)))),
              if (_loading)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 126),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final badge = _visibleBadges[index];
                      return _BadgeCard(badge: badge, onTap: () => _showDetails(badge));
                    }, childCount: _visibleBadges.length),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 190, mainAxisSpacing: 14, crossAxisSpacing: 14, mainAxisExtent: 248),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BadgeItem badge) => showModalBottomSheet<void>(context: context, backgroundColor: Colors.transparent, builder: (_) => _BadgeDetails(badge: badge));
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [_CircleButton(icon: Icons.arrow_back_rounded, onTap: onBack), const SizedBox(width: 14), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Koleksi Badge', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: Color(0xFF30216D), letterSpacing: -0.7)), SizedBox(height: 5), Text('Kumpulkan badge dan tunjukkan prestasi hebatmu!', style: TextStyle(fontSize: 13, color: Color(0xFF77758A), height: 1.3))]))]);
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.72),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(icon, color: const Color(0xFF7042F5)),
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.owned, required this.total});
  final int owned;
  final int total;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xCCFFFFFF), borderRadius: BorderRadius.circular(28), border: Border.all(color: const Color(0xE6FFFFFF)), boxShadow: const [BoxShadow(color: Color(0x147042F5), blurRadius: 24, offset: Offset(0, 10))]), child: Row(children: [Image.asset('assets/badge/pelukis hebat.png', width: 90, height: 90, fit: BoxFit.contain), const SizedBox(width: 12), Expanded(child: _SummaryValue(value: '$owned', label: 'Badge\nDidapatkan')), Container(width: 1, height: 54, color: const Color(0xFFDCD4F1)), Expanded(child: _SummaryValue(value: '$total', label: 'Total\nBadge'))]));
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min, children: [Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF30216D))), const SizedBox(height: 2), Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF77758A), height: 1.2))]);
}

class _Filters extends StatelessWidget {
  const _Filters({required this.selected, required this.onSelected});
  final BadgeFilter selected;
  final ValueChanged<BadgeFilter> onSelected;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: const Color(0xBFFFFFFF), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xE6FFFFFF))), child: Row(children: [_FilterButton(label: 'Semua', selected: selected == BadgeFilter.all, onTap: () => onSelected(BadgeFilter.all)), _FilterButton(label: 'Terkunci', selected: selected == BadgeFilter.locked, onTap: () => onSelected(BadgeFilter.locked)), _FilterButton(label: 'Dimiliki', selected: selected == BadgeFilter.owned, onTap: () => onSelected(BadgeFilter.owned))]));
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF7042F5) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: selected ? Colors.white : const Color(0xFF8E7FBB),
          ),
        ),
      ),
    ),
  );
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.badge, required this.onTap});
  final BadgeItem badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
          decoration: BoxDecoration(
            color: badge.cardColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
            boxShadow: const [BoxShadow(color: Color(0x107042F5), blurRadius: 16, offset: Offset(0, 7))],
          ),
          child: Column(
            children: [
              Expanded(child: Image.asset(badge.assetPath, fit: BoxFit.contain)),
              const SizedBox(height: 7),
              Text(badge.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Color(0xFF30216D))),
              const SizedBox(height: 6),
              _StatusPill(status: badge.status),
              const SizedBox(height: 6),
              Text(badge.status == BadgeStatus.owned ? 'Diperoleh: ${badge.obtainedDate}' : badge.requirement, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10.5, color: Color(0xFF77758A), height: 1.2)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});
  final BadgeStatus status;
  @override
  Widget build(BuildContext context) { final owned = status == BadgeStatus.owned; final soon = status == BadgeStatus.comingSoon; return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: owned ? const Color(0xFFE0F8EA) : const Color(0xD9FFFFFF), borderRadius: BorderRadius.circular(16)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(owned ? Icons.check_rounded : soon ? Icons.schedule_rounded : Icons.lock_outline_rounded, size: 13, color: owned ? const Color(0xFF20B879) : const Color(0xFF8E7FBB)), const SizedBox(width: 3), Text(owned ? 'Dimiliki' : soon ? 'Segera Hadir' : 'Terkunci', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: owned ? const Color(0xFF20B879) : const Color(0xFF8E7FBB)))])); }
}

class _BadgeDetails extends StatelessWidget {
  const _BadgeDetails({required this.badge});
  final BadgeItem badge;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.fromLTRB(24, 18, 24, 30), decoration: const BoxDecoration(color: Color(0xFFF8F7FF), borderRadius: BorderRadius.vertical(top: Radius.circular(32))), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(width: 44, height: 4, decoration: BoxDecoration(color: Color(0xFFD9CEFF), borderRadius: BorderRadius.circular(4))), const SizedBox(height: 18), Image.asset(badge.assetPath, width: 130, height: 130, fit: BoxFit.contain), Text(badge.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF30216D))), const SizedBox(height: 8), Text(badge.description, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF77758A))), const SizedBox(height: 10), Text(badge.status == BadgeStatus.owned ? 'Diperoleh: ${badge.obtainedDate}' : badge.requirement, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF7042F5)))]));
}
