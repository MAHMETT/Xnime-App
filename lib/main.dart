import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xnime_app/core/routes/app_router.dart';
import 'package:xnime_app/core/theme/app_colors.dart';
import 'package:xnime_app/core/theme/app_text_styles.dart';
import 'package:xnime_app/core/theme/app_theme.dart';
import 'package:xnime_app/pages/explore_page.dart';
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

  // final screens = [HomePage(), SearchPage(), ExplorePage()];

  // ✅ Simpan halaman yang sudah dirender
  final List<Widget?> _pages = List.filled(3, null);

  // ✅ Render hanya saat pertama dibuka
  Widget screens(int index) {
    if (_pages[index] != null) return _pages[index]!;

    switch (index) {
      case 0:
        _pages[0] = const HomePage(); // Page 1
        break;
      case 1:
        _pages[1] = const SearchPage(); // Page 2
        break;
      case 2:
        _pages[2] = const ExplorePage(); // Page 3
        break;
    }
    return _pages[index]!;
  }

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
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/logos/Xyutori.svg', width: 30),
            Text('Xnime', style: AppTextStyles.xlBold),
          ],
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: List.generate(_pages.length, (i) => screens(i)),
      ),

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
