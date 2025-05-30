import 'package:xnime_app/data/models/detail/episode_list.dart';
import 'package:xnime_app/data/models/detail/recomended_list.dart';
import 'package:xnime_app/data/models/detail/synopsis_section.dart';
import 'package:xnime_app/data/models/genre_items_model.dart';

class DetailModel {
  final String title;
  final String poster;
  final String japanese;
  final String score;
  final String producers;
  final String status;
  final String duration;
  final String aired;
  final String studios;
  final List<SynopsisSection> synopsis;
  final List<GenreItemsModel> genreList;
  final List<EpisodeList> episodeList;
  final List<RecommendedAnime> recommendedAnimeList;

  const DetailModel({
    required this.title,
    required this.poster,
    required this.japanese,
    required this.score,
    required this.producers,
    required this.status,
    required this.duration,
    required this.aired,
    required this.studios,
    required this.synopsis,
    required this.genreList,
    required this.episodeList,
    required this.recommendedAnimeList,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) => DetailModel(
    title: json['title'],
    poster: json['poster'],
    japanese: json['japanese'],
    score: json['score'],
    producers: json['producers'],
    status: json['status'],
    duration: json['duration'],
    aired: json['aired'],
    studios: json['studios'],
    synopsis:
        (json['synopsis'] as List)
            .map((synopsis) => SynopsisSection.fromJson(synopsis))
            .toList(),
    genreList:
        (json['genreList'] as List)
            .map((genre) => GenreItemsModel.fromJson(genre))
            .toList(),
    episodeList:
        (json['episodeList'] as List)
            .map((episode) => EpisodeList.fromJson(episode))
            .toList(),
    recommendedAnimeList:
        (json['recommendedAnimeList'] as List)
            .map((recomend) => RecommendedAnime.fromJson(recomend))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "poster": poster,
    "japanese": japanese,
    "score": score,
    "producers": producers,
    "status": status,
    "duration": duration,
    "aired": aired,
    "studios": studios,
    "synopsis": synopsis.map((s) => s.toJson()).toList(),
    "genreList": genreList.map((g) => g.toJson()).toList(),
    "episodeList": episodeList.map((e) => e.toJson()).toList(),
    "recommendedAnimeList":
        recommendedAnimeList.map((r) => r.toJson()).toList(),
  };
}
