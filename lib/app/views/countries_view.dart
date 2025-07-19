import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/countries_controller.dart';
import 'widgets/news_article_tile.dart';
import 'widgets/searchable_country_selector.dart';

/// View for displaying news by country with country selection
class CountriesView extends StatelessWidget {
  const CountriesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    final controller = Get.find<CountriesController>();
    return Column(
      children: [
        // Country selector header
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
              Text(
                'Select Country',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              SearchableCountrySelector(controller: controller),
            ],
          ),
        ),
        // News content
        Expanded(child: Obx(() => _buildNewsContent(context, controller))),
      ],
    );
  }

  Widget _buildNewsContent(
    BuildContext context,
    CountriesController controller,
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
      return _buildErrorState(context, controller);
    }

    if (!controller.hasArticles) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.article_outlined,
                size: 64,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No news available',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'No articles found for the selected country.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshNews,
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

  /// Build enhanced error state with country-specific messaging
  Widget _buildErrorState(
    BuildContext context,
    CountriesController controller,
  ) {
    final selectedCountry = controller.selectedCountry.value;
    final isCountrySupported = controller.isCurrentCountrySupported.value;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon with country context
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.errorContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCountrySupported ? Icons.error_outline : Icons.public_off,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),

            // Title with country context
            Text(
              isCountrySupported
                  ? 'Error Loading News'
                  : 'Country Not Supported',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // Selected country info
            if (selectedCountry != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedCountry.flagEmoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedCountry.displayName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Error message
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                // Retry button (for supported countries)
                if (isCountrySupported)
                  ElevatedButton.icon(
                    onPressed: controller.refreshNews,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),

                // Suggest alternative button (for unsupported countries)
                if (!isCountrySupported)
                  ElevatedButton.icon(
                    onPressed: () => controller.suggestAlternativeCountry(),
                    icon: const Icon(Icons.explore),
                    label: const Text('Suggest Country'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer,
                    ),
                  ),

                // Change country button
                OutlinedButton.icon(
                  onPressed: () {
                    // This will trigger the country picker
                    // We can access the SearchableCountrySelector through the controller
                  },
                  icon: const Icon(Icons.flag),
                  label: const Text('Change Country'),
                ),
              ],
            ),

            // Help text for unsupported countries
            if (!isCountrySupported) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Try selecting a country from the favorites section for better news coverage.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
