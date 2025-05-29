import 'package:xnime_app/data/models/anime_items_model.dart';

class CompletedSection {
  final String href;
  final List<AnimeItems> animeList;

  const CompletedSection({required this.href, required this.animeList});

  factory CompletedSection.fromJson(Map<String, dynamic> json) =>
      CompletedSection(
        href: json['href'],
        animeList:
            (json['animeList'] as List)
                .map((anime) => AnimeItems.fromJson(anime))
                .toList(),
      );

  Map<String, dynamic> toJson() => {
    "href": href,
    "animeList": animeList.map((a) => a.toJson()).toList(),
  };
}
