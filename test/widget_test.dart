import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity', () {
    testWidgets('shows initial quantity and title',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('Sandwich Counter'), findsOneWidget);

      // Find the Row that contains the "Quantity: " label and assert the numeric quantity inside it.
      final quantityRow = find.ancestor(
          of: find.text('Quantity: '), matching: find.byType(Row));
      expect(find.descendant(of: quantityRow, matching: find.text('1')),
          findsOneWidget);
    });

    testWidgets('increments quantity when + icon tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      // Tap the add icon (IconButton with Icons.add)
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      final quantityRow = find.ancestor(
          of: find.text('Quantity: '), matching: find.byType(Row));
      expect(find.descendant(of: quantityRow, matching: find.text('2')),
          findsOneWidget);
    });

    testWidgets('decrements quantity when - icon tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      // increment first to 2
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      // then decrement
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      final quantityRow = find.ancestor(
          of: find.text('Quantity: '), matching: find.byType(Row));
      expect(find.descendant(of: quantityRow, matching: find.text('1')),
          findsOneWidget);
    });

    testWidgets('does not decrement below zero', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      // Starting at 1 -> tap remove twice -> should be 0
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      final quantityRow = find.ancestor(
          of: find.text('Quantity: '), matching: find.byType(Row));
      expect(find.descendant(of: quantityRow, matching: find.text('0')),
          findsOneWidget);
    });

    testWidgets('increments multiple times', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      // Tap add three times -> 1 + 3 = 4
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }
      final quantityRow = find.ancestor(
          of: find.text('Quantity: '), matching: find.byType(Row));
      expect(find.descendant(of: quantityRow, matching: find.text('4')),
          findsOneWidget);
    });
  });

  group('StyledButton', () {
    testWidgets('renders with icon and label', (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Test Add',
        backgroundColor: Colors.blue,
      );
      const testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      await tester.pumpWidget(testApp);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Test Add'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('OrderItemDisplay', () {
    testWidgets('shows correct text and note for zero sandwiches',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 0,
        itemType: 'footlong',
        breadType: BreadType.white,
        orderNote: 'No notes added.',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      expect(find.text('Note: No notes added.'), findsOneWidget);
    });

    testWidgets('shows correct text and emoji for three sandwiches',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 3,
        itemType: 'footlong',
        breadType: BreadType.white,
        orderNote: 'No notes added.',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(
          find.text('3 white footlong sandwich(es): 🥪🥪🥪'), findsOneWidget);
      expect(find.text('Note: No notes added.'), findsOneWidget);
    });

    testWidgets('shows correct bread and type for two six-inch wheat',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 2,
        itemType: 'six-inch',
        breadType: BreadType.wheat,
        orderNote: 'No pickles',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(find.text('2 wheat six-inch sandwich(es): 🥪🥪'), findsOneWidget);
      expect(find.text('Note: No pickles'), findsOneWidget);
    });

    testWidgets('shows correct bread and type for one wholemeal footlong',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 1,
        itemType: 'footlong',
        breadType: BreadType.wholemeal,
        orderNote: 'Lots of lettuce',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(
          find.text('1 wholemeal footlong sandwich(es): 🥪'), findsOneWidget);
      expect(find.text('Note: Lots of lettuce'), findsOneWidget);
    });
  });
}
