import 'package:flutter/material.dart';
import 'package:xnime_app/shared/widgets/banner_slider.dart';
import 'package:xnime_app/data/models/home/home_model.dart';
import 'package:xnime_app/data/service/api_service.dart';
import 'package:xnime_app/shared/widgets/anime_card.dart';
import 'package:xnime_app/shared/widgets/error_404.dart';
import 'package:xnime_app/shared/widgets/title_see_all.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<HomeModel> _futureHomeModel;

  /// Jika ingin mereaksi saat HomeContent refresh, definisikan di sini
  void _onContentRefreshed() {
    // Contoh: print pesan, analytics, dsb.
    debugPrint('HomeContent berhasil di-refresh.');
  }

  Future<void> _onRefresh() async {
    // Kalau menggunakan pull-to-refresh di HomePage, panggil juga callback di HomeContent
    _onContentRefreshed();
    _reloadData();
    // Karena HomeContent tidak expose Future load, kita beri delay sejenak
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _reloadData() async {
    setState(() {
      _futureHomeModel = _loadHomeModel();
    });
  }

  Future<HomeModel> _loadHomeModel() async {
    return await _apiService.fetchHome();
  }

  @override
  void initState() {
    super.initState();
    _futureHomeModel = _loadHomeModel();
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
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder<HomeModel>(
                  future: _futureHomeModel,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Error404();
                    }

                    final animeList = snapshot.data!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Episode Terbaru
                        TitleSeeAll(goTo: '/ongoing', title: 'Episode Terbaru'),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.spaceBetween,
                          children:
                              animeList.ongoing.take(9).map((anime) {
                                return AnimeCard(
                                  animeId: anime.animeId,
                                  imagePath: anime.poster,
                                  title: anime.title,
                                  episodes: anime.episodes.toString(),
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 20),

                        // Section Selesai Tayang
                        TitleSeeAll(
                          goTo: '/completed',
                          title: 'Selesai Tayang',
                        ),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                animeList.completed.take(9).map((anime) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: AnimeCard(
                                      animeId: anime.animeId,
                                      imagePath: anime.poster,
                                      title: anime.title,
                                      episodes: anime.episodes.toString(),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
