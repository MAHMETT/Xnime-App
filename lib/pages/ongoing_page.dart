import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xnime_app/core/theme/app_colors.dart';
import 'package:xnime_app/core/theme/app_text_styles.dart';
import 'package:xnime_app/data/models/anime_items_model.dart';
import 'package:xnime_app/data/service/api_service.dart';
import 'package:xnime_app/shared/widgets/anime_card.dart';

class OngoingPage extends StatefulWidget {
  const OngoingPage({super.key});

  @override
  State<OngoingPage> createState() => _OngoingPageState();
}

class _OngoingPageState extends State<OngoingPage> {
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
    final rawItems = await _apiService.fetchOngoing();
    return rawItems.map((json) => AnimeItems.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/logos/Xyutori.svg', width: 30),
            Text('Xnime', style: AppTextStyles.xlBold),
          ],
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: AppColors.dark,
        onRefresh: refresh,
        child: FutureBuilder<List<AnimeItems>>(
          future: _futureAnimeItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: SvgPicture.asset('assets/images/404.svg'));
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
                          episodes: anime.episodes.toString(),
                        );
                      }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
