import 'package:xnime_app/data/models/anime_items_model.dart';

class OngoingModel {
  final List<AnimeItems> animeList;

  const OngoingModel({required this.animeList});

  factory OngoingModel.fromJson(Map<String, dynamic> json) => OngoingModel(
    animeList:
        (json['animeList'] as List)
            .map((anime) => AnimeItems.fromJson(anime))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    "animeList": animeList.map((a) => a.toJson()).toList(),
  };
}
