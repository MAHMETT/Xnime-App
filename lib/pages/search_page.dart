import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xnime_app/core/theme/app_colors.dart';
import 'package:xnime_app/core/theme/app_text_styles.dart';
import 'package:xnime_app/data/models/anime_items_model.dart';
import 'package:xnime_app/data/service/api_service.dart';
import 'package:xnime_app/shared/widgets/anime_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  Future<List<AnimeItems>>? _futureSearchResults;

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _futureSearchResults = null;
      } else {
        _futureSearchResults = _apiService.fetchSearchAnime(query);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: _performSearch,
              style: AppTextStyles.normalSemiBold,
              decoration: InputDecoration(
                hintText: 'Cari anime...',
                hintStyle: AppTextStyles.normalSemiBold,
                prefixIcon: const Icon(Icons.search),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Expanded(
            child:
                _futureSearchResults == null
                    ? const Center(child: Text(''))
                    : FutureBuilder<List<AnimeItems>>(
                      future: _futureSearchResults,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: SvgPicture.asset('assets/images/404.svg'),
                          );
                        }

                        final results = snapshot.data!;
                        if (results.isEmpty) {
                          return const Center(child: Text('No results found'));
                        }

                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(12),
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Center(
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children:
                                  results.map((anime) {
                                    return AnimeCard(
                                      imagePath: anime.poster,
                                      title: anime.title,
                                      rating: anime.score,
                                      status: anime.status,
                                    );
                                  }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
