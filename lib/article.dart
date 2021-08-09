class Article {
  final Map<String, dynamic> source;
  final String title;
  final String description;
  final String url;
  final String publishedAt;
  final String? author;
  final String? content;
  final String? urlToImage;

  Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        source: json['source'],
        author: json['author'],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: json["publishedAt"],
        content: json["content"]);
  }
}
