class SynopsisSection {
  final List<String>? paragraphs;
  // final List<dynamic> connections;

  SynopsisSection({
    this.paragraphs,
    // required this.connections
  });

  factory SynopsisSection.fromJson(Map<String, dynamic> json) {
    return SynopsisSection(
      paragraphs: List<String>.from(json['paragraphs'] ?? []),
      // connections: List<dynamic>.from(json['connections'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paragraphs': paragraphs,
      // 'connections': connections};
    };
  }
}
