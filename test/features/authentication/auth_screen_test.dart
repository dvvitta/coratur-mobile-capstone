import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/core/constants/app_routes.dart';
import 'package:curator/core/constants/asset_paths.dart';
import 'package:curator/core/widgets/structure_placeholder_page.dart';
import 'package:curator/features/authentication/models/auth_tab.dart';
import 'package:curator/features/authentication/screens/auth_screen.dart';
import 'package:curator/features/authentication/services/remembered_email_store.dart';

void main() {
  Widget harness({AuthTab tab = AuthTab.login, RememberedEmailStore? store}) {
    return MaterialApp(
      home: AuthScreen(
        initialTab: tab,
        playIntro: false,
        rememberedEmailStore: store,
      ),
      routes: {
        AppRoutes.home: (_) => const StructurePlaceholderPage(
          title: 'Beranda',
          routeName: AppRoutes.home,
        ),
        AppRoutes.forgotPassword: (_) => const StructurePlaceholderPage(
          title: 'Lupa Password',
          routeName: AppRoutes.forgotPassword,
        ),
        AppRoutes.onboarding: (_) => const StructurePlaceholderPage(
          title: 'Onboarding',
          routeName: AppRoutes.onboarding,
        ),
      },
    );
  }

  testWidgets('login menampilkan gajah, tab, dan form', (tester) async {
    await tester.pumpWidget(harness());

    expect(find.byKey(const Key('auth_elephant')), findsOneWidget);
    expect(find.text('Masuk'), findsWidgets);
    expect(find.text('Daftar'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Ingat saya'), findsOneWidget);
    expect(find.text('Lupa Sandi?'), findsOneWidget);

    final elephant = tester.widget<Image>(
      find.byKey(const Key('auth_elephant')),
    );
    expect(elephant.image, const AssetImage(AssetPaths.authElephant));
  });

  testWidgets('tab Daftar menampilkan field Nama', (tester) async {
    await tester.pumpWidget(harness());

    await tester.tap(find.byKey(const Key('auth_tab_register')));
    await tester.pumpAndSettle();

    expect(find.text('Nama'), findsOneWidget);
    expect(find.text('Konfirmasi Password'), findsOneWidget);
    expect(find.byKey(const Key('auth_confirm_password')), findsOneWidget);
    expect(find.text('Ingat saya'), findsNothing);
  });

  testWidgets('daftar menolak konfirmasi password yang tidak sama', (
    tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(harness(tab: AuthTab.register));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('auth_name')), 'Pasya');
    await tester.enterText(
      find.byKey(const Key('auth_email')),
      'pasya@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('auth_password')),
      'password123',
    );
    await tester.enterText(
      find.byKey(const Key('auth_confirm_password')),
      'password321',
    );
    await tester.pumpAndSettle();

    expect(find.text('Password tidak cocok'), findsOneWidget);

    await tester.tap(find.byKey(const Key('auth_submit')));
    await tester.pumpAndSettle();

    // Tetap di halaman daftar karena konfirmasi belum cocok.
    expect(find.text('Beranda'), findsNothing);
  });

  testWidgets('daftar berhasil menuju beranda saat password cocok', (
    tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(harness(tab: AuthTab.register));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('auth_name')), 'Pasya');
    await tester.enterText(
      find.byKey(const Key('auth_email')),
      'pasya@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('auth_password')),
      'password123',
    );
    await tester.enterText(
      find.byKey(const Key('auth_confirm_password')),
      'password123',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('auth_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Beranda'), findsOneWidget);
  });

  testWidgets('validasi email dan password di login', (tester) async {
    await tester.pumpWidget(harness());

    await tester.tap(find.byKey(const Key('auth_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Password wajib diisi'), findsOneWidget);
  });

  testWidgets('mock login menuju beranda', (tester) async {
    await tester.pumpWidget(harness());

    await tester.enterText(
      find.byKey(const Key('auth_email')),
      'guru@demo.test',
    );
    await tester.enterText(find.byKey(const Key('auth_password')), '123456');
    await tester.tap(find.byKey(const Key('auth_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Beranda'), findsOneWidget);
  });

  testWidgets('Google memberitahu belum terhubung', (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(harness());
    await tester.tap(find.byKey(const Key('auth_google')));
    await tester.pump();

    expect(find.text('Masuk dengan Google belum terhubung.'), findsOneWidget);
  });

  testWidgets('halaman daftar tidak memakai efek stretch saat ditarik', (
    tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(harness(tab: AuthTab.register));
    await tester.pumpAndSettle();

    // Indikator overscroll Android (isi halaman memanjang) tidak dipasang.
    expect(find.byType(StretchingOverscrollIndicator), findsNothing);

    final listFinder = find.byType(ListView);
    final position = tester
        .state<ScrollableState>(
          find
              .descendant(of: listFinder, matching: find.byType(Scrollable))
              .first,
        )
        .position;
    expect(position.pixels, 0);

    // Tarik ke bawah melewati batas atas: isi halaman tetap diam.
    await tester.drag(listFinder, const Offset(0, 300));
    await tester.pumpAndSettle();
    expect(position.pixels, 0);

    // Scroll ke atas tetap berfungsi agar tombol Daftar bisa dijangkau.
    await tester.drag(listFinder, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(position.pixels, greaterThan(0));
  });

  testWidgets('proporsi gajah dan kartu sesuai desain Figma', (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    // Ukuran acuan Figma 412 x 917
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(harness(tab: AuthTab.login));
    await tester.pumpAndSettle();

    final elephantFinder = find.byKey(const Key('auth_elephant'));
    expect(elephantFinder, findsOneWidget);
    final elephantSize = tester.getSize(elephantFinder);
    // Aspek rasio gajah 1024x1536 harus tetap terjaga (1.5)
    expect(elephantSize.height / elephantSize.width, closeTo(1.5, 0.01));

    // Tab Daftar: form nama muncul dan posisi gajah tetap proporsional
    await tester.tap(find.byKey(const Key('auth_tab_register')));
    await tester.pumpAndSettle();

    final elephantRegisterSize = tester.getSize(elephantFinder);
    expect(
      elephantRegisterSize.height / elephantRegisterSize.width,
      closeTo(1.5, 0.01),
    );
  });

  group('Ingat saya', () {
    testWidgets('email terakhir terisi otomatis dan toggle aktif', (
      tester,
    ) async {
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      tester.view.physicalSize = const Size(412, 917);
      tester.view.devicePixelRatio = 1;

      final store = InMemoryRememberedEmailStore('arka@example.com');
      await tester.pumpWidget(harness(store: store));
      await tester.pumpAndSettle();

      expect(find.text('arka@example.com'), findsOneWidget);
      final checkbox = tester.widget<Checkbox>(
        find.byKey(const Key('auth_remember')),
      );
      expect(checkbox.value, isTrue);
    });

    testWidgets('login dengan toggle aktif menyimpan email', (tester) async {
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      tester.view.physicalSize = const Size(412, 917);
      tester.view.devicePixelRatio = 1;

      final store = InMemoryRememberedEmailStore();
      await tester.pumpWidget(harness(store: store));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'baru@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.byKey(const Key('auth_remember')));
      await tester.pump();

      await tester.tap(find.byKey(const Key('auth_submit')));
      await tester.pumpAndSettle();

      expect(await store.read(), 'baru@example.com');
      expect(find.text('Beranda'), findsOneWidget);
    });

    testWidgets('login tanpa toggle menghapus email tersimpan', (tester) async {
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      tester.view.physicalSize = const Size(412, 917);
      tester.view.devicePixelRatio = 1;

      final store = InMemoryRememberedEmailStore('lama@example.com');
      await tester.pumpWidget(harness(store: store));
      await tester.pumpAndSettle();

      // Matikan "Ingat saya" lalu masuk dengan email lain.
      await tester.tap(find.byKey(const Key('auth_remember')));
      await tester.pump();
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'lain@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');

      await tester.tap(find.byKey(const Key('auth_submit')));
      await tester.pumpAndSettle();

      expect(await store.read(), isNull);
    });
  });
}
