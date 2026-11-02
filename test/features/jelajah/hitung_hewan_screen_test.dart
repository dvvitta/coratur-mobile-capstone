import 'package:curator/core/constants/asset_paths.dart';
import 'package:curator/features/jelajah/screens/hitung_hewan_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: child);

  void setPhoneSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('menampilkan latar bebek, instruksi, dan tiga tombol angka', (
    tester,
  ) async {
    setPhoneSize(tester);
    await tester.pumpWidget(wrap(const HitungHewanScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('hitung_hewan_background')), findsOneWidget);
    expect(
      tester
          .widget<Image>(find.byKey(const Key('hitung_hewan_background')))
          .image,
      const AssetImage(AssetPaths.bebekBackground),
    );

    expect(find.textContaining('Yuk, hitung ada berapa'), findsOneWidget);
    expect(find.byKey(const Key('hitung_hewan_back_button')), findsOneWidget);

    expect(find.byKey(const Key('hitung_hewan_answer_4')), findsOneWidget);
    expect(find.byKey(const Key('hitung_hewan_answer_5')), findsOneWidget);
    expect(find.byKey(const Key('hitung_hewan_answer_6')), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
  });

  testWidgets('jawaban benar menampilkan banner sukses', (tester) async {
    setPhoneSize(tester);
    await tester.pumpWidget(wrap(const HitungHewanScreen()));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<AnimatedOpacity>(
            find.ancestor(
              of: find.byKey(const Key('hitung_hewan_success_banner')),
              matching: find.byType(AnimatedOpacity),
            ),
          )
          .opacity,
      0,
    );
    expect(find.byKey(const Key('hitung_hewan_ring_5')), findsNothing);

    await tester.tap(find.byKey(const Key('hitung_hewan_answer_5')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Hebat! Jawabanmu benar'), findsOneWidget);
    expect(find.byKey(const Key('hitung_hewan_ring_5')), findsOneWidget);
    expect(find.byKey(const Key('hitung_hewan_ring_4')), findsNothing);
    expect(
      tester
          .widget<AnimatedOpacity>(
            find.ancestor(
              of: find.byKey(const Key('hitung_hewan_success_banner')),
              matching: find.byType(AnimatedOpacity),
            ),
          )
          .opacity,
      1,
    );
  });

  testWidgets('jawaban salah tidak menampilkan banner sukses', (tester) async {
    setPhoneSize(tester);
    await tester.pumpWidget(wrap(const HitungHewanScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('hitung_hewan_answer_4')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final banner = tester.widget<AnimatedOpacity>(
      find.ancestor(
        of: find.byKey(const Key('hitung_hewan_success_banner')),
        matching: find.byType(AnimatedOpacity),
      ),
    );
    expect(banner.opacity, 0);
    expect(find.byKey(const Key('hitung_hewan_ring_4')), findsOneWidget);

    // Setelah animasi salah selesai, pilihan dibersihkan agar bisa dicoba lagi.
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.byKey(const Key('hitung_hewan_ring_4')), findsNothing);
  });

  testWidgets('hover menampilkan ring kuning pada tombol', (tester) async {
    setPhoneSize(tester);
    await tester.pumpWidget(wrap(const HitungHewanScreen()));
    await tester.pumpAndSettle();

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await tester.pump();

    expect(find.byKey(const Key('hitung_hewan_ring_6')), findsNothing);

    await mouse.moveTo(
      tester.getCenter(find.byKey(const Key('hitung_hewan_answer_6'))),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('hitung_hewan_ring_6')), findsOneWidget);

    await mouse.moveTo(Offset.zero);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('hitung_hewan_ring_6')), findsNothing);
  });

  testWidgets('tombol kembali menutup halaman', (tester) async {
    setPhoneSize(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const HitungHewanScreen(),
                  ),
                ),
                child: const Text('buka'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('buka'));
    await tester.pumpAndSettle();
    expect(find.byType(HitungHewanScreen), findsOneWidget);

    await tester.tap(find.byKey(const Key('hitung_hewan_back_button')));
    await tester.pumpAndSettle();
    expect(find.byType(HitungHewanScreen), findsNothing);
    expect(find.text('buka'), findsOneWidget);
  });
}
