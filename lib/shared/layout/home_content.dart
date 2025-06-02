import 'package:flutter/material.dart';
import 'package:xnime_app/data/models/home/home_model.dart';
import 'package:xnime_app/data/service/api_service.dart';
import 'package:xnime_app/shared/widgets/anime_card.dart';
import 'package:xnime_app/shared/widgets/error_404.dart';
import 'package:xnime_app/shared/widgets/title_see_all.dart';

class HomeContent extends StatefulWidget {
  // Tambahkan callback onRefresh
  final VoidCallback? onRefresh;

  const HomeContent({super.key, this.onRefresh});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final ApiService _apiService = ApiService();
  late Future<HomeModel> _futureHomeModel;

  @override
  void initState() {
    super.initState();
    _futureHomeModel = _loadHomeModel();
  }

  /// Metode internal untuk reload data
  Future<void> _reloadData() async {
    setState(() {
      _futureHomeModel = _loadHomeModel();
    });
  }

  Future<HomeModel> _loadHomeModel() async {
    return await _apiService.fetchHome();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              // Tombol atau area khusus untuk trigger refresh di HomeContent,
              // misalnya icon refresh di pojok kanan atas:
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    // Load ulang data lokal
                    _reloadData();
                    // Sebagai tambahan, panggil callback parent jika ada
                    widget.onRefresh?.call();
                  },
                ),
              ),

              // Section Episode Terbaru
              TitleSeeAll(goTo: '/ongoing', title: 'Episode Terbaru'),
              const SizedBox(height: 20),
              Wrap(
                spacing: 15,
                runSpacing: 15,
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
              TitleSeeAll(goTo: '/completed', title: 'Selesai Tayang'),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      animeList.completed.take(9).map((anime) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
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
    );
  }
}
