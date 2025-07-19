import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/categories_controller.dart';

/// Custom search bar widget for news search functionality
class SearchBarWidget extends StatefulWidget {
  final CategoriesController controller;

  const SearchBarWidget({super.key, required this.controller});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();

    // Initialize with current search query if any
    _textController.text = widget.controller.searchQuery.value;
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: TextField(
        controller: _textController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: 'Search news...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Obx(() {
            if (widget.controller.searchQuery.value.isNotEmpty) {
              return IconButton(
                onPressed: _clearSearch,
                icon: const Icon(Icons.clear),
                tooltip: 'Clear search',
              );
            }
            return const SizedBox.shrink();
          }),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: _performSearch,
        onChanged: (value) {
          // Optional: Implement real-time search with debouncing
          // For now, we'll only search on submit
        },
      ),
    );
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      widget.controller.searchNews(query.trim());
      _focusNode.unfocus();
    }
  }

  void _clearSearch() {
    _textController.clear();
    widget.controller.clearSearch();
    _focusNode.unfocus();
  }
}

/// Alternative search bar with more advanced features
class AdvancedSearchBar extends StatefulWidget {
  final CategoriesController controller;

  const AdvancedSearchBar({super.key, required this.controller});

  @override
  State<AdvancedSearchBar> createState() => _AdvancedSearchBarState();
}

class _AdvancedSearchBarState extends State<AdvancedSearchBar> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();

    // Initialize with current search query if any
    _textController.text = widget.controller.searchQuery.value;

    // Listen to focus changes
    _focusNode.addListener(() {
      setState(() {
        _isExpanded = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(_isExpanded ? 16 : 12),
        border: Border.all(
          color: _isExpanded
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: _isExpanded ? 2 : 1,
        ),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          TextField(
            controller: _textController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Search news articles...',
              prefixIcon: AnimatedRotation(
                turns: _isExpanded ? 0.25 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.search),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    if (widget.controller.searchQuery.value.isNotEmpty) {
                      return IconButton(
                        onPressed: _clearSearch,
                        icon: const Icon(Icons.clear),
                        tooltip: 'Clear search',
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  if (_isExpanded)
                    IconButton(
                      onPressed: () => _performSearch(_textController.text),
                      icon: const Icon(Icons.arrow_forward),
                      tooltip: 'Search',
                    ),
                ],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: _performSearch,
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Text(
                    'Search Tips:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Use quotes for exact phrases, + for required words',
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
    );
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      widget.controller.searchNews(query.trim());
      _focusNode.unfocus();
    }
  }

  void _clearSearch() {
    _textController.clear();
    widget.controller.clearSearch();
    _focusNode.unfocus();
  }
}

/// Compact search bar for smaller spaces
class CompactSearchBar extends StatelessWidget {
  final CategoriesController controller;
  final VoidCallback? onTap;

  const CompactSearchBar({super.key, required this.controller, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() {
                final query = controller.searchQuery.value;
                return Text(
                  query.isNotEmpty ? 'Search: "$query"' : 'Search news...',
                  style: TextStyle(
                    color: query.isNotEmpty
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: query.isNotEmpty
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                );
              }),
            ),
            Obx(() {
              if (controller.searchQuery.value.isNotEmpty) {
                return GestureDetector(
                  onTap: controller.clearSearch,
                  child: const Icon(Icons.clear, size: 20),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
