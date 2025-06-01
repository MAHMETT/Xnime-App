import 'package:flutter/material.dart';
import 'package:xnime_app/data/models/detail/detail_model.dart';
import 'package:xnime_app/data/service/api_service.dart';

class DetailPage extends StatefulWidget {
  final String animeId;

  const DetailPage({super.key, required this.animeId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ApiService _apiService = ApiService();
  late Future<DetailModel> _futureDetail;

  @override
  void initState() {
    super.initState();
    _futureDetail = _apiService.fetchDetailAnime(widget.animeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Anime')),
      body: FutureBuilder<DetailModel>(
        future: _futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data'));
          }

          final detail = snapshot.data!;
          final paragraphs = detail.synopsis?.paragraphs ?? [];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster dan Judul
                Center(
                  child: Column(
                    children: [
                      Image.network(detail.poster, height: 250),
                      const SizedBox(height: 16),
                      Text(
                        detail.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Info Umum
                Text("Skor: ${detail.score}"),
                Text("Status: ${detail.status}"),
                Text("Durasi: ${detail.duration}"),
                Text("Tayang: ${detail.aired}"),
                Text("Studio: ${detail.studios}"),
                Text("Produser: ${detail.producers}"),

                const SizedBox(height: 16),
                const Text(
                  "Sinopsis:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                ...paragraphs.map(
                  (p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(p),
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  "Genre:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                Wrap(
                  spacing: 8,
                  children:
                      detail.genreList
                          .map((g) => Chip(label: Text(g.title)))
                          .toList(),
                ),

                const SizedBox(height: 16),
                const Text(
                  "Episode List:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  children:
                      detail.episodeList
                          .map(
                            (e) => ListTile(
                              title: Text("Episode ${e.title}"),
                              onTap: () {},
                            ),
                          )
                          .toList(),
                ),

                const SizedBox(height: 16),
                const Text(
                  "Rekomendasi:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  children:
                      detail.recommendedAnimeList
                          .map(
                            (r) => ListTile(
                              leading: Image.network(r.poster, width: 50),
                              title: Text(r.title),
                              onTap: () {
                                // Pindah ke detail anime yang direkomendasikan
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DetailPage(animeId: r.animeId),
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
