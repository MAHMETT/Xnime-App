import 'dart:async';

// import 'package:flutter/foundation.dart'; // untuk compute (optional, jika parse berat)
// (Jika parsing tidak terlalu berat, compute bisa diabaikan.)
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  final ApiService _apiService = ApiService();

  DetailModel? _detail; // Akan di‐set begitu parsing data selesai
  bool _isLoading = true; // True selama fetch/parsing
  bool hasError = false; // True jika fetchDetailAnime melempar exception

  Timer? _retryTimer; // Untuk retry otomatis jika error

  // Tab (0 = Episode, 1 = Rekomendasi)
  int _selectedIndex = 0;
  final List<String> _tabs = ["Episode", "Rekomendasi"];

  @override
  void initState() {
    super.initState();
    _fetchDetailOnce();
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchDetailOnce() async {
    _retryTimer?.cancel();

    setState(() {
      _isLoading = true;
      hasError = false;
    });

    try {
      // Panggil service yang sudah mengecek JSON status di dalamnya
      final detailResult = await _apiService.fetchDetailAnime(widget.animeId);

      // Jika sampai di sini tidak exception, berarti status == 200 dan JSON berhasil di‐parse
      setState(() {
        _detail = detailResult;
        _isLoading = false;
        hasError = false;
      });
    } catch (e) {
      // Jika throws (bisa karena status != 200, parsing error, atau network error)
      setState(() {
        hasError = true;
        _isLoading = false;
      });

      // Jadwalkan retry otomatis dalam 10 detik
      _retryTimer = Timer(const Duration(seconds: 20), () {
        _fetchDetailOnce();
      });
    }
  }

  Future<void> _onRefresh() async {
    _retryTimer?.cancel();
    await _fetchDetailOnce();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _detail == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_detail != null) {
      final detail = _detail!;
      final screenWidth = MediaQuery.of(context).size.width;
      final posterHeight = screenWidth * 0.6;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.dark,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/logos/Xyutori.svg', width: 30),
              const SizedBox(width: 8),
              Text('Xnime', style: AppTextStyles.xlBold),
            ],
          ),
        ),
        body: RefreshIndicator(
          backgroundColor: AppColors.dark,
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //===== Poster + Back Button =====//
                Stack(
                  children: [
                    Image.network(
                      detail.poster,
                      width: screenWidth,
                      height: posterHeight,
                      fit: BoxFit.cover,
                    ),
                    //==== Back Button ====//
                    // Positioned(
                    //   top: 10,
                    //   left: 10,
                    //   child: CircleAvatar(
                    //     backgroundColor: AppColors.dark.withValues(alpha: 0.7),
                    //     child: IconButton(
                    //       onPressed: () => context.pop(),
                    //       icon: const Icon(
                    //         Icons.arrow_back,
                    //         color: AppColors.light,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),

                const SizedBox(height: 20),

                //===== Info Header (judul, rating, aired, status, genre) =====//
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(detail.title, style: AppTextStyles.lgBold),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Icon(Icons.star, size: 20, color: Colors.amber[700]),
                          const SizedBox(width: 4),
                          Text(
                            detail.score.isEmpty ? 'No rating' : detail.score,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[700],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('-'),
                          const SizedBox(width: 8),
                          Text(detail.aired, style: AppTextStyles.smSemiBold),
                          const SizedBox(width: 8),
                          const Text('-'),
                          const SizedBox(width: 8),
                          Text(detail.status, style: AppTextStyles.smSemiBold),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            detail.genreList
                                .map((g) => CustomGenreButton(text: g.title))
                                .toList(),
                      ),

                      const SizedBox(height: 16),

                      // Studio & Produser
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Studio : ', style: AppTextStyles.smBold),
                          Expanded(
                            child: Text(
                              detail.studios,
                              style: AppTextStyles.sm,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Produser : ', style: AppTextStyles.smBold),
                          Expanded(
                            child: Text(
                              detail.producers,
                              style: AppTextStyles.sm,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                //===== Synopsis =====//
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        detail.synopsis!.paragraphs
                            ?.map(
                              (p) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text(p, style: AppTextStyles.sm),
                              ),
                            )
                            .toList() ??
                        [],
                  ),
                ),

                const SizedBox(height: 24),

                //===== Toggle Tab (Episode / Rekomendasi) =====//
                Center(
                  child: ToggleButtons(
                    isSelected: List.generate(
                      _tabs.length,
                      (i) => _selectedIndex == i,
                    ),
                    onPressed:
                        (index) => setState(() => _selectedIndex = index),
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: AppColors.light,
                    fillColor: AppColors.primary,
                    color: AppColors.light,
                    constraints: const BoxConstraints(
                      minHeight: 40,
                      minWidth: 150,
                    ),
                    textStyle: AppTextStyles.smBold,
                    children: _tabs.map((t) => Text(t)).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                //===== Konten Berdasarkan Tab =====//
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      _selectedIndex == 0
                          // === Daftar Episode ===
                          ? _buildEpisodeList(detail)
                          // === Rekomendasi Anime ===
                          : _buildRekomendasiGrid(detail),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    }

    // Jika bukan loading (isLoading == false) dan detail masih null, berarti error:
    return const Scaffold(body: Center(child: Error404()));
  }

  /// Widget untuk daftar episode
  Widget _buildEpisodeList(DetailModel detail) {
    if (detail.episodeList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text('Tidak ada episode.'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children:
            detail.episodeList.map((e) {
              return ListTile(
                title: Text("Episode ${e.title}", style: AppTextStyles.sm),
                onTap: () {
                  context.push('/episode/${e.episodeId}');
                },
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
      ),
    );
  }

  /// Widget untuk rekomendasi anime
  Widget _buildRekomendasiGrid(DetailModel detail) {
    if (detail.recommendedAnimeList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text('Belum ada rekomendasi.'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children:
            detail.recommendedAnimeList.map((r) {
              return AnimeCard(
                animeId: r.animeId,
                imagePath: r.poster,
                title: r.title,
              );
            }).toList(),
      ),
    );
  }
}
