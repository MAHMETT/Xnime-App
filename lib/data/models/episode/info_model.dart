import 'package:flutter/material.dart';
import 'package:xnime_app/data/models/genre_items_model.dart';

@immutable
class InfoModel {
  final String credit;
  final String encoder;
  final String duration;
  final String type;
  final List<GenreItemsModel> genreList;
  // … (abaikan episodeList jika memang tidak dipakai)

  const InfoModel({
    required this.credit,
    required this.encoder,
    required this.duration,
    required this.type,
    required this.genreList,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) => InfoModel(
    credit: json['credit'] ?? '',
    encoder: json['encoder'] ?? '',
    duration: json['duration'] ?? '',
    type: json['type'] ?? '',
    genreList:
        (json['genreList'] is List)
            ? (json['genreList'] as List)
                .map((item) => GenreItemsModel.fromJson(item))
                .toList()
            : [],
  );

  Map<String, dynamic> toJson() => {
    "credit": credit,
    "encoder": encoder,
    "duration": duration,
    "type": type,
    "genreList": genreList.map((g) => g.toJson()).toList(),
  };
}
