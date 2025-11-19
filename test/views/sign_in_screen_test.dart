import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/sign_in_screen.dart';

void main() {
  testWidgets('SignInScreen can be pushed, shows fields and Done pops',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SignInScreen())),
              child: const Text('Open SignIn'),
            ),
          ),
        );
      }),
    ));

    // Open SignInScreen
    await tester.tap(find.text('Open SignIn'));
    await tester.pumpAndSettle();

    // Verify UI elements
    expect(find.text('Profile / Sign in'), findsOneWidget);
    expect(find.text('Enter your details (no auth yet)'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.widgetWithText(ElevatedButton, 'Done'), findsOneWidget);

    // Enter text and tap Done
    await tester.enterText(find.byType(TextField).first, 'Alice');
    await tester.enterText(find.byType(TextField).at(1), 'alice@example.com');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Done'));
    await tester.pumpAndSettle();

    // After Done the screen should be popped
    expect(find.text('Open SignIn'), findsOneWidget);
    expect(find.byType(SignInScreen), findsNothing);
  });

  testWidgets('SignInScreen fields accept input when used as home',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignInScreen()));
    await tester.pumpAndSettle();

    // Check helper text and labels
    expect(find.text('Enter your details (no auth yet)'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);

    // Enter text directly
    await tester.enterText(find.byType(TextField).first, 'Bob');
    await tester.enterText(find.byType(TextField).at(1), 'bob@example.com');
    await tester.pump();

    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('bob@example.com'), findsOneWidget);
  });
}
