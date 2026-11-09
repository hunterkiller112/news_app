import 'dart:async';

import 'package:flutter/material.dart';

import '../../../api/api_manager.dart';
import '../../../model/news_response.dart';

class SearchViewModel extends ChangeNotifier {
  var controller = TextEditingController();
  Timer? debounce;
  List<Article>? articles;
  String? errorMessage;
  bool loading = false;
  int searchNumber = 0;

  void onSearchWithDebouncing(String value) {
    debounce?.cancel();
    var number = ++searchNumber;
    var query = value.trim();
    debounce = Timer(const Duration(seconds: 2), () {
      if (query.isEmpty) {
        articles = null;
        errorMessage = null;
        loading = false;
        notifyListeners();
      } else {
        getNewsByQuery(query, number);
      }
    });
  }

  Future<void> getNewsByQuery(String query, int number) async {
    loading = true;
    errorMessage = null;
    notifyListeners();
    try {
      var results = await ApiManager.getNewsByQuery(query);
      if (number != searchNumber) return;
      articles = results.articles;
    } catch (error) {
      if (number != searchNumber) return;
      errorMessage = error.toString();
    }
    loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    searchNumber++;
    debounce?.cancel();
    controller.dispose();
    super.dispose();
  }
}
