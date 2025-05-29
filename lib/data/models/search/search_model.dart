import 'package:xnime_app/data/models/anime_items_model.dart';

class SearchModel {
  final List<AnimeItems> animeList;

  const SearchModel({required this.animeList});

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
    animeList:
        (json['animeList'] as List)
            .map((anime) => AnimeItems.fromJson(anime))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'data': {'animeList': animeList.map((a) => a.toJson()).toList()},
  };
}
