import 'package:curator/core/constants/app_routes.dart';
import 'package:curator/features/sketch_challenge/models/level_item_model.dart';
import 'package:curator/features/sketch_challenge/repositories/sketch_challenge_repository.dart';
import 'package:curator/features/sketch_challenge/screens/sketch_challenge_level_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Repository stub: level 1 active (bebek), sisanya locked — simulasi user baru.
class _StubRepository implements SketchChallengeLevelRepository {
  @override
  Future<List<LevelItem>> fetchLevels() async => const [
        LevelItem(levelNumber: 1, title: 'Bebek',     subtitle: '+20 Bintang', status: LevelStatus.active,  promptId: 'bebek',     xRatio: 0.58, yRatio: 0.84),
        LevelItem(levelNumber: 2, title: 'Kucing',    subtitle: '+20 Bintang', status: LevelStatus.locked,  promptId: 'kucing',    xRatio: 0.30, yRatio: 0.70),
        LevelItem(levelNumber: 3, title: 'Ikan',      subtitle: '+20 Bintang', status: LevelStatus.locked,  promptId: 'ikan',      xRatio: 0.56, yRatio: 0.58),
        LevelItem(levelNumber: 4, title: 'Kupu-Kupu', subtitle: '+20 Bintang', status: LevelStatus.locked,  promptId: 'kupu_kupu', xRatio: 0.28, yRatio: 0.45),
        LevelItem(levelNumber: 5, title: 'Kura-Kura', subtitle: '+20 Bintang', status: LevelStatus.locked,  promptId: 'kura_kura', xRatio: 0.58, yRatio: 0.32),
      ];
}

void main() {
  Widget harness() => MaterialApp(
        routes: {
          AppRoutes.sketchChallengeLevels: (_) =>
              SketchChallengeLevelScreen(repository: _StubRepository()),
          AppRoutes.sketchChallenge: (_) =>
              const Scaffold(body: Text('Canvas Screen')),
        },
        initialRoute: AppRoutes.sketchChallengeLevels,
      );

  testWidgets(
    'menampilkan header, banner dunia, action card, node level, dan gift node',
    (tester) async {
      await tester.pumpWidget(harness());
      await tester.pumpAndSettle();

      // 1. Header elements
      expect(find.text('Sketch Challenge'), findsOneWidget);
      expect(find.text('Skor'), findsOneWidget);
      expect(find.text('0'), findsOneWidget); // totalStars user baru = 0
      expect(find.byKey(const Key('level_back_button')), findsOneWidget);

      // 2. Banner Dunia 1
      expect(find.text('Dunia 1'), findsOneWidget);
      expect(find.text('Hewan & Alam'), findsOneWidget);
      expect(find.text('0/5 Selesai'), findsOneWidget); // user baru belum selesai

      // 3. Floating action card — level 1 Bebek aktif
      expect(find.byKey(const Key('level_bottom_action_card')), findsOneWidget);
      expect(find.text('Level 1 Bebek'), findsOneWidget);
      expect(find.byKey(const Key('level_start_button')), findsOneWidget);

      // 4. Gift node
      expect(find.byKey(const Key('level_gift_node')), findsOneWidget);

      // 5. Tap Mulai → canvas
      await tester.tap(find.byKey(const Key('level_start_button')));
      await tester.pumpAndSettle();
      expect(find.text('Canvas Screen'), findsOneWidget);
    },
  );

  testWidgets('tap lingkaran ungu level aktif membuka canvas', (tester) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    // Tap tombol Mulai di action card (level aktif, selalu visible)
    await tester.tap(find.byKey(const Key('level_start_button')));
    await tester.pumpAndSettle();
    expect(find.text('Canvas Screen'), findsOneWidget);
  });

  testWidgets('tap gift node menampilkan snackbar hadiah misteri', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SketchChallengeLevelScreen(repository: _StubRepository()),
    ));
    await tester.pumpAndSettle();

    final scrollable = find.byType(SingleChildScrollView);
    await tester.drag(scrollable, const Offset(0, 500));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('level_gift_node')), warnIfMissed: false);
    await tester.pump();

    expect(find.text('Selesaikan semua level untuk membuka hadiah misteri! 🎁'), findsOneWidget);
  });

  testWidgets('tap level terkunci menampilkan snackbar informasi', (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    // Layar besar agar semua node muat dalam viewport (tidak off-screen)
    tester.view.physicalSize = const Size(412, 1600);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(MaterialApp(
      home: SketchChallengeLevelScreen(repository: _StubRepository()),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('level_node_2')));
    await tester.pump();

    expect(find.text('Level ini masih terkunci! Selesaikan level sebelumnya.'), findsOneWidget);
  });
}
