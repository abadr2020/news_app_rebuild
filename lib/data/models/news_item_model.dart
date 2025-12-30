class NewsItemModel {
  NewsItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final DateTime publishedAt;

  factory NewsItemModel.fromJson(Map<String, dynamic> json) => NewsItemModel(
    id: json["id"] ?? "no id",
    title: json["title"] ?? "No Title",
    description: json["description"] ?? "No Description",
    imageUrl: json["urlToImage"] ?? "https://via.placeholder.com/150",
    source: json["source"]["name"] ?? "Unknown Source",
    publishedAt: DateTime.parse(json["publishedAt"] ?? "2024-01-01T00:00:00Z"),
  );
}
