import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/categories_controller.dart';
import 'widgets/category_selector.dart';
import 'widgets/news_article_tile.dart';
import 'widgets/search_bar_widget.dart';

/// View for displaying news by categories with search functionality
class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    final controller = Get.find<CategoriesController>();
    return Column(
      children: [
        // Search and category selector header
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              SearchBarWidget(controller: controller),
              const SizedBox(height: 16),
              // Category selector
              Obx(() {
                if (!controller.isSearchMode) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categories',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      CategorySelector(controller: controller),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
        // Content header with title and subtitle
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.currentDisplayTitle,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if (controller.hasArticles)
                        Text(
                          controller.currentSubtitle,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                        ),
                    ],
                  ),
                ),
                if (controller.isSearchMode)
                  IconButton(
                    onPressed: controller.clearSearch,
                    icon: const Icon(Icons.close),
                    tooltip: 'Clear search',
                  ),
              ],
            ),
          ),
        ),
        // News content
        Expanded(child: Obx(() => _buildNewsContent(context, controller))),
      ],
    );
  }

  Widget _buildNewsContent(
    BuildContext context,
    CategoriesController controller,
  ) {
    if (controller.isLoading.value && !controller.hasInitialData.value) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading news...'),
          ],
        ),
      );
    }

    if (controller.errorMessage.value.isNotEmpty && !controller.hasArticles) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading news',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: controller.refreshContent,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (!controller.hasArticles) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                controller.isSearchMode
                    ? Icons.search_off
                    : Icons.article_outlined,
                size: 64,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                controller.isSearchMode
                    ? 'No search results'
                    : 'No news available',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                controller.isSearchMode
                    ? 'Try searching with different keywords.'
                    : 'No articles found for the selected category.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (controller.isSearchMode) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: controller.clearSearch,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Search'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshContent,
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
                          color: Theme.of(context).colorScheme.onErrorContainer,
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
  }
}
