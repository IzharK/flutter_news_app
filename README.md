# Flutter News App

A modern, feature-rich news application built with Flutter, showcasing best practices in mobile app development with clean architecture, state management, and Material Design 3.

## 🚀 Features

### Core Features
- **Top Headlines**: Latest breaking news from around the world
- **News by Countries**: Filter news by different countries with comprehensive country selection
- **Categories**: Browse news by categories (Business, Technology, Sports, etc.)
- **Search**: Search for specific news articles with real-time results
- **Pull-to-Refresh**: Refresh content with intuitive pull gestures
- **Smart Country Selection**: Searchable dropdown with 195+ countries and intelligent error handling

### UI/UX Features
- **Material Design 3**: Modern, accessible design following Google's latest guidelines
- **Responsive Layout**: Optimized for different screen sizes and orientations
- **Shimmer Loading**: Elegant loading states with shimmer effects
- **Intelligent Error Handling**: Context-aware error messages with smart suggestions
- **Smooth Animations**: Fluid transitions and micro-interactions
- **Dark/Light Theme**: Automatic theme adaptation (system-based)
- **Searchable Country Picker**: Professional country selection with 195+ countries

### Technical Features
- **Clean Architecture**: Separation of concerns with proper layering
- **State Management**: GetX for reactive state management and dependency injection
- **Navigation**: GoRouter for declarative routing and navigation
- **Network Layer**: Dio with intelligent error handling and logging
- **Performance**: Optimized for smooth scrolling and memory efficiency
- **Graceful Error Recovery**: Smart error handling with alternative suggestions
- **Comprehensive Country Support**: Integration with country_picker package

## 🏗️ Architecture

This app follows **GetX Pattern Architecture** with clean separation of concerns:

```
lib/
├── app/
│   ├── bindings/          # Dependency injection bindings
│   ├── controllers/       # Business logic and state management
│   ├── core/             # Core utilities and configurations
│   │   ├── config/       # App configuration
│   │   └── constants/    # App constants
│   ├── models/           # Data models
│   ├── routes/           # Navigation and routing
│   ├── services/         # API services and external integrations
│   └── views/            # UI components and screens
│       └── widgets/      # Reusable UI widgets
└── main.dart             # App entry point
```

### Key Components

- **Controllers**: Manage business logic and state using GetX reactive programming
- **Services**: Handle API calls and external data sources
- **Models**: Define data structures with proper serialization
- **Views**: UI components following Material Design guidelines
- **Bindings**: Manage dependency injection and lifecycle

## 🛠️ Tech Stack

- **Framework**: Flutter 3.8+
- **State Management**: GetX 4.6+
- **Navigation**: GoRouter 14.1+
- **HTTP Client**: Dio 5.4+
- **Architecture**: GetX Pattern with Clean Architecture principles

## 🛡️ Enhanced Error Handling

The app features intelligent error handling that gracefully manages country selection errors:

### Smart Country Support Detection
- **Automatic Detection**: Identifies when a selected country is not supported by NewsAPI
- **Clear Messaging**: Provides context-aware error messages explaining the situation
- **Visual Indicators**: Shows country support status in the selection interface

### Graceful Error Recovery
- **Alternative Suggestions**: Automatically suggests supported countries when errors occur
- **One-Click Solutions**: Users can quickly switch to suggested countries
- **Contextual Help**: Provides guidance on selecting countries with better news coverage

### Error Types Handled
- **Unsupported Countries**: Clear messaging when NewsAPI doesn't support a country
- **Network Errors**: Intelligent retry mechanisms for connectivity issues
- **API Limits**: Proper handling of rate limiting with user-friendly messages
- **Configuration Errors**: Clear guidance for API key and setup issues

### User Experience Benefits
- **No Dead Ends**: Users always have a path forward when errors occur
- **Educational**: Helps users understand which countries have better news coverage
- **Professional**: Maintains app quality even when external services have limitations

## 📱 Screenshots

*Screenshots will be added here*

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.8.0 or higher
- Dart SDK 3.0.0 or higher
- News API key from [NewsAPI.org](https://newsapi.org/)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/flutter_news_app.git
   cd flutter_news_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Key**

   Get your free API key from [NewsAPI.org](https://newsapi.org/) and set it as an environment variable:

   ```bash
   # For development
   export NEWS_API_KEY=your_api_key_here

   # Or run with the key directly
   flutter run --dart-define=NEWS_API_KEY=your_api_key_here
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

```bash
# Android
flutter build apk --dart-define=NEWS_API_KEY=your_api_key_here

# iOS
flutter build ios --dart-define=NEWS_API_KEY=your_api_key_here
```

## 🔧 Configuration

The app uses a centralized configuration system located in `lib/app/core/config/`:

- **AppConfig**: Environment-specific settings
- **AppConstants**: Application-wide constants
- **FeatureFlags**: Enable/disable features

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `NEWS_API_KEY` | NewsAPI.org API key | `your_api_key_here` |

## 📚 API Integration

This app integrates with [NewsAPI.org](https://newsapi.org/) to fetch news data:

- **Top Headlines**: `/v2/top-headlines`
- **Everything**: `/v2/everything` (for search)
- **Sources**: `/v2/sources`

### Supported Countries

The app supports news from 20+ countries including:
- United States, United Kingdom, Canada
- Germany, France, Italy, Japan
- India, Brazil, Australia, and more

### Supported Categories

- General, Business, Entertainment
- Health, Science, Sports, Technology

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

## 🚀 Performance

The app is optimized for performance with:

- **Lazy Loading**: Controllers and services loaded on demand
- **Image Caching**: Efficient image loading and caching
- **Memory Management**: Proper disposal of resources
- **Smooth Scrolling**: Optimized list rendering

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [NewsAPI.org](https://newsapi.org/) for providing the news data
- [Flutter](https://flutter.dev/) team for the amazing framework
- [GetX](https://pub.dev/packages/get) for state management
- [Material Design](https://material.io/) for design guidelines

## 📞 Support

If you have any questions or need help, please:

1. Check the [Issues](https://github.com/your-username/flutter_news_app/issues) page
2. Create a new issue if your problem isn't already reported
3. Provide detailed information about your environment and the issue

---

**Made with ❤️ using Flutter**
