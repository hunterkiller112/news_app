import 'package:flutter/material.dart';

import '../../../api/api_manager.dart';
import '../../../model/news_response.dart';
import '../../../model/source_response.dart';
import '../../../utils/news_message.dart';
import '../news/news_item.dart';
import '../search/search_view.dart';

enum Category {
  general,
  business,
  sports,
  technology,
  entertainment,
  health,
  science;

  String get title => '${name[0].toUpperCase()}${name.substring(1)}';

  bool get imageOnLeft =>
      this == general ||
      this == sports ||
      this == entertainment ||
      this == science;
}

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var scrollController = ScrollController();
  Category? category;
  List<NewsSource> sources = [];
  List<Article> articles = [];
  int selectedSource = 0;
  int sourceVersion = 0;
  int page = 1;
  bool hasMore = true;
  bool loadingSources = true;
  bool loadingArticles = false;
  String? sourcesError;
  String? articlesError;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      var position = scrollController.position;
      if (position.atEdge && position.pixels != 0 && articlesError == null) {
        loadArticles();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (category != null) return;
    category = ModalRoute.of(context)!.settings.arguments as Category;
    loadSources();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> loadSources() async {
    setState(() {
      loadingSources = true;
      sourcesError = null;
    });
    try {
      var results = await ApiManager.getSources(category!.name);
      if (!mounted) return;
      setState(() {
        sources = results.sources;
        loadingSources = false;
      });
      if (sources.isNotEmpty) await loadArticles();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        loadingSources = false;
        sourcesError = error is NewsError
            ? error.message
            : 'Could not load news sources.';
      });
    }
  }

  Future<void> loadArticles() async {
    if (loadingArticles || !hasMore || sources.isEmpty) return;
    var source = sources[selectedSource];
    var version = sourceVersion;
    setState(() {
      loadingArticles = true;
      articlesError = null;
    });
    try {
      var results = await ApiManager.getNewsBySourceId(source.id, page);
      if (!mounted || version != sourceVersion) return;
      setState(() {
        articles.addAll(results.articles);
        hasMore =
            results.articles.isNotEmpty &&
            page * ApiManager.pageSize < results.totalResults;
        page++;
        loadingArticles = false;
      });
    } catch (error) {
      if (!mounted || version != sourceVersion) return;
      setState(() {
        loadingArticles = false;
        articlesError = error is NewsError
            ? error.message
            : 'Could not load articles.';
      });
    }
  }

  void changeSource(int index) {
    if (index == selectedSource) return;
    setState(() {
      selectedSource = index;
      sourceVersion++;
      articles = [];
      page = 1;
      hasMore = true;
      loadingArticles = false;
      articlesError = null;
    });
    if (scrollController.hasClients) scrollController.jumpTo(0);
    loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category!.title),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(builder: (context) => const SearchView()),
            ),
          ),
        ],
      ),
      body: buildSources(),
    );
  }

  Widget buildSources() {
    if (loadingSources) return const Center(child: CircularProgressIndicator());
    if (sourcesError != null) {
      return newsMessage(sourcesError!, retry: loadSources);
    }
    if (sources.isEmpty) return newsMessage('No news sources found.');

    return DefaultTabController(
      length: sources.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            onTap: changeSource,
            tabs: [for (var source in sources) Tab(text: source.name)],
          ),
          Expanded(child: buildArticles()),
        ],
      ),
    );
  }

  Widget buildArticles() {
    if (articles.isEmpty) {
      if (loadingArticles) {
        return const Center(child: CircularProgressIndicator());
      }
      if (articlesError != null) {
        return newsMessage(articlesError!, retry: loadArticles);
      }
      return newsMessage('No articles found.');
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(12),
      itemCount:
          articles.length + (loadingArticles || articlesError != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < articles.length) {
          return articleCard(context, articles[index]);
        }
        if (articlesError != null) {
          return newsMessage(articlesError!, retry: loadArticles);
        }
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
