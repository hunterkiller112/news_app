import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/news_response.dart';
import '../model/source_response.dart';
import 'api_constant.dart';
import 'end_points.dart';

class ApiManager {
  static const pageSize = 20;

  static Future<SourceResponse> getSources(String category) async {
    var json = await _get(EndPoints.sources, {'category': category});
    return SourceResponse.fromJson(json);
  }

  static Future<NewsResponse> getNewsBySourceId(
    String sourceId,
    int page,
  ) async {
    var json = await _get(EndPoints.news, {
      'sources': sourceId,
      'page': '$page',
      'pageSize': '$pageSize',
    });
    if (json['code'] == 'maximumResultsReached') {
      return NewsResponse.fromJson({});
    }
    return NewsResponse.fromJson(json);
  }

  static Future<NewsResponse> getNewsByQuery(String query) async {
    var json = await _get(EndPoints.news, {
      'q': query,
      'pageSize': '$pageSize',
    });
    return NewsResponse.fromJson(json);
  }

  static Future<Map<String, dynamic>> _get(
    String path,
    Map<String, String> parameters,
  ) async {
    if (ApiConstants.apiKey.isEmpty) {
      throw NewsError('Add your NewsAPI key to load news.');
    }
    var url = Uri.https(ApiConstants.baseUrl, path, parameters);
    var response = await http
        .get(url, headers: {'X-Api-Key': ApiConstants.apiKey})
        .timeout(const Duration(seconds: 15));
    var json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['code'] == 'maximumResultsReached' && path == EndPoints.news) {
      return json;
    }
    if (response.statusCode != 200 || json['status'] != 'ok') {
      throw NewsError(switch (json['code']) {
        'apiKeyInvalid' || 'apiKeyDisabled' => 'Check your NewsAPI key.',
        'apiKeyExhausted' ||
        'rateLimited' => 'The NewsAPI request limit was reached.',
        _ => 'Could not load news. Try again.',
      });
    }
    return json;
  }
}

class NewsError implements Exception {
  String message;

  NewsError(this.message);

  @override
  String toString() => message;
}
