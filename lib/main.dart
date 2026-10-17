import 'package:flutter/material.dart';

import 'app/app_dependencies.dart';
import 'app/sketchoo_app.dart';

void main() {
  final dependencies = AppDependencies.development();
  runApp(SketchooApp(dependencies: dependencies));
}
