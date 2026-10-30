import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/features/main/screens/main_navigation_shell.dart';

void main() {
  testWidgets('animasi tab dan perpindahan smooth antar Home, History, dan Profile',
      (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(
      const MaterialApp(
        home: MainNavigationShell(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Awalnya di halaman Home
    expect(find.text('Halo, Arka!'), findsOneWidget);
    expect(find.text('Karya Hebatku'), findsNothing);

    // 2. Klik tab History di bottom nav
    await tester.tap(find.byKey(const Key('nav_history_button')));
    await tester.pump(); // mulai animasi
    await tester.pump(const Duration(milliseconds: 150)); // pertengahan animasi meluncur
    await tester.pumpAndSettle(); // selesai animasi

    // Sudah di halaman History tanpa reload nav bar
    expect(find.text('Karya Hebatku'), findsOneWidget);
    expect(find.text('Matahari'), findsOneWidget);
    expect(find.text('Halo, Arka!'), findsNothing);

    // 3. Klik tab Home kembali
    await tester.tap(find.byKey(const Key('nav_home_button')));
    await tester.pumpAndSettle();

    // Kembali ke Home dengan animasi smooth
    expect(find.text('Halo, Arka!'), findsOneWidget);
  });
}
