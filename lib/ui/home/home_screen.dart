import 'package:flutter/material.dart';

import 'category/category_screen.dart';
import 'search/search_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool darkMode = false;
  bool showSplash = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: Colors.black),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          surface: Color(0xff171717),
        ),
        scaffoldBackgroundColor: const Color(0xff171717),
      ),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: Builder(
        builder: (context) {
          if (showSplash) {
            var foreground = Theme.of(context).colorScheme.onSurface;
            return Scaffold(
              body: SafeArea(
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/news_logo.png',
                        width: 110,
                        color: foreground,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Image.asset(
                          'assets/images/news_branding.png',
                          width: 170,
                          color: foreground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              centerTitle: true,
              actions: [
                IconButton(
                  tooltip: 'Search',
                  icon: const Icon(Icons.search),
                  onPressed: () => Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const SearchView(),
                    ),
                  ),
                ),
              ],
            ),
            drawer: Drawer(
              child: SafeArea(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'News App',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home_outlined),
                      title: const Text('Go to Home'),
                      onTap: () => Navigator.pop(context),
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.dark_mode_outlined),
                      title: const Text('Dark mode'),
                      value: darkMode,
                      onChanged: (value) => setState(() => darkMode = value),
                    ),
                  ],
                ),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                const Text(
                  'Good Morning\nHere is some News For You',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                for (var category in Category.values) ...[
                  buildCategory(context, category),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildCategory(BuildContext context, Category category) {
    var left = !category.imageOnLeft;
    var textColor = darkMode ? Colors.black : Colors.white;
    var artwork =
        'assets/images/${category.name}_${darkMode ? 'light' : 'dark'}.png';

    return Material(
      color: darkMode ? Colors.white : const Color(0xff1e1e1e),
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            settings: RouteSettings(arguments: category),
            builder: (context) => const CategoryScreen(),
          ),
        ),
        child: AspectRatio(
          aspectRatio: 1.83,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(artwork, fit: BoxFit.cover),
              Align(
                alignment: left ? Alignment.centerLeft : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.54,
                  heightFactor: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: left
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        Text(
                          category.title,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (left)
                                  const Icon(
                                    Icons.chevron_left,
                                    color: Colors.black,
                                  ),
                                const Flexible(
                                  child: Text(
                                    'View All',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (!left)
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.black,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
