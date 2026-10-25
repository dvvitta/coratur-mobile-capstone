import 'package:curator/core/constants/app_routes.dart';
import 'package:curator/features/sketch_challenge/screens/sketch_challenge_level_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('menampilkan header, banner dunia, action card, node level, dan gift node', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.sketchChallengeLevels: (_) => const SketchChallengeLevelScreen(),
          AppRoutes.sketchChallenge: (_) => const Scaffold(body: Text('Canvas Screen')),
        },
        initialRoute: AppRoutes.sketchChallengeLevels,
      ),
    );
    await tester.pumpAndSettle();

    // 1. Header elements
    expect(find.text('Sketch Challenge'), findsOneWidget);
    expect(find.text('Skor'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.byKey(const Key('level_back_button')), findsOneWidget);

    // 2. Banner Dunia 1
    expect(find.text('Dunia 1'), findsOneWidget);
    expect(find.text('Hewan & Alam'), findsOneWidget);
    expect(find.text('2/5 Selesai'), findsOneWidget);

    // 3. Floating action card
    expect(find.byKey(const Key('level_bottom_action_card')), findsOneWidget);
    expect(find.text('Level 3 Kupu- Kupu'), findsOneWidget);
    expect(find.byKey(const Key('level_start_button')), findsOneWidget);

    // 4. Gift node
    expect(find.byKey(const Key('level_gift_node')), findsOneWidget);

    // 5. Tap Mulai button navigates to canvas
    await tester.tap(find.byKey(const Key('level_start_button')));
    await tester.pumpAndSettle();
    expect(find.text('Canvas Screen'), findsOneWidget);
  });

  testWidgets('tap lingkaran ungu level aktif membuka canvas', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.sketchChallengeLevels: (_) => const SketchChallengeLevelScreen(),
          AppRoutes.sketchChallenge: (_) => const Scaffold(body: Text('Canvas Screen')),
        },
        initialRoute: AppRoutes.sketchChallengeLevels,
      ),
    );
    await tester.pumpAndSettle();

    // Tap level 3 (lingkaran ungu aktif)
    await tester.tap(find.byKey(const Key('level_node_3')));
    await tester.pumpAndSettle();
    expect(find.text('Canvas Screen'), findsOneWidget);
  });

  testWidgets('tap gift node menampilkan snackbar hadiah misteri', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SketchChallengeLevelScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Scroll to the top to bring gift node fully into view below banner
    final scrollable = find.byType(SingleChildScrollView);
    await tester.drag(scrollable, const Offset(0, 500));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('level_gift_node')), warnIfMissed: false);
    await tester.pump();

    expect(find.text('Selesaikan semua level untuk membuka hadiah misteri! 🎁'), findsOneWidget);
  });

  testWidgets('tap level terkunci menampilkan snackbar informasi', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SketchChallengeLevelScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('level_node_4')));
    await tester.pump();

    expect(find.text('Level ini masih terkunci! Selesaikan level sebelumnya.'), findsOneWidget);
  });
}
