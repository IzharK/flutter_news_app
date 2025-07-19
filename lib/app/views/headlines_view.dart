import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'widgets/loading_widgets.dart';
import 'widgets/news_article_tile.dart';

class HeadlinesView extends GetView<HomeController> {
  const HeadlinesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Initial loading state with shimmer
      if (controller.isLoading.value && controller.articles.isEmpty) {
        return LoadingWidgets.newsListShimmer(context);
      }

      // Error state with retry functionality
      if (controller.errorMessage.value.isNotEmpty &&
          controller.articles.isEmpty) {
        return LoadingWidgets.errorState(
          message: controller.errorMessage.value,
          onRetry: () => controller.fetchTopHeadlines(),
        );
      }

      // Empty state
      if (controller.articles.isEmpty) {
        return LoadingWidgets.emptyState(
          message: 'No headlines available',
          subtitle: 'Pull to refresh or try again later.',
          icon: Icons.article_outlined,
          onAction: () => controller.fetchTopHeadlines(),
          actionText: 'Refresh',
        );
      }

      // Content with pull-to-refresh
      return RefreshIndicator(
        onRefresh: () => controller.fetchTopHeadlines(),
        child: CustomScrollView(
          slivers: [
            // Loading indicator when refreshing
            if (controller.isLoading.value)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Center(child: LinearProgressIndicator()),
                ),
              ),

            // Error message when refreshing fails
            if (controller.errorMessage.value.isNotEmpty)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => controller.errorMessage.value = '',
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Articles list
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final article = controller.articles[index];
                return NewsArticleTile(article: article);
              }, childCount: controller.articles.length),
            ),
          ],
        ),
      );
    });
  }
}
