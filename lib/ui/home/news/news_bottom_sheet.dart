import 'package:flutter/material.dart';

import '../../../model/news_response.dart';
import 'news_web_view.dart';

Widget articleImage(String image) {
  var placeholder = const Center(child: Icon(Icons.article_outlined, size: 36));
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: AspectRatio(
      aspectRatio: 16 / 10,
      child: ColoredBox(
        color: const Color(0x16808080),
        child: image.isEmpty
            ? placeholder
            : Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => placeholder,
              ),
      ),
    ),
  );
}

void showArticle(BuildContext context, Article article) {
  FocusScope.of(context).unfocus();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            articleImage(article.image),
            const SizedBox(height: 6),
            Text(article.content),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onSurface,
                foregroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: article.link == null
                  ? null
                  : () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          settings: RouteSettings(arguments: article),
                          builder: (context) => const NewsWebView(),
                        ),
                      );
                    },
              child: const Text('View Full Article'),
            ),
          ],
        ),
      ),
    ),
  );
}
