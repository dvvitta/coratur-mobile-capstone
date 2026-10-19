import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/core/constants/app_routes.dart';
import 'package:curator/core/constants/asset_paths.dart';
import 'package:curator/core/widgets/structure_placeholder_page.dart';
import 'package:curator/features/authentication/screens/forgot_password_screen.dart';

void main() {
  Widget harness() {
    return MaterialApp(
      home: const ForgotPasswordScreen(),
      routes: {
        AppRoutes.verifyResetCode: (context) {
          final email = ModalRoute.of(context)?.settings.arguments as String?;
          return StructurePlaceholderPage(
            title: 'Verify $email',
            routeName: AppRoutes.verifyResetCode,
          );
        },
      },
    );
  }

  testWidgets('menampilkan header, gajah lupa sandi, input, dan tombol',
      (tester) async {
    await tester.pumpWidget(harness());

    expect(find.text('Lupa Sandi'), findsOneWidget);
    expect(
      find.text('Masukkin email kamu dulu yuk buat reset sandinya!'),
      findsOneWidget,
    );
    expect(find.text('Your Email'), findsOneWidget);
    expect(find.text('Reset Password'), findsOneWidget);

    final elephantFinder = find.byKey(const Key('forgot_password_elephant'));
    expect(elephantFinder, findsOneWidget);

    final elephant = tester.widget<Image>(elephantFinder);
    expect(
      elephant.image,
      const AssetImage(AssetPaths.forgotPasswordElephant),
    );
  });

  testWidgets('validasi format email wajib diisi dan valid', (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(harness());

    // Submit kosong
    await tester.tap(find.byKey(const Key('forgot_password_submit')));
    await tester.pumpAndSettle();
    expect(find.text('Email wajib diisi'), findsOneWidget);

    // Format tidak valid
    await tester.enterText(
      find.byKey(const Key('forgot_password_email')),
      'invalid-email',
    );
    await tester.tap(find.byKey(const Key('forgot_password_submit')));
    await tester.pumpAndSettle();
    expect(find.text('Format email tidak valid'), findsOneWidget);

    // Format benar
    await tester.enterText(
      find.byKey(const Key('forgot_password_email')),
      'psyy@gmail.com',
    );
    await tester.tap(find.byKey(const Key('forgot_password_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Verify psyy@gmail.com'), findsOneWidget);
  });

  testWidgets('tombol back mengembalikan layar atau navigasi', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Lupa Sandi'), findsOneWidget);
    await tester.tap(find.byKey(const Key('forgot_password_back')));
    await tester.pumpAndSettle();

    expect(find.text('Open'), findsOneWidget);
  });
}
