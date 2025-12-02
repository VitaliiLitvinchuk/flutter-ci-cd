import 'package:flutter_test/flutter_test.dart';
import 'package:ci_cd/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('default environment should be dev', () {
      expect(AppConfig.environment, BuildEnvironment.dev);
    });

    test('isDevelopment should be true for dev environment', () {
      expect(AppConfig.isDevelopment, isTrue);
    });

    test('isProduction should be false for dev environment', () {
      expect(AppConfig.isProduction, isFalse);
    });

    test('isStaging should be false for dev environment', () {
      expect(AppConfig.isStaging, isFalse);
    });

    test('apiBaseUrl should return default dev URL', () {
      expect(AppConfig.apiBaseUrl, 'https://api-dev.example.com');
    });

    test('appName should return dev app name', () {
      expect(AppConfig.appName, 'MyApp Dev');
    });

    test('environmentName should return Development', () {
      expect(AppConfig.environmentName, 'Development');
    });

    test('enableDebugFeatures should be true in non-production', () {
      expect(AppConfig.enableDebugFeatures, isTrue);
    });

    test('enableVerboseLogging should be true in development', () {
      expect(AppConfig.enableVerboseLogging, isTrue);
    });
  });

  group('BuildEnvironment', () {
    test('should have all three environment types', () {
      expect(BuildEnvironment.values.length, 3);
      expect(BuildEnvironment.values, contains(BuildEnvironment.dev));
      expect(BuildEnvironment.values, contains(BuildEnvironment.staging));
      expect(BuildEnvironment.values, contains(BuildEnvironment.prod));
    });

    test('environment names should match enum values', () {
      expect(BuildEnvironment.dev.name, 'dev');
      expect(BuildEnvironment.staging.name, 'staging');
      expect(BuildEnvironment.prod.name, 'prod');
    });
  });
}
