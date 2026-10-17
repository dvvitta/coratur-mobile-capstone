import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/core/constants/app_routes.dart';
import 'package:curator/core/constants/asset_paths.dart';
import 'package:curator/features/onboarding/screens/onboarding_screen.dart';
import 'package:curator/features/splash/screens/splash_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget harness({Duration duration = const Duration(milliseconds: 400)}) {
    return MaterialApp(
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => SplashScreen(duration: duration),
        AppRoutes.onboarding: (_) => const OnboardingScreen(),
      },
    );
  }

  Opacity splashOpacity(WidgetTester tester, Key key) {
    return tester.widget<Opacity>(
      find.ancestor(of: find.byKey(key), matching: find.byType(Opacity)).first,
    );
  }

  testWidgets('frame 1: layar putih, logo dan background tersembunyi', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await tester.pump();

    expect(splashOpacity(tester, const Key('splash_logo')).opacity, 0);
    expect(splashOpacity(tester, const Key('splash_background')).opacity, 0);

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, Colors.white);
  });

  testWidgets('frame 2: logo fade-in sebelum background', (tester) async {
    const duration = Duration(milliseconds: 1000);
    await tester.pumpWidget(harness(duration: duration));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 280));

    final logoOpacity = splashOpacity(tester, const Key('splash_logo')).opacity;
    final backgroundOpacity = splashOpacity(
      tester,
      const Key('splash_background'),
    ).opacity;

    expect(logoOpacity, greaterThan(0.5));
    expect(backgroundOpacity, 0);
  });

  testWidgets('frame 3: background muncul dan navigasi ke onboarding', (
    tester,
  ) async {
    const duration = Duration(milliseconds: 400);
    await tester.pumpWidget(harness(duration: duration));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.textContaining('Yuk, Mulai dengan'), findsOneWidget);
    expect(find.text('Lewati'), findsOneWidget);
    expect(find.byKey(const Key('splash_logo')), findsNothing);
  });

  testWidgets('memakai aset logo dan background splash 3', (tester) async {
    await tester.pumpWidget(harness());
    await tester.pump();

    final logo = tester.widget<Image>(find.byKey(const Key('splash_logo')));
    final background = tester.widget<Image>(
      find.byKey(const Key('splash_background')),
    );

    expect(logo.image, const AssetImage(AssetPaths.logo));
    expect(background.image, const AssetImage(AssetPaths.splashFullscreen3));
    expect(background.fit, BoxFit.cover);
  });
}
