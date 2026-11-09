import 'package:flutter/material.dart';

/// Filter pilihan di halaman History.
enum HistoryFilter { semua, selesai, proses }

/// Segmented filter bar: Semua / Selesai / Proses.
///
/// Filter aktif = pill ungu solid. Filter tidak aktif = pill putih + border.
/// Logic filtering tetap di screen — widget ini hanya presentasi.
class HistoryFilterTabs extends StatelessWidget {
  const HistoryFilterTabs({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  final HistoryFilter currentFilter;
  final ValueChanged<HistoryFilter> onFilterChanged;

  static const _items = [
    _FilterItem(HistoryFilter.semua,  'Semua',   Icons.grid_view_rounded),
    _FilterItem(HistoryFilter.selesai,'Selesai', Icons.check_circle_outline_rounded),
    _FilterItem(HistoryFilter.proses, 'Proses',  Icons.timelapse_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < _items.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: _FilterPill(
              item: _items[i],
              isActive: currentFilter == _items[i].filter,
              onTap: () => onFilterChanged(_items[i].filter),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Data class (pure, no UI) ──────────────────────────────────────────────────

class _FilterItem {
  const _FilterItem(this.filter, this.label, this.icon);
  final HistoryFilter filter;
  final String label;
  final IconData icon;
}

// ── Pill widget ───────────────────────────────────────────────────────────────

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _FilterItem item;
  final bool isActive;
  final VoidCallback onTap;

  static const _activeColor   = Color(0xFF6C42F5);
  static const _inactiveColor = Colors.white;
  static const _inactiveIcon  = Color(0xFF645091);
  static const _inactiveText  = Color(0xFF7C719C);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key('history_tab_${item.filter.name}'),
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 42,
        decoration: BoxDecoration(
          color: isActive ? _activeColor : _inactiveColor,
          borderRadius: BorderRadius.circular(21),
          border: isActive
              ? null
              : Border.all(color: const Color(0xFFE2E4F0), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? const Color(0x336C42F5)
                  : const Color(0x0A000000),
              blurRadius: isActive ? 10 : 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: 16,
              color: isActive ? Colors.white : _inactiveIcon,
            ),
            const SizedBox(width: 6),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : _inactiveText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
