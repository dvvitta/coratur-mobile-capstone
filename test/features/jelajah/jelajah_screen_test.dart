import 'package:curator/core/constants/app_routes.dart';
import 'package:curator/features/jelajah/models/jelajah_models.dart';
import 'package:curator/features/jelajah/screens/hitung_hewan_screen.dart';
import 'package:curator/features/jelajah/screens/jelajah_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    home: child,
    routes: {AppRoutes.hitungHewan: (_) => const HitungHewanScreen()},
  );

  void setPhoneSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('menampilkan header, subjudul, chip kategori, dan kartu', (
    tester,
  ) async {
    setPhoneSize(tester);
    await tester.pumpWidget(wrap(const JelajahScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Jelajah Cilik'), findsOneWidget);
    expect(
      find.text(
        'Yuk, jelajahi dunia baru lewat membaca, berhitung, dan banyak lagi!',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('jelajah_back_button')), findsOneWidget);
    expect(find.byKey(const Key('jelajah_pencil_asset')), findsOneWidget);

    expect(find.byKey(const Key('jelajah_chip_semua')), findsOneWidget);
    expect(find.byKey(const Key('jelajah_chip_membaca')), findsOneWidget);
    expect(find.byKey(const Key('jelajah_chip_berhitung')), findsOneWidget);
    expect(find.byKey(const Key('jelajah_chip_menggambar')), findsOneWidget);

    expect(find.byKey(const Key('jelajah_card_hutan')), findsOneWidget);
    expect(find.text('Petualangan di Hutan'), findsWidgets);
    expect(find.text('Level 1 • Mudah'), findsWidgets);
  });

  testWidgets('filter kategori menyaring kartu', (tester) async {
    setPhoneSize(tester);
    await tester.pumpWidget(wrap(const JelajahScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('jelajah_chip_berhitung')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('jelajah_card_hitung-buah')), findsOneWidget);
    expect(find.byKey(const Key('jelajah_card_hutan')), findsNothing);

    await tester.tap(find.byKey(const Key('jelajah_chip_semua')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('jelajah_card_hutan')), findsOneWidget);
  });

  testWidgets('kartu memakai thumbnail kustom saat aset tersedia', (
    tester,
  ) async {
    setPhoneSize(tester);
    await tester.pumpWidget(
      wrap(
        const JelajahScreen(
          items: [
            JelajahItem(
              id: 'kustom',
              title: 'Cerita Kustom',
              description: 'Deskripsi kustom.',
              category: JelajahCategory.membaca,
              levelLabel: 'Level 3 • Sulit',
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cerita Kustom'), findsOneWidget);
    expect(find.text('Level 3 • Sulit'), findsOneWidget);
  });

  testWidgets('chip kategori dapat digeser horizontal', (tester) async {
    setPhoneSize(tester);
    await tester.pumpWidget(wrap(const JelajahScreen()));
    await tester.pumpAndSettle();

    final scrollable = find.byKey(const Key('jelajah_chip_scroll'));
    final before = tester.getTopLeft(
      find.byKey(const Key('jelajah_chip_semua')),
    );

    await tester.drag(scrollable, const Offset(-120, 0));
    await tester.pumpAndSettle();

    final after = tester.getTopLeft(
      find.byKey(const Key('jelajah_chip_semua')),
    );
    expect(after.dx, lessThan(before.dx));
  });

  testWidgets('kartu Hitung Hewan membuka halaman permainan', (tester) async {
    setPhoneSize(tester);
    await tester.pumpWidget(
      wrap(const JelajahScreen(initialCategory: JelajahCategory.berhitung)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('jelajah_card_hitung-hewan')));
    await tester.pumpAndSettle();

    expect(find.byType(HitungHewanScreen), findsOneWidget);
    expect(find.textContaining('Yuk, hitung ada berapa'), findsOneWidget);
  });

  testWidgets('mengetuk kartu menampilkan snackbar', (tester) async {
    setPhoneSize(tester);
    await tester.pumpWidget(wrap(const JelajahScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('jelajah_card_hutan')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Petualangan di Hutan segera hadir!'), findsOneWidget);
  });
}
