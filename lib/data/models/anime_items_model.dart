import 'package:flutter/foundation.dart';
import 'package:xnime_app/data/models/genre_items_model.dart';

@immutable
class AnimeItems {
  final String title;
  final String poster;
  final int episodes;
  final String animeId;
  final String href;
  final String? score;
  final String? status;
  final List<GenreItemsModel> genreList;

  const AnimeItems({
    required this.title,
    required this.poster,
    required this.animeId,
    required this.episodes,
    required this.href,
    required this.score,
    required this.genreList,
    this.status,
  });

  factory AnimeItems.fromJson(Map<String, dynamic> json) => AnimeItems(
    title: json['title'] ?? '',
    poster: json['poster'] ?? '',
    animeId: json['animeId'] ?? '',
    episodes: json['episodes'] ?? 0,
    href: json['href'] ?? '',
    score: json['score'] ?? '',
    status: json['status'] ?? '',
    genreList:
        (json['genreList'] is List)
            ? (json['genreList'] as List)
                .map((item) => GenreItemsModel.fromJson(item))
                .toList()
            : [],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "poster": poster,
    "animeId": animeId,
    "episodes": episodes,
    "href": href,
    "status": status,
    "genreList": genreList.map((a) => a.toJson()).toList(),
  };
}
