import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xnime_app/core/routes/app_router.dart';
import 'package:xnime_app/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
  } catch (_) {
    debugPrint('.env not found, using default API_BASE_URL');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Xnime',
      theme: AppTheme.def,
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.def,
      routerConfig: router,
    );
  }
}
