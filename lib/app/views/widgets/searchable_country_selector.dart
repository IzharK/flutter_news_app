import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/countries_controller.dart';

/// Searchable country selector widget using country_picker package
/// Displays a button that opens a searchable country picker modal
class SearchableCountrySelector extends StatelessWidget {
  final CountriesController controller;

  const SearchableCountrySelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildSelectorButton(context));
  }

  Widget _buildSelectorButton(BuildContext context) {
    final selectedCountry = controller.selectedCountry.value;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showCountryPicker(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Country flag and name
                Expanded(
                  child: selectedCountry != null
                      ? _buildSelectedCountry(context, selectedCountry)
                      : _buildPlaceholder(context),
                ),

                // Dropdown arrow
                Icon(
                  Icons.keyboard_arrow_down,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedCountry(BuildContext context, Country country) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSupported = controller.isNewsApiSupported(country.countryCode);

    return Row(
      children: [
        // Flag
        Text(country.flagEmoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),

        // Country info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                country.displayName,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    country.countryCode,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  if (isSupported) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'News Available',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: colorScheme.outline.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.flag_outlined,
            size: 16,
            color: colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Select a country',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  void _showCountryPicker(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showCountryPicker(
      context: context,
      showPhoneCode: false,
      searchAutofocus: true,
      showSearch: true,
      showWorldWide: false,

      // Favorite countries (NewsAPI supported ones)
      favorite: controller.favoriteCountries
          .map((country) => country.countryCode)
          .toList(),

      // Custom theme
      countryListTheme: CountryListThemeData(
        flagSize: 28,
        backgroundColor: colorScheme.surface,
        textStyle: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.8,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),

        // Search field styling
        inputDecoration: InputDecoration(
          labelText: 'Search countries',
          hintText: 'Type to search...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
        ),

        // Margin and padding
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
      ),

      onSelect: (Country country) {
        controller.selectCountry(country);

        // Show a snackbar with information about news availability
        final isSupported = controller.isNewsApiSupported(country.countryCode);

        // Enhanced feedback with better messaging
        if (isSupported) {
          Get.snackbar(
            '${country.flagEmoji} ${country.displayName}',
            'Loading news for ${country.displayName}...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: colorScheme.primaryContainer,
            colorText: colorScheme.onPrimaryContainer,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            icon: Icon(
              Icons.check_circle,
              color: colorScheme.onPrimaryContainer,
            ),
          );
        } else {
          Get.snackbar(
            '${country.flagEmoji} ${country.displayName}',
            'News coverage may be limited for ${country.displayName}. We\'ll try to find available articles.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: colorScheme.secondaryContainer,
            colorText: colorScheme.onSecondaryContainer,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            icon: Icon(
              Icons.info_outline,
              color: colorScheme.onSecondaryContainer,
            ),
            mainButton: TextButton(
              onPressed: () {
                Get.closeCurrentSnackbar();
                controller.suggestAlternativeCountry();
              },
              child: Text(
                'Suggest',
                style: TextStyle(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

/// Compact version for smaller spaces
class CompactSearchableCountrySelector extends StatelessWidget {
  final CountriesController controller;

  const CompactSearchableCountrySelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedCountry = controller.selectedCountry.value;
      final colorScheme = Theme.of(context).colorScheme;

      return GestureDetector(
        onTap: () => _showCountryPicker(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedCountry?.flagEmoji ?? '🌍',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Text(
                selectedCountry?.displayName ?? 'Select Country',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
        ),
      );
    });
  }

  void _showCountryPicker(BuildContext context) {
    final searchableSelector = SearchableCountrySelector(
      controller: controller,
    );
    searchableSelector._showCountryPicker(context);
  }
}
