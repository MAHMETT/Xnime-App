class GenreItemsModel {
  final String title;

  const GenreItemsModel({required this.title});

  factory GenreItemsModel.fromJson(Map<String, dynamic> json) =>
      GenreItemsModel(title: json['title']);

  Map<String, dynamic> toJson() => {"title": title};
}
