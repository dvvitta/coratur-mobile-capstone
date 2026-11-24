import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/core/widgets/curator_bottom_nav.dart';
import 'package:curator/features/leaderboard/models/leaderboard_entry.dart';
import 'package:curator/features/leaderboard/repositories/leaderboard_repository.dart';
import 'package:curator/features/leaderboard/screens/leaderboard_screen.dart';

void main() {
  group('LeaderboardScreen Widget Tests', () {
    testWidgets('menampilkan header, maskot, judul, tab, podium, dan daftar peringkat', (tester) async {
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      tester.view.physicalSize = const Size(412, 1200);
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(
        const MaterialApp(
          home: LeaderboardScreen(repository: MockLeaderboardRepository()),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Header & Judul
      expect(find.text('Leaderboard'), findsOneWidget);
      expect(find.text('Papan Peringkat SKETCHOO'), findsOneWidget);
      expect(find.text('Lihat siapa yang paling hebat di kelas kita!'), findsOneWidget);

      // 2. Tab Filter
      expect(find.byKey(const Key('leaderboard_tab_global')), findsOneWidget);
      expect(find.byKey(const Key('leaderboard_tab_teman')), findsOneWidget);

      // 3. Top 3 di Podium
      expect(find.text('Rafa'), findsOneWidget);
      expect(find.text('Cinta'), findsOneWidget);
      expect(find.text('Dimas'), findsOneWidget);
      expect(find.text('1.250'), findsOneWidget);
      expect(find.text('1.080'), findsOneWidget);
      expect(find.text('980'), findsOneWidget);

      // 4. Daftar Rank 4+ dan Kamu
      expect(find.text('Nadia'), findsOneWidget);
      expect(find.text('Bima'), findsOneWidget);
      expect(find.text('Salsa'), findsOneWidget);
      expect(find.text('Kamu'), findsOneWidget);
      expect(find.text('147'), findsOneWidget);

      // 5. Scroll ke Kartu Motivasi
      final motivationFinder = find.text('Terus belajar dan kumpulkan bintang\nuntuk naik peringkat ya!');
      await tester.scrollUntilVisible(
        motivationFinder,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(motivationFinder, findsOneWidget);
    });

    testWidgets('berpindah tab Global ke Teman memperbarui daftar', (tester) async {
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      tester.view.physicalSize = const Size(412, 1200);
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(
        const MaterialApp(
          home: LeaderboardScreen(repository: MockLeaderboardRepository()),
        ),
      );
      await tester.pumpAndSettle();

      // Klik tab Teman
      await tester.tap(find.byKey(const Key('leaderboard_tab_teman')));
      await tester.pumpAndSettle();

      // Di tab teman: Rafa 1, Bima 2, Arka 3, Dinda 4, Kamu 5
      expect(find.text('Rafa'), findsOneWidget);
      expect(find.text('Bima'), findsOneWidget);
      expect(find.text('Arka'), findsOneWidget);
      expect(find.text('Dinda'), findsOneWidget);
      expect(find.text('Kamu'), findsOneWidget);
    });

    testWidgets('CuratorBottomNav memiliki 4 navigasi (Home, Leaderboard, History, Profile)', (tester) async {
      int selected = -1;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CuratorBottomNav(
              selectedIndex: NavIndex.leaderboard,
              onDestinationSelected: (i) => selected = i,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('nav_home_button')), findsOneWidget);
      expect(find.byKey(const Key('nav_leaderboard_button')), findsOneWidget);
      expect(find.byKey(const Key('nav_history_button')), findsOneWidget);
      expect(find.byKey(const Key('nav_profile_button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('nav_home_button')));
      expect(selected, NavIndex.home);

      await tester.tap(find.byKey(const Key('nav_history_button')));
      expect(selected, NavIndex.history);

      await tester.tap(find.byKey(const Key('nav_profile_button')));
      expect(selected, NavIndex.profile);
    });
  });

  group('LeaderboardEntry formattedScore Unit Test', () {
    test('memformat angka ribuan dengan titik sesuai bahasa Indonesia', () {
      const e1 = LeaderboardEntry(rank: 1, name: 'A', score: 1250, avatarIndex: 0);
      expect(e1.formattedScore, '1.250');

      const e2 = LeaderboardEntry(rank: 2, name: 'B', score: 980, avatarIndex: 0);
      expect(e2.formattedScore, '980');

      const e3 = LeaderboardEntry(rank: 3, name: 'C', score: 1000000, avatarIndex: 0);
      expect(e3.formattedScore, '1.000.000');
    });
  });
}
