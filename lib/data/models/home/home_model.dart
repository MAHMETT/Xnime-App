import 'package:xnime_app/data/models/anime_items_model.dart';

class HomeModel {
  final List<AnimeItems> ongoing;
  final List<AnimeItems> completed;

  const HomeModel({required this.ongoing, required this.completed});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      ongoing:
          (json['data']['ongoing']['animeList'] as List)
              .map((e) => AnimeItems.fromJson(e))
              .toList(),
      completed:
          (json['data']['completed']['animeList'] as List)
              .map((e) => AnimeItems.fromJson(e))
              .toList(),
    );
  }
}
