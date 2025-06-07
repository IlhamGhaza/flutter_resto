import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_resto/main.dart' as app;
import 'package:provider/provider.dart';
import 'package:flutter_resto/data/providers/restaurant_provider.dart';
import 'package:flutter_resto/data/services/api_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('App navigation and restaurant list test', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<RestaurantProvider>(
              create: (_) =>
                  RestaurantProvider(apiService: ApiService())
                    ..fetchRestaurants(),
            ),
          ],
          child: app.MyApp(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Melting Pot');
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();

      expect(find.text('No favorite restaurants yet'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      
      expect(
        find.descendant(of: find.byType(AppBar), matching: find.text('Settings')),
        findsOneWidget,
      );
    });
  });
}
