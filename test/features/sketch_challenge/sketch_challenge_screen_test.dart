import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/features/sketch_challenge/screens/sketch_challenge_screen.dart';

void main() {
  Widget harness() {
    return const MaterialApp(
      home: SketchChallengeScreen(),
    );
  }

  testWidgets('menampilkan header, skor bintang, instruksi, canvas, dan palet',
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
    expect(find.text('20'), findsOneWidget);
    expect(find.text('2/5'), findsOneWidget);
    expect(find.text('Kupu-kupu'), findsOneWidget);
    expect(find.text('Selesai'), findsOneWidget);
  });

  testWidgets('interaksi menggambar, undo, dan clear canvas bekerja',
      (tester) async {
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
    expect(find.text('Kupu-kupumu sudah jadi!'), findsOneWidget);
  });
}
