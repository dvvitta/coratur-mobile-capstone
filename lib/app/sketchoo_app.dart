import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'app_dependencies.dart';
import 'app_router.dart';

class SketchooApp extends StatelessWidget {
  const SketchooApp({
    super.key,
    required this.dependencies,
    this.router,
  });

  final AppDependencies dependencies;
  final AppRouter? router;

  @override
  Widget build(BuildContext context) {
    final activeRouter = router ?? AppRouter(dependencies: dependencies);

    return MaterialApp(
      title: 'SKETCHOO',
      debugShowCheckedModeBanner: dependencies.isMock,
      locale: const Locale('id'),
      theme: AppTheme.light(),
      initialRoute: activeRouter.initialRoute,
      routes: activeRouter.routes,
    );
  }
}
