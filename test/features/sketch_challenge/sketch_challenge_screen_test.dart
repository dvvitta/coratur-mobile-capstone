import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/features/sketch_challenge/screens/sketch_challenge_screen.dart';

void main() {
  Widget harness({String? promptId}) {
    return MaterialApp(home: SketchChallengeScreen(initialPromptId: promptId));
  }

  testWidgets(
    'menampilkan header, skor bintang, instruksi, canvas, dan palet',
    (tester) async {
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      tester.view.physicalSize = const Size(412, 917);
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(harness());

      expect(find.text('Sketch\nChallenge'), findsOneWidget);
      expect(find.text('Skor'), findsOneWidget);
      expect(find.text('1/5'), findsOneWidget);  // prompt pertama: Bebek
      expect(find.text('Bebek'), findsOneWidget);
      expect(find.text('Selesai'), findsOneWidget);
    },
  );

  testWidgets('interaksi menggambar, undo, dan clear canvas bekerja', (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(harness());

    final gestureFinder = find.byType(GestureDetector).first;
    await tester.drag(gestureFinder, const Offset(50, 50));
    await tester.pump();

    await tester.tap(find.byKey(const Key('sketch_undo_button')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('sketch_clear_button')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('sketch_finish_button')));
    await tester.pumpAndSettle();
    expect(find.text('Hebat!'), findsOneWidget);
    // feedbackMessage dari mock repository
    expect(find.text('Wah, hebat sekali! Kamu berhasil!'), findsOneWidget);
  });

  testWidgets(
    'level kucing memuat panduan SVG dan lanjut ke level berikutnya',
    (tester) async {
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      tester.view.physicalSize = const Size(412, 917);
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(harness(promptId: 'kucing'));
      await tester.pumpAndSettle();

      expect(find.text('Kucing'), findsOneWidget);
      expect(find.text('Ikuti garis putus - putus, gambar\nkucing lucu!'), findsOneWidget);

      await tester.tap(find.byKey(const Key('sketch_finish_button')));
      await tester.pumpAndSettle();

      expect(find.text('Hebat!'), findsOneWidget);
      await tester.tap(find.byKey(const Key('result_next_button')));
      await tester.pumpAndSettle();

      // Setelah kucing (index 1) → ikan (index 2)
      expect(find.text('Ikan'), findsOneWidget);
    },
  );
}
