import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/profile_screen.dart';
import 'package:sandwich_shop/views/settings_screen.dart';

/// Shared AppBar builder with logo + title + cart indicator.
PreferredSizeWidget buildAppBar(BuildContext context, String title,
    {List<Widget>? actions, bool showCartIndicator = true}) {
  return AppBar(
    leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: Image.asset('assets/images/logo.png'),
      ),
    ),
    title: Text(title, style: heading1),
    actions: [
      if (showCartIndicator)
        Consumer<Cart>(
          builder: (context, cart, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_cart),
                  const SizedBox(width: 4),
                  Text('${cart.countOfItems}')
                ],
              ),
            );
          },
        ),
      if (actions != null) ...actions,
    ],
  );
}

/// Shared StyledButton.
class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      textStyle: normalText,
    );
    return ElevatedButton(
      onPressed: onPressed,
      style: myButtonStyle,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

/// Shared navigation drawer for consistent navigation between core screens.
class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text('Sandwich Shop', style: heading2),
            ),
          ),
          _navTile(context, Icons.fastfood, 'Order', const OrderScreen()),
          _navTile(context, Icons.shopping_cart, 'Cart', const CartScreen()),
          _navTile(context, Icons.person, 'Profile', const ProfileScreen()),
          _navTile(context, Icons.settings, 'Settings', const SettingsScreen()),
        ],
      ),
    );
  }

  ListTile _navTile(
      BuildContext context, IconData icon, String label, Widget screen) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label, style: normalText),
      onTap: () {
        Navigator.pop(context); // close drawer
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
    );
  }
}
