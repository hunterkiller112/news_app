import 'package:flutter/material.dart';

import '../../../model/news_response.dart';
import 'news_bottom_sheet.dart';

String articleAge(DateTime? date) {
  if (date == null) return '';
  var elapsed = DateTime.now().difference(date);
  if (elapsed.inDays == 1) return 'a day ago';
  if (elapsed.inDays > 1) return '${elapsed.inDays} days ago';
  if (elapsed.inHours == 1) return 'an hour ago';
  if (elapsed.inHours > 1) return '${elapsed.inHours} hours ago';
  if (elapsed.inMinutes == 1) return 'a minute ago';
  if (elapsed.inMinutes > 1) return '${elapsed.inMinutes} minutes ago';
  return 'just now';
}

Widget articleCard(BuildContext context, Article article) {
  var colors = Theme.of(context).colorScheme;
  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    elevation: 0,
    color: colors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(color: colors.onSurface.withValues(alpha: 0.55)),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => showArticle(context, article),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            articleImage(article.image),
            const SizedBox(height: 8),
            Text(
              article.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    article.author.isEmpty ? '' : 'By: ${article.author}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  articleAge(article.publishedAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
