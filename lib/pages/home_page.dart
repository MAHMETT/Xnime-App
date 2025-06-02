import 'package:flutter/material.dart';
import 'package:xnime_app/shared/layout/home_content.dart';
import 'package:xnime_app/shared/widgets/banner_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Jika ingin mereaksi saat HomeContent refresh, definisikan di sini
  void _onContentRefreshed() {
    // Contoh: print pesan, analytics, dsb.
    debugPrint('HomeContent berhasil di-refresh.');
  }

  Future<void> _onRefresh() async {
    // Kalau menggunakan pull-to-refresh di HomePage, panggil juga callback di HomeContent
    _onContentRefreshed();
    // Karena HomeContent tidak expose Future load, kita beri delay sejenak
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const BannerSlider(),
              const SizedBox(height: 5),
              // Pass callback _onContentRefreshed ke HomeContent
              HomeContent(onRefresh: _onContentRefreshed),
            ],
          ),
        ),
      ),
    );
  }
}
