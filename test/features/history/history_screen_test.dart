import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/core/constants/app_routes.dart';
import 'package:curator/features/history/screens/history_screen.dart';

void main() {
  testWidgets('menampilkan daftar karya grid ketika riwayat memiliki data',
      (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = const Size(412, 1055);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(
      const MaterialApp(
        home: HistoryScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Header
    expect(find.text('Karya Hebatku'), findsOneWidget);

    // 2. Greeting card dengan badge statistik
    expect(find.text('Hebat, Arka!'), findsOneWidget);
    expect(find.text('4 selesai'), findsOneWidget);
    expect(find.text('8 bintang'), findsOneWidget);

    // 3. Grid karya (Matahari, Mobil, Kucing, Bunga)
    expect(find.text('Matahari'), findsOneWidget);
    expect(find.text('Level 3 • Kupu-kupu'), findsOneWidget);
    expect(find.text('12 Apr 2025'), findsOneWidget);

    expect(find.text('Mobil'), findsOneWidget);
    expect(find.text('Level 2 • Kendaraan'), findsOneWidget);

    expect(find.text('Kucing'), findsOneWidget);
    expect(find.text('Bunga'), findsOneWidget);

    // 4. Filter tab
    await tester.tap(find.byKey(const Key('history_tab_selesai')));
    await tester.pumpAndSettle();
    expect(find.text('Matahari'), findsOneWidget);

    // Filter tab proses (kosong) menampilkan empty state
    await tester.tap(find.byKey(const Key('history_tab_proses')));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada karya, nih!'), findsOneWidget);
  });

  testWidgets('menampilkan empty state jika riwayat kosong',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.sketchChallengeLevels: (_) =>
              const Scaffold(body: Text('Level Screen')),
        },
        home: const HistoryScreen(initialArtworks: []),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Belum ada karya, nih!'), findsOneWidget);
    expect(find.byKey(const Key('history_start_drawing_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('history_start_drawing_button')));
    await tester.pumpAndSettle();
    expect(find.text('Level Screen'), findsOneWidget);
  });
}
