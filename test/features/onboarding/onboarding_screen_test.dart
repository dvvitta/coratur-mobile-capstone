import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/core/constants/app_routes.dart';
import 'package:curator/core/widgets/structure_placeholder_page.dart';
import 'package:curator/features/onboarding/screens/onboarding_screen.dart';

void main() {
  Widget harness() {
    return MaterialApp(
      home: const OnboardingScreen(),
      routes: {
        AppRoutes.login: (_) => const StructurePlaceholderPage(
          title: 'Login',
          routeName: AppRoutes.login,
        ),
      },
    );
  }

  testWidgets('halaman 1 menampilkan teks dan Lewati', (tester) async {
    await tester.pumpWidget(harness());

    expect(find.textContaining('Yuk, Mulai dengan'), findsOneWidget);
    expect(find.text('Lewati'), findsOneWidget);
    expect(find.text('Lanjut'), findsOneWidget);
  });

  testWidgets('Lanjut membuka halaman 2 lalu 3', (tester) async {
    await tester.pumpWidget(harness());

    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Jelajahi dunia'), findsOneWidget);
    expect(find.text('Lewati'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Gambar jadi cerita'), findsOneWidget);
    expect(find.text('Lewati'), findsOneWidget);
  });

  testWidgets('Lewati di halaman 1 menuju login', (tester) async {
    await tester.pumpWidget(harness());

    await tester.tap(find.byKey(const Key('onboarding_skip')));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Lewati di halaman 2 menuju login', (tester) async {
    await tester.pumpWidget(harness());

    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_skip')));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Lewati di halaman 3 menuju login', (tester) async {
    await tester.pumpWidget(harness());

    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_skip')));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Lanjut di halaman terakhir menuju login', (tester) async {
    await tester.pumpWidget(harness());

    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
  });
}
