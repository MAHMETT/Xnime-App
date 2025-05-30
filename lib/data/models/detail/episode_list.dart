class EpisodeList {
  final int title;
  final String episodeId;
  final String href;
  final String otakudesuUrl;

  EpisodeList({
    required this.title,
    required this.episodeId,
    required this.href,
    required this.otakudesuUrl,
  });

  factory EpisodeList.fromJson(Map<String, dynamic> json) {
    return EpisodeList(
      title: json['title'] ?? '',
      episodeId: json['episodeId'] ?? '',
      href: json['href'] ?? '',
      otakudesuUrl: json['otakudesuUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'episodeId': episodeId,
      'href': href,
      'otakudesuUrl': otakudesuUrl,
    };
  }
}
