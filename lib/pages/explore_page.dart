import 'package:flutter/material.dart';
import 'package:xnime_app/data/models/anime_items_model.dart';
import 'package:xnime_app/data/service/api_service.dart';
import 'package:xnime_app/shared/widgets/anime_card.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final ApiService _apiService = ApiService();
  late Future<List<AnimeItems>> _futureAnimeItems;

  @override
  void initState() {
    super.initState();
    _futureAnimeItems = _loadAnimeItems();
  }

  Future<void> refresh() async {
    setState(() {
      _futureAnimeItems = _loadAnimeItems();
    });
  }

  Future<List<AnimeItems>> _loadAnimeItems() async {
    final rawItems = await _apiService.fetchHome();
    return rawItems.map((json) => AnimeItems.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: FutureBuilder<List<AnimeItems>>(
        future: _futureAnimeItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Periksa Koneksi Internetmu"));
          }

          final animeList = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    animeList.map((anime) {
                      return AnimeCard(
                        imagePath: anime.poster,
                        title: anime.title,
                      );
                    }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
