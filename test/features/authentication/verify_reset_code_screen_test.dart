import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/core/constants/app_routes.dart';
import 'package:curator/core/widgets/structure_placeholder_page.dart';
import 'package:curator/features/authentication/screens/verify_reset_code_screen.dart';

void main() {
  Widget harness({String email = 'psyy@gmail.com'}) {
    return MaterialApp(
      home: VerifyResetCodeScreen(email: email),
      routes: {
        AppRoutes.home: (_) => const StructurePlaceholderPage(
              title: 'Beranda',
              routeName: AppRoutes.home,
            ),
      },
    );
  }

  testWidgets('menampilkan teks dan 4 field digit', (tester) async {
    await tester.pumpWidget(harness());

    expect(find.text('Check your email'), findsOneWidget);
    expect(
      find.text('kami teleah mengirim kode ke psyy@gmail.com'),
      findsOneWidget,
    );
    expect(
      find.text('masukkan 4 digit kode untuk menreset sandi'),
      findsOneWidget,
    );
    expect(find.text('Verify Code'), findsOneWidget);
    expect(find.text("Haven't got the email yet? "), findsOneWidget);
    expect(find.text('Resend email'), findsOneWidget);

    for (var i = 0; i < 4; i++) {
      expect(find.byKey(Key('verify_digit_$i')), findsOneWidget);
    }
  });

  testWidgets('tombol submit aktif setelah 4 digit terisi dan pindah rute',
      (tester) async {
    await tester.pumpWidget(harness());

    // Awalnya tombol disabled karena belum 4 digit
    await tester.tap(find.byKey(const Key('verify_code_submit')));
    await tester.pump();
    expect(find.text('Beranda'), findsNothing);

    // Isi 4 digit: 4, 7, 9, 7 (sesuai contoh reset.png)
    final digits = ['4', '7', '9', '7'];
    for (var i = 0; i < 4; i++) {
      await tester.enterText(find.byKey(Key('verify_digit_$i')), digits[i]);
    }
    await tester.pump();

    await tester.tap(find.byKey(const Key('verify_code_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Beranda'), findsOneWidget);
  });

  testWidgets('resend email memunculkan snackbar', (tester) async {
    await tester.pumpWidget(harness());

    await tester.tap(find.byKey(const Key('verify_code_resend')));
    await tester.pump();

    expect(find.text('Kode baru dikirim ke psyy@gmail.com'), findsOneWidget);
  });
}
