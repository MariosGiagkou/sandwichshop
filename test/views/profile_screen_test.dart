import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/profile_screen.dart';

void main() {
  group('ProfileScreen', () {
    Widget _wrapWithProvider(Widget child, {Cart? cart}) {
      return ChangeNotifierProvider<Cart>(
        create: (_) => cart ?? Cart(),
        child: MaterialApp(home: child),
      );
    }

    testWidgets('displays initial UI elements correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithProvider(const ProfileScreen()));
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Save Profile'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('has proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithProvider(const ProfileScreen()));
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('text fields accept input correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithProvider(const ProfileScreen()));
      final nameField = find.widgetWithText(TextField, 'Name');
      final locationField = find.widgetWithText(TextField, 'Location');
      await tester.enterText(nameField, 'John Doe');
      await tester.enterText(locationField, 'London');
      await tester.pump();
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('London'), findsOneWidget);
    });

    testWidgets('shows validation error when name field is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithProvider(const ProfileScreen()));
      final locationField = find.widgetWithText(TextField, 'Location');
      final saveButton = find.text('Save Profile');
      await tester.enterText(locationField, 'London');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('shows validation error when location field is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithProvider(const ProfileScreen()));
      final nameField = find.widgetWithText(TextField, 'Name');
      final saveButton = find.text('Save Profile');
      await tester.enterText(nameField, 'John Doe');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('shows validation error when both fields are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithProvider(const ProfileScreen()));
      final saveButton = find.text('Save Profile');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('trims whitespace from input fields',
        (WidgetTester tester) async {
      Map<String, String>? result;
      await tester.pumpWidget(_wrapWithProvider(
        Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              result = await Navigator.push<Map<String, String>>(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: const Text('Go to Profile'),
          );
        }),
      ));
      await tester.tap(find.text('Go to Profile'));
      await tester.pumpAndSettle();
      final nameField = find.widgetWithText(TextField, 'Name');
      final locationField = find.widgetWithText(TextField, 'Location');
      final saveButton = find.text('Save Profile');
      await tester.enterText(nameField, '  John Doe  ');
      await tester.enterText(locationField, '  London  ');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(result, isNotNull);
      expect(result!['name'], 'John Doe');
      expect(result!['location'], 'London');
    });

    testWidgets('returns profile data when both fields are filled',
        (WidgetTester tester) async {
      Map<String, String>? result;
      await tester.pumpWidget(_wrapWithProvider(
        Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              result = await Navigator.push<Map<String, String>>(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: const Text('Go to Profile'),
          );
        }),
      ));
      await tester.tap(find.text('Go to Profile'));
      await tester.pumpAndSettle();
      final nameField = find.widgetWithText(TextField, 'Name');
      final locationField = find.widgetWithText(TextField, 'Location');
      final saveButton = find.text('Save Profile');
      await tester.enterText(nameField, 'Jane Smith');
      await tester.enterText(locationField, 'Manchester');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(result, isNotNull);
      expect(result!['name'], 'Jane Smith');
      expect(result!['location'], 'Manchester');
    });

    testWidgets('text fields have proper decoration',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithProvider(const ProfileScreen()));
      final nameField = find.widgetWithText(TextField, 'Name');
      final locationField = find.widgetWithText(TextField, 'Location');
      final TextField name = tester.widget(nameField);
      final TextField location = tester.widget(locationField);
      expect(name.decoration?.labelText, 'Name');
      expect(name.decoration?.border, isNull);
      expect(location.decoration?.labelText, 'Location');
      expect(location.decoration?.border, isNull);
    });

    testWidgets('save button is always enabled', (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithProvider(const ProfileScreen()));
      final saveButton = find.byType(ElevatedButton);
      final ElevatedButton button = tester.widget(saveButton);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('handles special characters', (WidgetTester tester) async {
      Map<String, String>? result;
      await tester.pumpWidget(_wrapWithProvider(
        Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              result = await Navigator.push<Map<String, String>>(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: const Text('Go to Profile'),
          );
        }),
      ));
      await tester.tap(find.text('Go to Profile'));
      await tester.pumpAndSettle();
      final nameField = find.widgetWithText(TextField, 'Name');
      final locationField = find.widgetWithText(TextField, 'Location');
      final saveButton = find.text('Save Profile');
      await tester.enterText(nameField, 'José María');
      await tester.enterText(locationField, 'São Paulo');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(result, isNotNull);
      expect(result!['name'], 'José María');
      expect(result!['location'], 'São Paulo');
    });

    testWidgets('column alignment is start', (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithProvider(const ProfileScreen()));
      final Column column = tester.widget(find.byType(Column));
      expect(column.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets('snackbar has correct duration', (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithProvider(const ProfileScreen()));
      await tester.tap(find.text('Save Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Please fill in all fields'), findsOneWidget);
      final SnackBar snackBar = tester.widget(find.byType(SnackBar));
      expect(snackBar.duration, const Duration(seconds: 2));
    });

    testWidgets('handles empty strings after trimming',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithProvider(const ProfileScreen()));
      final nameField = find.widgetWithText(TextField, 'Name');
      final locationField = find.widgetWithText(TextField, 'Location');
      final saveButton = find.text('Save Profile');
      await tester.enterText(nameField, '   ');
      await tester.enterText(locationField, '   ');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(find.text('Please fill in all fields'), findsOneWidget);
    });
  });
}
