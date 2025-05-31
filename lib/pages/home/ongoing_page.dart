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
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;
  List<AnimeItems> _animeList = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadAnimeItems(page: _currentPage);
  }

  Future<void> refresh() async {
    _currentPage = 1;
    await _loadAnimeItems(page: _currentPage);
  }

  Future<void> _loadAnimeItems({int page = 1}) async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final response = await _apiService.fetchOngoing(page: page);
      final animeData = response['data']['animeList'] as List;
      final pagination = response['pagination'];

      final newItems =
          animeData.map((json) => AnimeItems.fromJson(json)).toList();

      setState(() {
        if (page == 1) {
          _animeList = newItems;
        } else {
          _animeList.addAll(newItems);
        }

        _currentPage = pagination['currentPage'];
        _hasNextPage = pagination['hasNextPage'];
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      _animeList.map((anime) {
                        return AnimeCard(
                          imagePath: anime.poster,
                          title: anime.title,
                          episodes: anime.episodes.toString(),
                        );
                      }).toList(),
                ),
                if (_hasNextPage)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        _loadAnimeItems(page: _currentPage + 1);
                      },
                      child:
                          _isLoadingMore
                              ? const CircularProgressIndicator()
                              : const Text(
                                'Load More',
                                style: AppTextStyles.normalSemiBold,
                              ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
