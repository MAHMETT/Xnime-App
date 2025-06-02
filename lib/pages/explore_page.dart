import 'package:flutter/material.dart';
import 'package:xnime_app/core/theme/app_colors.dart';
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

  // State untuk pagination
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  // Data yang ditampilkan
  final List<AnimeItems> _animeList = [];

  @override
  void initState() {
    super.initState();
    _fetchAnimeItems(page: _currentPage);
  }

  /// Pull-to-refresh: reset ke halaman 1 dan ambil ulang data
  Future<void> _onRefresh() async {
    _currentPage = 1;
    _hasNextPage = true;
    await _fetchAnimeItems(page: 1, replace: true);
  }

  Future<void> _fetchAnimeItems({
    required int page,
    bool replace = false,
  }) async {
    if (_isLoadingMore || (!_hasNextPage && !replace)) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final response = await _apiService.fetchOngoing(page: page);
      final rawList = response['data']['animeList'] as List<dynamic>;
      final pagination = response['pagination'] as Map<String, dynamic>;

      // Ubah JSON ke model
      final newItems =
          rawList
              .map((json) => AnimeItems.fromJson(json as Map<String, dynamic>))
              .toList();

      setState(() {
        if (replace) {
          _animeList
            ..clear()
            ..addAll(newItems);
        } else {
          _animeList.addAll(newItems);
        }

        _currentPage = pagination['currentPage'] as int;
        _hasNextPage = pagination['hasNextPage'] as bool;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  /// Dipanggil ketika scroll mendekati bawah
  void _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final maxScroll = notification.metrics.maxScrollExtent;
      final currentScroll = notification.metrics.pixels;

      // Ketika sudah mendekati 200px sebelum akhir, dan masih ada halaman berikutnya
      if (!_isLoadingMore && _hasNextPage && currentScroll >= maxScroll - 200) {
        _fetchAnimeItems(page: _currentPage + 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        backgroundColor: AppColors.dark,
        onRefresh: _onRefresh,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            _onScrollNotification(notification);
            return false;
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul section (boleh di‐extract jadi widget terpisah jika banyak section)
                const Text(
                  'Explore Anime',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Grid fleksibel: Wrap yang membagi spasi di antar item
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      _animeList.map((anime) {
                        return AnimeCard(
                          animeId: anime.animeId,
                          imagePath: anime.poster,
                          title: anime.title,
                          episodes: anime.episodes.toString(),
                        );
                      }).toList(),
                ),

                // Spacer sebelum loading indicator
                const SizedBox(height: 20),

                // Jika masih ada halaman berikutnya, tampilkan loading spinner saat fetch lebih lanjut
                if (_isLoadingMore)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(),
                    ),
                  ),

                // Kalau tidak ada lagi halaman berikutnya dan list kosong, tampilkan pesan
                if (!_isLoadingMore && _animeList.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'Belum ada anime untuk ditampilkan.',
                        style: TextStyle(fontSize: 16),
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
