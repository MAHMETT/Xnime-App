class RecommendedAnime {
  final String title;
  final String poster;
  final String animeId;
  final String href;
  final String otakudesuUrl;

  RecommendedAnime({
    required this.title,
    required this.poster,
    required this.animeId,
    required this.href,
    required this.otakudesuUrl,
  });

  factory RecommendedAnime.fromJson(Map<String, dynamic> json) {
    return RecommendedAnime(
      title: json['title'] ?? '',
      poster: json['poster'] ?? '',
      animeId: json['animeId'] ?? '',
      href: json['href'] ?? '',
      otakudesuUrl: json['otakudesuUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'poster': poster,
      'animeId': animeId,
      'href': href,
      'otakudesuUrl': otakudesuUrl,
    };
  }
}
