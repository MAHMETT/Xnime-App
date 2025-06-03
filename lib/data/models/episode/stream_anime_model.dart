import 'package:flutter/material.dart';
import 'package:xnime_app/data/models/episode/info_model.dart';

@immutable
class StreamAnimeModel {
  final String title;
  final String animeId;
  final String defaultStreamingUrl;
  final String releaseTime;
  final InfoModel info; // single object, bukan list

  const StreamAnimeModel({
    required this.title,
    required this.animeId,
    required this.defaultStreamingUrl,
    required this.releaseTime,
    required this.info,
  });

  factory StreamAnimeModel.fromJson(Map<String, dynamic> json) =>
      StreamAnimeModel(
        title: json['title'] ?? '',
        animeId: json['animeId'] ?? '',
        defaultStreamingUrl: json['defaultStreamingUrl'] ?? '',
        releaseTime: json['releaseTime'] ?? '',
        info: InfoModel.fromJson(json['info'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "animeId": animeId,
    "defaultStreamingUrl": defaultStreamingUrl,
    "releaseTime": releaseTime,
    "info": info.toJson(),
  };
}
