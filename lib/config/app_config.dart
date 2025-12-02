/// Environment types supported by the application
enum BuildEnvironment { dev, staging, prod }

/// Application configuration based on build environment
/// Uses --dart-define for environment-specific values
class AppConfig {
  static const String _envKey = 'BUILD_ENV';
  static const String _apiUrlKey = 'API_URL';

  /// Get current build environment
  static BuildEnvironment get environment {
    const envString = String.fromEnvironment(_envKey, defaultValue: 'dev');
    return BuildEnvironment.values.firstWhere(
      (e) => e.name == envString,
      orElse: () => BuildEnvironment.dev,
    );
  }

  /// Get API base URL based on environment
  static String get apiBaseUrl {
    return const String.fromEnvironment(
      _apiUrlKey,
      defaultValue: 'https://api-dev.example.com',
    );
  }

  /// Check if running in production
  static bool get isProduction => environment == BuildEnvironment.prod;

  /// Check if running in development
  static bool get isDevelopment => environment == BuildEnvironment.dev;

  /// Check if running in staging
  static bool get isStaging => environment == BuildEnvironment.staging;

  /// Get environment-specific app name
  static String get appName {
    switch (environment) {
      case BuildEnvironment.dev:
        return 'MyApp Dev';
      case BuildEnvironment.staging:
        return 'MyApp Staging';
      case BuildEnvironment.prod:
        return 'MyApp';
    }
  }

  /// Get environment display name
  static String get environmentName {
    switch (environment) {
      case BuildEnvironment.dev:
        return 'Development';
      case BuildEnvironment.staging:
        return 'Staging';
      case BuildEnvironment.prod:
        return 'Production';
    }
  }

  /// Debug mode flag
  static bool get enableDebugFeatures => !isProduction;

  /// Logging level
  static bool get enableVerboseLogging => isDevelopment;
}
