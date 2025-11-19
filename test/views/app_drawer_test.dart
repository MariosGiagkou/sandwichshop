import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/app_drawer.dart';

void main() {
  testWidgets('AppDrawer shows menu items and navigates to About/Profile',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      routes: {
        '/about': (_) =>
            const Scaffold(body: Center(child: Text('About Page'))),
        '/sign_in': (_) =>
            const Scaffold(body: Center(child: Text('Profile Page'))),
      },
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(),
          drawer: const AppDrawer(),
          body: const Center(child: Text('Home')),
        );
      }),
    ));

    // Open drawer via hamburger tooltip
    final Finder openDrawer = find.byTooltip('Open navigation menu');
    expect(openDrawer, findsOneWidget);
    await tester.tap(openDrawer);
    await tester.pumpAndSettle();

    // Drawer items visible
    expect(find.text('Order'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Tap About and verify navigation
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
    expect(find.text('About Page'), findsOneWidget);

    // Go back to home
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Re-open drawer and tap Profile
    await tester.tap(openDrawer);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Profile Page'), findsOneWidget);
  });
}
