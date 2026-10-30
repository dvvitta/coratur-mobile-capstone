import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/core/constants/app_routes.dart';
import 'package:curator/features/home/screens/home_screen.dart';
import 'package:curator/features/missions/screens/missions_screen.dart';

void main() {
  Widget harness() {
    return MaterialApp(
      routes: {
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.missions: (_) => const MissionsScreen(),
        AppRoutes.history: (_) => const Scaffold(body: Text('History Screen')),
        AppRoutes.profile: (_) => const Scaffold(body: Text('Profile Screen')),
      },
      home: const HomeScreen(),
    );
  }

  testWidgets('menampilkan greeting user, petualangan, belajar, dan misi',
      (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = const Size(412, 1055);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(harness());

    expect(find.text('Halo, Arka!'), findsOneWidget);
    expect(find.text('Petualangan Hari ini'), findsOneWidget);
    expect(find.text('Mau Belajar apa hari ini?'), findsOneWidget);
    expect(find.text('Sketch Challenge'), findsWidgets);
    expect(find.text('Jelajah Cilik'), findsOneWidget);
    expect(find.text('Sketch-to-Story'), findsWidgets);
    expect(find.text('Misi'), findsOneWidget);
    expect(find.text('Lihat semua'), findsOneWidget);
  });

  testWidgets('klik Lihat semua membuka halaman Misi', (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = const Size(412, 1055);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(harness());

    await tester.tap(find.byKey(const Key('home_see_all_missions')));
    await tester.pumpAndSettle();

    // Di halaman Misi
    expect(find.text('Misi'), findsOneWidget);
    expect(find.text('Kembali'), findsOneWidget);
    expect(find.text('1 dari 4 misi selesai'), findsOneWidget);
    expect(find.text('Selesaikan semua misi'), findsOneWidget);

    // Tombol kembali kembali ke Home
    await tester.tap(find.byKey(const Key('missions_back_button')));
    await tester.pumpAndSettle();

    expect(find.text('Halo, Arka!'), findsOneWidget);
  });

  testWidgets('nav bar bawah membuka halaman History dan Profile',
      (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = const Size(412, 1055);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(harness());

    // Navigasi ke History
    await tester.tap(find.byKey(const Key('nav_history_button')));
    await tester.pumpAndSettle();
    expect(find.text('History Screen'), findsOneWidget);

    // Kembali ke Home
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pop();
    await tester.pumpAndSettle();

    // Navigasi ke Profile
    await tester.tap(find.byKey(const Key('nav_profile_button')));
    await tester.pumpAndSettle();
    expect(find.text('Profile Screen'), findsOneWidget);
  });
}
