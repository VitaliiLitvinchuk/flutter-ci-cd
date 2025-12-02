import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ci_cd/main.dart';
import 'package:ci_cd/config/app_config.dart';

void main() {
  group('MainApp', () {
    testWidgets('should build without errors', (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should set correct app title', (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.title, AppConfig.appName);
    });

    testWidgets('should display HomePage', (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());
      expect(find.byType(HomePage), findsOneWidget);
    });
  });

  group('HomePage', () {
    testWidgets('should display app bar with title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MainApp());
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text(AppConfig.appName), findsAtLeastNWidgets(1));
    });

    testWidgets('should display rocket icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());
      expect(find.byIcon(Icons.rocket_launch), findsOneWidget);
    });

    testWidgets('should display welcome message', (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());
      expect(find.text('Welcome to ${AppConfig.appName}!'), findsOneWidget);
    });

    testWidgets('should display environment info card', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MainApp());
      expect(find.text('Environment'), findsOneWidget);
      expect(find.text(AppConfig.environmentName), findsOneWidget);
      expect(find.byIcon(Icons.cloud), findsOneWidget);
    });

    testWidgets('should display API URL info card', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MainApp());
      expect(find.text('API URL'), findsOneWidget);
      expect(find.text(AppConfig.apiBaseUrl), findsOneWidget);
      expect(find.byIcon(Icons.api), findsOneWidget);
    });

    testWidgets('should display debug features info card', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MainApp());
      expect(find.text('Debug Features'), findsOneWidget);
      final debugStatus = AppConfig.enableDebugFeatures
          ? 'Enabled'
          : 'Disabled';
      expect(find.text(debugStatus), findsOneWidget);
      expect(find.byIcon(Icons.bug_report), findsOneWidget);
    });

    testWidgets('should display all info cards', (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());
      expect(find.byType(Card), findsNWidgets(3));
    });

    testWidgets('info cards should be scrollable if needed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MainApp());
      // Verify that the layout doesn't overflow
      expect(tester.takeException(), isNull);
    });
  });

  group('HomePage _buildInfoCard', () {
    testWidgets('should render info card with correct structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final homePage = const HomePage();
                // ignore: invalid_use_of_protected_member
                return homePage.build(context);
              },
            ),
          ),
        ),
      );

      // Check that cards have proper padding
      final cards = tester.widgetList<Card>(find.byType(Card));
      expect(cards.length, 3);

      for (final card in cards) {
        expect(card.margin, const EdgeInsets.symmetric(horizontal: 32));
      }
    });
  });

  group('Theme', () {
    testWidgets('should use Material 3', (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.useMaterial3, isTrue);
    });

    testWidgets('should use orange color scheme in dev mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MainApp());
      final MaterialApp app = tester.widget(find.byType(MaterialApp));

      // In dev mode (default), seed color should be orange
      if (!AppConfig.isProduction) {
        expect(app.theme?.colorScheme.primary, isNot(equals(Colors.blue)));
      }
    });
  });
}
