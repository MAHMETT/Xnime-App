import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xnime_app/core/theme/app_colors.dart';
import 'package:xnime_app/core/theme/app_text_styles.dart';
import 'package:xnime_app/data/models/episode/episode_model.dart';
import 'package:xnime_app/data/service/api_service.dart';
import 'package:xnime_app/shared/widgets/custom_genre_button.dart';
import 'package:xnime_app/shared/widgets/error_404.dart';

class EpisodePage extends StatefulWidget {
  final String animeId;

  const EpisodePage({super.key, required this.animeId});

  @override
  State<EpisodePage> createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage> {
  Timer? _retryTimer;
  final ApiService _apiService = ApiService();
  late Future<EpisodeModel> _futureDetail;

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

  Future<EpisodeModel> _fetchWithRetry({int maxRetry = 3}) async {
    int retryCount = 0;
    while (retryCount < maxRetry) {
      try {
        final detail = await _apiService.fetchEpisodeAnime(widget.animeId);
        return detail;
      } catch (_) {
        retryCount++;
        await Future.delayed(const Duration(seconds: 10));
      }
    }
    throw Exception('Gagal memuat data setelah $maxRetry percobaan');
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<EpisodeModel>(
        future: _futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Error404();
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data'));
          }

          final detail = snapshot.data!;

          return Column(
            children: [
              // --- WebView ---
              Expanded(
                child: WebViewContainer(url: detail.defaultStreamingUrl),
              ),

              const Divider(color: Colors.grey),
              // --- (judul, genre, dll) ---
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(detail.title, style: AppTextStyles.lgBold),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Text(
                          detail.releaseTime,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const Text('-'),
                        Text(
                          detail.info.credit,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const Text('-'),
                        Text(
                          detail.info.encoder,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const Text('-'),
                        Text(
                          detail.info.type,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const Text('-'),
                        Text(
                          detail.info.duration,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:
                          detail.info.genreList
                              .map((g) => CustomGenreButton(text: g.title))
                              .toList(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Widget terpisah untuk WebView
class WebViewContainer extends StatefulWidget {
  final String url;
  const WebViewContainer({super.key, required this.url});

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
