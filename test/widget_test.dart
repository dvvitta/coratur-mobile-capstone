import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curator/app/app_dependencies.dart';
import 'package:curator/app/sketchoo_app.dart';
import 'package:curator/core/constants/asset_paths.dart';

void main() {
  testWidgets('Aplikasi membuka splash putih dengan aset logo', (tester) async {
    await tester.pumpWidget(
      SketchooApp(dependencies: AppDependencies.development()),
    );
    await tester.pump();

    expect(find.byKey(const Key('splash_logo')), findsOneWidget);
    expect(find.byKey(const Key('splash_background')), findsOneWidget);

    final logo = tester.widget<Image>(find.byKey(const Key('splash_logo')));
    expect(logo.image, const AssetImage(AssetPaths.logo));
  });
}
