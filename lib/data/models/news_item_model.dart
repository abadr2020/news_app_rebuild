class NewsItemModel {
  NewsItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
    required this.author,
    required this.content,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final DateTime publishedAt;
  final String author;
  final String content;

  factory NewsItemModel.fromJson(Map<String, dynamic> json) => NewsItemModel(
    id: json['source']['id'] ?? "no id",
    title: json["title"] ?? "No Title",
    description: json["description"] ?? "No Description",
    imageUrl: json["urlToImage"] ?? "https://placehold.co/600x400",
    source: json["source"]["name"] ?? "Unknown Source",
    publishedAt: DateTime.parse(json["publishedAt"] ?? "2024-01-01T00:00:00Z"),
    author: json['author'] ?? "Unknown Author",
    content: json['content'] ?? "No Content",
  );
}
