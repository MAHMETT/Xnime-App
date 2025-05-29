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
  final List<GenreItemsModel> genreList;

  const AnimeItems({
    required this.title,
    required this.poster,
    required this.animeId,
    required this.episodes,
    required this.href,
    required this.score,
    required this.genreList,
  });

  factory AnimeItems.fromJson(Map<String, dynamic> json) => AnimeItems(
    title: json['title'] ?? '',
    poster: json['poster'] ?? '',
    animeId: json['animeId'] ?? '',
    episodes: json['episodes'] ?? 0,
    href: json['href'] ?? '',
    score: json['score'] ?? '',
    genreList:
        (json['genreList'] as List)
            .map((title) => GenreItemsModel.fromJson(title))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "poster": poster,
    "animeId": animeId,
    "episodes": episodes,
    "href": href,
    "score": score,
    "genreList": genreList.map((a) => a.toJson()).toList(),
  };
}
