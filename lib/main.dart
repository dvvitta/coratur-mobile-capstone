import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app_dependencies.dart';
import 'app/sketchoo_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Abaikan jika .env tidak ditemukan, fallback ke mock/default
  }

  final apiBaseUrl = dotenv.env['API_BASE_URL'];
  final dependencies = AppDependencies.development(apiBaseUrl: apiBaseUrl);

  runApp(SketchooApp(dependencies: dependencies));
}
