class Article {
  String title;
  String content;
  String author;
  String image;
  String url;
  DateTime? publishedAt;

  Article.fromJson(Map<String, dynamic> json)
    : title = json['title'] as String? ?? '',
      content = json['content'] as String? ?? '',
      author = json['author'] as String? ?? '',
      image = json['urlToImage'] as String? ?? '',
      url = json['url'] as String? ?? '',
      publishedAt = DateTime.tryParse(json['publishedAt'] as String? ?? '');

  Uri? get link {
    var uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) return null;
    if (uri.scheme != 'https' && uri.scheme != 'http') return null;
    return uri;
  }
}

class NewsResponse {
  int totalResults;
  List<Article> articles;

  NewsResponse.fromJson(Map<String, dynamic> json)
    : totalResults = json['totalResults'] as int? ?? 0,
      articles = (json['articles'] as List? ?? [])
          .cast<Map<String, dynamic>>()
          .map(Article.fromJson)
          .where(
            (article) =>
                article.title.isNotEmpty && article.title != '[Removed]',
          )
          .toList();
}
