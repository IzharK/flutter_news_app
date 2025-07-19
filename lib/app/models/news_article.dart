/// Model class representing a news article with comprehensive data
/// Includes all relevant fields from NewsAPI response with proper null safety
class NewsArticle {
  final String title;
  final String description;
  final String content;
  final String url;
  final String urlToImage;
  final String author;
  final NewsSource source;
  final DateTime publishedAt;

  const NewsArticle({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.urlToImage,
    required this.author,
    required this.source,
    required this.publishedAt,
  });

  /// Create NewsArticle from JSON response
  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: _validateString(json['title']),
      description: _validateString(json['description']),
      content: _validateString(json['content']),
      url: _validateString(json['url']),
      urlToImage: _validateString(json['urlToImage']),
      author: _validateString(json['author']),
      source: NewsSource.fromJson(json['source'] ?? {}),
      publishedAt: _parseDateTime(json['publishedAt']),
    );
  }

  /// Convert NewsArticle to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'url': url,
      'urlToImage': urlToImage,
      'author': author,
      'source': source.toJson(),
      'publishedAt': publishedAt.toIso8601String(),
    };
  }

  /// Validate and clean string values from JSON
  static String _validateString(dynamic value) {
    if (value == null) return '';
    final stringValue = value.toString().trim();
    // Remove common unwanted suffixes from content
    if (stringValue.endsWith('[+') || stringValue.endsWith('...')) {
      return stringValue.substring(0, stringValue.length - 3).trim();
    }
    return stringValue;
  }

  /// Parse DateTime from string with fallback
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Get formatted published date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Get short description (first 150 characters)
  String get shortDescription {
    if (description.isEmpty) return 'No description available';
    if (description.length <= 150) return description;
    return '${description.substring(0, 147)}...';
  }

  /// Check if article has a valid image URL
  bool get hasImage =>
      urlToImage.isNotEmpty && Uri.tryParse(urlToImage) != null;

  /// Check if article has author information
  bool get hasAuthor => author.isNotEmpty && author.toLowerCase() != 'null';

  /// Get display author (fallback to source name if no author)
  String get displayAuthor {
    if (hasAuthor) return author;
    if (source.name.isNotEmpty) return source.name;
    return 'Unknown';
  }

  /// Check if article has valid content
  bool get hasContent => content.isNotEmpty && content.toLowerCase() != 'null';

  /// Get reading time estimate (based on average reading speed)
  String get estimatedReadingTime {
    if (!hasContent) return '';
    final wordCount = content.split(' ').length;
    final minutes = (wordCount / 200).ceil(); // Average 200 words per minute
    return '$minutes min read';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsArticle &&
          runtimeType == other.runtimeType &&
          url == other.url;

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() {
    return 'NewsArticle{title: $title, source: ${source.name}, publishedAt: $publishedAt}';
  }
}

/// Model class representing the news source
class NewsSource {
  final String id;
  final String name;

  const NewsSource({required this.id, required this.name});

  /// Create NewsSource from JSON
  factory NewsSource.fromJson(Map<String, dynamic> json) {
    return NewsSource(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  /// Convert NewsSource to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsSource && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'NewsSource{id: $id, name: $name}';
}
