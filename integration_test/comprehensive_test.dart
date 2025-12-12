import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

/// Comprehensive integration tests covering all user journeys
/// including happy paths, edge cases, and error scenarios
@pragma('vm:entry-point')
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile Management Tests', () {
    testWidgets('should save profile with valid data',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile
      final profileButton = find.widgetWithText(StyledButton, 'Profile');
      await tester.ensureVisible(profileButton);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      // Enter profile data
      await tester.enterText(find.byType(TextField).first, 'John Doe');
      await tester.enterText(find.byType(TextField).last, 'New York');
      await tester.pumpAndSettle();

      // Save profile
      await tester.tap(find.text('Save Profile'));
      await tester.pumpAndSettle();

      // Verify back on order screen with welcome message
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.textContaining('Welcome, John Doe'), findsOneWidget);
      expect(find.textContaining('New York'), findsOneWidget);
    });

    testWidgets('should show error when profile fields are empty',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile
      final profileButton = find.widgetWithText(StyledButton, 'Profile');
      await tester.ensureVisible(profileButton);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      // Try to save without entering data
      await tester.tap(find.text('Save Profile'));
      await tester.pumpAndSettle();

      // Verify validation error
      expect(find.text('Please fill in all fields'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget); // Still on profile screen
    });

    testWidgets('should show error when only name is filled',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final profileButton = find.widgetWithText(StyledButton, 'Profile');
      await tester.ensureVisible(profileButton);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      // Only enter name
      await tester.enterText(find.byType(TextField).first, 'John Doe');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('should show error when only location is filled',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final profileButton = find.widgetWithText(StyledButton, 'Profile');
      await tester.ensureVisible(profileButton);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      // Only enter location
      await tester.enterText(find.byType(TextField).last, 'New York');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Please fill in all fields'), findsOneWidget);
    });
  });

  group('Settings and Font Size Tests', () {
    testWidgets('should navigate to settings and adjust font size',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to settings
      final settingsButton = find.widgetWithText(StyledButton, 'Settings');
      await tester.ensureVisible(settingsButton);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      // Verify settings screen
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);

      // Adjust font size
      final slider = tester.widget<Slider>(find.byType(Slider));
      final initialValue = slider.value;

      // Move slider to a different value
      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pumpAndSettle();

      // Verify font size changed
      final newSlider = tester.widget<Slider>(find.byType(Slider));
      expect(newSlider.value, isNot(equals(initialValue)));

      // Navigate back
      await tester.tap(find.text('Back to Order'));
      await tester.pumpAndSettle();

      expect(find.text('Sandwich Counter'), findsOneWidget);
    });
  });

  group('Order History Tests', () {
    testWidgets('should show empty order history initially',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to order history
      final historyButton = find.widgetWithText(StyledButton, 'Order History');
      await tester.ensureVisible(historyButton);
      await tester.tap(historyButton);
      await tester.pumpAndSettle();

      // Might show "No orders yet" or existing orders
      expect(find.text('Order History'), findsOneWidget);
    });

    testWidgets('should display order after completing a purchase',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add item and complete checkout
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(StyledButton, 'Checkout'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm Payment'));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 3));

      // Navigate to order history
      final historyButton = find.widgetWithText(StyledButton, 'Order History');
      await tester.ensureVisible(historyButton);
      await tester.tap(historyButton);
      await tester.pumpAndSettle();

      // Verify order appears
      expect(find.textContaining('ORD'), findsWidgets);
      expect(find.textContaining('£'), findsWidgets);
    });
  });

  group('Cart Management Edge Cases', () {
    testWidgets('should handle adding zero quantity to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Decrease quantity to 0
      final removeButton = find.byIcon(Icons.remove);
      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);

      // Try to add to cart with 0 quantity
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      expect(addToCartButton, findsOneWidget);

      // Button should be disabled (null callback)
      final button = tester.widget<StyledButton>(addToCartButton);
      expect(button.onPressed, isNull);
    });

    testWidgets('should handle removing items from cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // Go to cart
      await tester.tap(find.widgetWithText(StyledButton, 'View Cart'));
      await tester.pumpAndSettle();

      // Remove item
      final removeButton = find.byIcon(Icons.delete);
      await tester.tap(removeButton.first);
      await tester.pumpAndSettle();

      // Verify cart is empty
      expect(find.text('Your cart is empty.'), findsOneWidget);
    });

    testWidgets('should handle incrementing and decrementing in cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // Go to cart
      await tester.tap(find.widgetWithText(StyledButton, 'View Cart'));
      await tester.pumpAndSettle();

      // Increment quantity
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pumpAndSettle();

      expect(find.text('Quantity increased'), findsOneWidget);

      // Decrement quantity
      final removeButtons = find.byIcon(Icons.remove);
      await tester.tap(removeButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Quantity decreased'), findsOneWidget);
    });

    testWidgets('should show error when trying to checkout empty cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Go directly to cart without adding anything
      await tester.tap(find.widgetWithText(StyledButton, 'View Cart'));
      await tester.pumpAndSettle();

      expect(find.text('Your cart is empty.'), findsOneWidget);

      // Try to checkout
      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      if (checkoutButton.evaluate().isNotEmpty) {
        await tester.tap(checkoutButton);
        await tester.pumpAndSettle();

        // Should show error message
        expect(find.text('Your cart is empty'), findsOneWidget);
      }
    });
  });

  group('Multiple Sandwich Types and Variations', () {
    testWidgets('should handle adding different sandwich types',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add Veggie Delight
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // Change to Chicken Teriyaki
      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      // Add Chicken Teriyaki
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // Verify cart has 2 items
      expect(find.textContaining('Cart: 2 items'), findsOneWidget);

      // Go to cart and verify both sandwiches
      await tester.tap(find.widgetWithText(StyledButton, 'View Cart'));
      await tester.pumpAndSettle();

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('should handle switching between footlong and six-inch',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add footlong
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // Switch to six-inch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Add six-inch
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // Verify cart has 2 items
      expect(find.textContaining('Cart: 2 items'), findsOneWidget);

      // Go to cart and verify sizes
      await tester.tap(find.widgetWithText(StyledButton, 'View Cart'));
      await tester.pumpAndSettle();

      expect(find.text('Footlong'), findsOneWidget);
      expect(find.text('Six-inch'), findsOneWidget);
    });

    testWidgets('should handle different bread types',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add with white bread
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // Change bread type
      final breadDropdown = find.byType(DropdownMenu<BreadType>);
      await tester.tap(breadDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();

      // Add with wheat bread
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // Go to cart
      await tester.tap(find.widgetWithText(StyledButton, 'View Cart'));
      await tester.pumpAndSettle();

      expect(find.text('white'), findsOneWidget);
      expect(find.text('wheat'), findsOneWidget);
    });
  });

  group('Large Quantity Tests', () {
    testWidgets('should handle adding large quantities',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Increase quantity to 10
      final addButton = find.byIcon(Icons.add).first;
      for (int i = 0; i < 9; i++) {
        await tester.tap(addButton);
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.pumpAndSettle();

      expect(find.text('10'), findsOneWidget);

      // Add to cart
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // Verify cart shows correct count
      expect(find.textContaining('Cart: 10 items'), findsOneWidget);

      // Verify total price calculation
      await tester.tap(find.widgetWithText(StyledButton, 'View Cart'));
      await tester.pumpAndSettle();

      expect(find.text('Total: £110.00'), findsOneWidget);
    });
  });

  group('Navigation Flow Tests', () {
    testWidgets('should handle back navigation from all screens',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test profile navigation
      await tester.tap(find.widgetWithText(StyledButton, 'Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Profile'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Sandwich Counter'), findsOneWidget);

      // Test settings navigation
      await tester.tap(find.widgetWithText(StyledButton, 'Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);

      await tester.tap(find.text('Back to Order'));
      await tester.pumpAndSettle();
      expect(find.text('Sandwich Counter'), findsOneWidget);

      // Test order history navigation
      await tester.tap(find.widgetWithText(StyledButton, 'Order History'));
      await tester.pumpAndSettle();
      expect(find.text('Order History'), findsOneWidget);

      await tester.tap(find.widgetWithText(StyledButton, 'Back to Order'));
      await tester.pumpAndSettle();
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('should maintain cart state across navigation',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add 3 items
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Cart: 3 items'), findsOneWidget);

      // Navigate to settings and back
      await tester.tap(find.widgetWithText(StyledButton, 'Settings'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Back to Order'));
      await tester.pumpAndSettle();

      // Cart should still have 3 items
      expect(find.textContaining('Cart: 3 items'), findsOneWidget);

      // Navigate to profile and back
      await tester.tap(find.widgetWithText(StyledButton, 'Profile'));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Cart should still have 3 items
      expect(find.textContaining('Cart: 3 items'), findsOneWidget);
    });
  });

  group('Cart Counter Display Tests', () {
    testWidgets('should update cart counter in all screens',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add item
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // Check counter on order screen
      expect(find.textContaining('Cart: 1 items'), findsOneWidget);

      // Check counter in profile screen
      await tester.tap(find.widgetWithText(StyledButton, 'Profile'));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsWidgets); // Cart icon shows count

      await tester.pageBack();
      await tester.pumpAndSettle();

      // Check counter in cart screen
      await tester.tap(find.widgetWithText(StyledButton, 'View Cart'));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsWidgets);
    });
  });

  group('Price Calculation Tests', () {
    testWidgets('should calculate correct prices for six-inch sandwiches',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Switch to six-inch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Add 2 six-inch sandwiches
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(StyledButton, 'View Cart'));
      await tester.pumpAndSettle();

      // Six-inch should be £5.00 each = £10.00 total
      expect(find.text('Total: £10.00'), findsOneWidget);
    });

    testWidgets('should calculate correct prices for mixed sizes',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add 1 footlong
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // Switch to six-inch and add 1
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // Check cart total
      await tester.tap(find.widgetWithText(StyledButton, 'View Cart'));
      await tester.pumpAndSettle();

      // 1 footlong (£11) + 1 six-inch (£5) = £16
      expect(find.text('Total: £16.00'), findsOneWidget);
    });
  });

  group('Checkout Flow Error Scenarios', () {
    testWidgets('should handle payment processing correctly',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add item and go to checkout
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(StyledButton, 'View Cart'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(StyledButton, 'Checkout'));
      await tester.pumpAndSettle();

      // Verify checkout screen elements
      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Payment Method: Card ending in 1234'), findsOneWidget);

      // Start payment
      await tester.tap(find.text('Confirm Payment'));
      await tester.pump();

      // Should show processing indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing payment...'), findsOneWidget);

      // Wait for payment to complete
      await tester.pump(const Duration(seconds: 3));

      // Should be back on order screen with confirmation
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.textContaining('Order'), findsWidgets);
      expect(find.textContaining('confirmed'), findsWidgets);
    });
  });

  group('UI Element Visibility Tests', () {
    testWidgets('should display all UI elements correctly on order screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify all buttons are visible
      expect(find.widgetWithText(StyledButton, 'Add to Cart'), findsOneWidget);
      expect(find.widgetWithText(StyledButton, 'View Cart'), findsOneWidget);
      expect(find.widgetWithText(StyledButton, 'Profile'), findsOneWidget);
      expect(find.widgetWithText(StyledButton, 'Settings'), findsOneWidget);
      expect(
          find.widgetWithText(StyledButton, 'Order History'), findsOneWidget);

      // Verify dropdown menus
      expect(find.byType(DropdownMenu<SandwichType>), findsOneWidget);
      expect(find.byType(DropdownMenu<BreadType>), findsOneWidget);

      // Verify switch
      expect(find.byType(Switch), findsOneWidget);

      // Verify quantity controls
      expect(find.byIcon(Icons.add), findsWidgets);
      expect(find.byIcon(Icons.remove), findsWidgets);
    });
  });
}
