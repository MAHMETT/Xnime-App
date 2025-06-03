import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xnime_app/core/theme/app_colors.dart';
import 'package:xnime_app/core/theme/app_text_styles.dart';
import 'package:xnime_app/data/models/episode/stream_anime_model.dart';
import 'package:xnime_app/data/service/api_service.dart';
import 'package:xnime_app/shared/widgets/custom_genre_button.dart';
import 'package:xnime_app/shared/widgets/error_404.dart';

class StreamPage extends StatefulWidget {
  final String animeId;

  const StreamPage({super.key, required this.animeId});

  @override
  State<StreamPage> createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  Timer? _retryTimer;
  final ApiService _apiService = ApiService();
  late Future<StreamAnimeModel> _futureDetail;

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

  Future<StreamAnimeModel> _fetchWithRetry({int maxRetry = 3}) async {
    int retryCount = 0;
    while (retryCount < maxRetry) {
      try {
        final detail = await _apiService.fetchStreamAnime(widget.animeId);
        return detail;
      } catch (_) {
        retryCount++;
        await Future.delayed(const Duration(seconds: 10));
      }
    }
    throw Exception('Gagal memuat data setelah $maxRetry percobaan');
  }

  Future<void> _onRefresh() async {
    _retryTimer?.cancel();
    await _fetchWithRetry();
    await Future.delayed(const Duration(milliseconds: 300));
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
      body: FutureBuilder<StreamAnimeModel>(
        future: _futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Scaffold(
              body: RefreshIndicator(
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  child: Center(child: Column(children: [const Error404()])),
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data'));
          }

          final detail = snapshot.data!;
          final screenWidth = MediaQuery.of(context).size.width;
          final streamHeight = screenWidth * 0.6;

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // --- WebView ---
                  SizedBox(
                    width: screenWidth,
                    height: streamHeight,
                    child: WebViewContainer(
                      key: _webViewKey,
                      url: detail.defaultStreamingUrl,
                    ),
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
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 8),
                        Table(
                          // border:TableBorder,
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(0.5),
                            2: FlexColumnWidth(5),
                          },
                          children: [
                            TableRow(
                              children: [
                                Text(
                                  'Release time',
                                  style: AppTextStyles.smBold,
                                ),
                                Text(':', style: AppTextStyles.smBold),
                                Text(
                                  detail.releaseTime,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text('Credit', style: AppTextStyles.smBold),
                                Text(':', style: AppTextStyles.smBold),
                                Text(
                                  detail.info.credit,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text('Encoder', style: AppTextStyles.smBold),
                                Text(':', style: AppTextStyles.smBold),
                                Text(
                                  detail.info.encoder,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text('Type', style: AppTextStyles.smBold),
                                Text(':', style: AppTextStyles.smBold),
                                Text(
                                  detail.info.type,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text('Duration', style: AppTextStyles.smBold),
                                Text(':', style: AppTextStyles.smBold),
                                Text(
                                  detail.info.duration,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children:
                              detail.info.genreList
                                  .map((g) => CustomGenreButton(text: g.title))
                                  .toList(),
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
    // final screenWidth = MediaQuery.of(context).size.width;
    // final streamHeight = screenWidth * 0.6;

    return WebViewWidget(controller: _controller);
  }
}

final GlobalKey<_WebViewContainerState> _webViewKey = GlobalKey();
