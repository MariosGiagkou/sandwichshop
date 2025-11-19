import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: SizedBox(
              width: double.infinity,
              child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.fastfood),
            title: const Text('Order'),
            onTap: () {
              Navigator.pop(context); // close drawer
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/sign_in');
            },
          ),
        ],
      ),
    );
  }
}
