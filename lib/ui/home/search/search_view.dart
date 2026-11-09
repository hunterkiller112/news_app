import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/news_message.dart';
import '../news/news_item.dart';
import 'search_view_model.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchViewModel(),
      child: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: viewModel.controller,
                    onChanged: viewModel.onSearchWithDebouncing,
                    decoration: InputDecoration(
                      hintText: 'Search for news...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        tooltip: 'Close search',
                        onPressed: () => Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        ),
                        icon: const Icon(Icons.close),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                Expanded(child: buildResults(viewModel)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildResults(SearchViewModel viewModel) {
    if (viewModel.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null) {
      return newsMessage(
        viewModel.errorMessage!,
        retry: () =>
            viewModel.onSearchWithDebouncing(viewModel.controller.text),
      );
    }
    var results = viewModel.articles;
    if (results == null) {
      return newsMessage('Search for news by title, description, or content.');
    }
    if (results.isEmpty) return newsMessage('No articles found.');

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      itemCount: results.length,
      itemBuilder: (context, index) => articleCard(context, results[index]),
    );
  }
}
