class NewsSource {
  String id;
  String name;

  NewsSource.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String? ?? '',
      name = json['name'] as String? ?? '';
}

class SourceResponse {
  List<NewsSource> sources;

  SourceResponse.fromJson(Map<String, dynamic> json)
    : sources = (json['sources'] as List)
          .cast<Map<String, dynamic>>()
          .map(NewsSource.fromJson)
          .where((source) => source.id.isNotEmpty && source.name.isNotEmpty)
          .toList();
}
