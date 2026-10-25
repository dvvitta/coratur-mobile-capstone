import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/core/constants/app_routes.dart';
import 'package:curator/features/profile/screens/profile_screen.dart';

void main() {
  testWidgets('menampilkan header profil, info user, 3 kartu stat, pengaturan, dan keluar akun',
      (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = const Size(412, 1055);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Header
    expect(find.text('Profilku'), findsOneWidget);
    expect(find.text('Arka'), findsOneWidget);
    expect(find.byKey(const Key('profile_edit_avatar_button')), findsOneWidget);
    expect(find.text('Pelukis Cilik • Level 3'), findsOneWidget);
    expect(find.text('2 bintang lagi jadi Pelukis Hebat!'), findsOneWidget);

    // 2. Tiga Stat (Gambar, Bintang, Hari beruntun)
    expect(find.byKey(const Key('profile_stat_drawings')), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('Gambar'), findsOneWidget);

    expect(find.byKey(const Key('profile_stat_stars')), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text('Bintang'), findsOneWidget);

    expect(find.byKey(const Key('profile_stat_streak')), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Hari\nberuntun'), findsOneWidget);

    // 3. Pengaturan
    expect(find.text('Pengaturan'), findsOneWidget);
    expect(find.text('Suara'), findsOneWidget);
    expect(find.text('Musik'), findsOneWidget);
    expect(find.text('Kode Ruang Kelas'), findsOneWidget);
    expect(find.text('Bantuan'), findsOneWidget);

    // 4. Toggle switch Suara
    await tester.tap(find.byKey(const Key('profile_switch_sound')));
    await tester.pumpAndSettle();

    // 5. Tombol Keluar Akun
    expect(find.byKey(const Key('profile_logout_button')), findsOneWidget);
    expect(find.text('Keluar Akun'), findsOneWidget);
  });

  testWidgets('tap keluar akun menampilkan dialog konfirmasi', (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = const Size(412, 1055);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.login: (_) => const Scaffold(body: Text('Login Screen')),
        },
        home: const ProfileScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('profile_logout_button')));
    await tester.pumpAndSettle();

    expect(find.text('Keluar Akun?'), findsOneWidget);
    expect(find.text('Apakah kamu yakin ingin keluar dari akun ini?'), findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);

    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();

    expect(find.text('Login Screen'), findsOneWidget);
  });
}
