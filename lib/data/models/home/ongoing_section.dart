import 'package:xnime_app/data/models/anime_items_model.dart';

class OngoingSection {
  final String href;
  final List<AnimeItems> animeList;

  const OngoingSection({required this.href, required this.animeList});

  factory OngoingSection.fromJson(Map<String, dynamic> json) => OngoingSection(
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
