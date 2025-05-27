import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xnime_app/core/routes/app_router.dart';
import 'package:xnime_app/core/theme/app_colors.dart';
import 'package:xnime_app/core/theme/app_theme.dart';
import 'package:xnime_app/pages/anime_list_page.dart';
import 'package:xnime_app/pages/home_page.dart';
import 'package:xnime_app/pages/search_page.dart';

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

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final screens = [HomePage(), SearchPage(), AnimeListPage()];

  final items = <CurvedNavigationBarItem>[
    CurvedNavigationBarItem(
      child: Icon(Icons.home, size: 30, color: Colors.white),
      label: 'Home',
    ),
    CurvedNavigationBarItem(
      child: Icon(Icons.search, size: 30, color: Colors.white),
      label: 'Search',
    ),
    CurvedNavigationBarItem(
      child: Icon(Icons.explore, size: 30, color: Colors.white),
      label: 'Explore',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        items: items,
        backgroundColor: Colors.transparent,
        color: AppColors.black,
        buttonBackgroundColor: AppColors.black,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (newIndex) {
          setState(() {
            currentIndex = newIndex;
          });
        },
      ),
    );
  }
}
