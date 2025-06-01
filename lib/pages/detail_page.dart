import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xnime_app/core/theme/app_colors.dart';
import 'package:xnime_app/core/theme/app_text_styles.dart';
import 'package:xnime_app/data/models/detail/detail_model.dart';
import 'package:xnime_app/data/service/api_service.dart';
import 'package:xnime_app/shared/widgets/anime_card.dart';
import 'package:xnime_app/shared/widgets/custom_genre_button.dart';
import 'package:xnime_app/shared/widgets/error_404.dart';

class DetailPage extends StatefulWidget {
  final String animeId;

  const DetailPage({super.key, required this.animeId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Timer? _retryTimer;
  final ApiService _apiService = ApiService();
  late Future<DetailModel> _futureDetail;
  int selectedIndex = 0;
  final List<String> tabs = ["Episode", "Rekomendasi"];

  Future<DetailModel> _fetchWithRetry({int maxRetry = 3}) async {
    int retryCount = 0;

    while (retryCount < maxRetry) {
      try {
        final detail = await _apiService.fetchDetailAnime(widget.animeId);
        return detail;
      } catch (_) {
        retryCount++;
        await Future.delayed(const Duration(seconds: 10));
      }
    }

    throw Exception('Gagal memuat data setelah $maxRetry percobaan');
  }

  @override
  void initState() {
    super.initState();
    _futureDetail = _fetchWithRetry();
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DetailModel>(
        future: _futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Error404();
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data'));
          }
          // lanjut tampilkan UI normal...

          final detail = snapshot.data!;
          final paragraphs = detail.synopsis?.paragraphs ?? [];
          final double widthPoster = MediaQuery.of(context).size.width;
          final double heightPoster = widthPoster * 0.6;

          return SingleChildScrollView(
            // padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster dan Judul
                Center(
                  child: Stack(
                    children: [
                      // Thumbnail
                      Image.network(
                        detail.poster,
                        width: widthPoster,
                        height: heightPoster,
                        fit: BoxFit.cover,
                      ),
                      // Button Back
                      Positioned(
                        top: 10,
                        left: 10,
                        child: CircleAvatar(
                          backgroundColor: AppColors.dark.withValues(
                            alpha: 0.7,
                          ),
                          child: IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: AppColors.light,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    spacing: 5,
                    children: [
                      // Header
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(detail.title, style: AppTextStyles.lgBold),
                          // Sub
                          Row(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 20,
                                    color: Colors.amber[700],
                                  ),
                                  Text(
                                    detail.score == ''
                                        ? 'No rating'
                                        : detail.score,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber[700],
                                    ),
                                  ),
                                ],
                              ),
                              const Text('-'),
                              Text(
                                detail.aired,
                                style: AppTextStyles.smSemiBold,
                              ),
                              const Text('-'),
                              Text(
                                detail.status,
                                style: AppTextStyles.smSemiBold,
                              ),
                            ],
                          ),
                          // Genere
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children:
                                detail.genreList
                                    .map(
                                      (g) => CustomGenreButton(text: g.title),
                                    )
                                    .toList(),
                          ),
                          // Studios and Producers
                        ],
                      ),
                      Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Studio :', style: AppTextStyles.smBold),
                              Flexible(
                                child: Text(
                                  detail.studios,
                                  style: AppTextStyles.sm,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Produser :', style: AppTextStyles.smBold),
                              Flexible(
                                child: Text(
                                  detail.producers,
                                  style: AppTextStyles.sm,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Synopsis
                      ...paragraphs.map(
                        (p) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(p, style: AppTextStyles.sm),
                        ),
                      ),
                      // Episode
                      // Toggle Tab
                      Center(
                        child: ToggleButtons(
                          textStyle: AppTextStyles.smBold,
                          isSelected: List.generate(
                            tabs.length,
                            (i) => selectedIndex == i,
                          ),
                          onPressed: (index) {
                            setState(() => selectedIndex = index);
                          },
                          borderRadius: BorderRadius.circular(10),
                          selectedColor: AppColors.light,
                          fillColor: AppColors.primary,
                          color: AppColors.light,
                          constraints: const BoxConstraints(
                            minHeight: 40,
                            // minWidth: 200,
                            minWidth: 150,
                          ),
                          children: tabs.map((t) => Text(t)).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Konten berdasarkan pilihan
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child:
                            selectedIndex == 0
                                ? Column(
                                  children:
                                      detail.episodeList
                                          .map(
                                            (e) => ListTile(
                                              title: Text(
                                                "Episode ${e.title}",
                                                style: AppTextStyles.sm,
                                              ),
                                              onTap: () {
                                                context.push(
                                                  '/episode/${e.episodeId}',
                                                );
                                              },
                                            ),
                                          )
                                          .toList(),
                                )
                                : Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children:
                                      detail.recommendedAnimeList
                                          .map(
                                            (r) => AnimeCard(
                                              imagePath: r.poster,
                                              title: r.title,
                                              animeId: r.animeId,
                                            ),
                                          )
                                          .toList(),
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
