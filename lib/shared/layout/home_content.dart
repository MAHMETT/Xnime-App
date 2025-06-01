import 'package:flutter/material.dart';
import 'package:xnime_app/data/models/home/home_model.dart';
import 'package:xnime_app/data/service/api_service.dart';
import 'package:xnime_app/shared/widgets/anime_card.dart';
import 'package:xnime_app/shared/widgets/error_404.dart';
import 'package:xnime_app/shared/widgets/title_see_all.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

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

  Future<void> refresh() async {
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
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Error404();
          }

          final animeList = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleSeeAll(goTo: '/ongoing', title: 'Episode Terbaru'),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 15,
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 15,
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
                  TitleSeeAll(goTo: '/completed', title: 'Selesai Tayang'),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 15,
                      children:
                          animeList.completed.take(9).map((anime) {
                            return AnimeCard(
                              animeId: anime.animeId,
                              imagePath: anime.poster,
                              title: anime.title,
                              episodes: anime.episodes.toString(),
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
