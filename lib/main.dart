import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';
import 'package:sandwich_shop/views/sign_in_screen.dart';
import 'package:sandwich_shop/views/app_drawer.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      debugShowCheckedModeBanner: false,
      home: const OrderScreen(maxQuantity: 5),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/about':
            return MaterialPageRoute(builder: (_) => const AboutScreen());
          case '/sign_in':
            return MaterialPageRoute(builder: (_) => const SignInScreen());
          default:
            return MaterialPageRoute(
                builder: (_) => const OrderScreen(maxQuantity: 5));
        }
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const int _maxQuantity = 5;

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 1:
        return const AboutScreen();
      case 0:
      default:
        return const OrderScreen(maxQuantity: _maxQuantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      drawer: const AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
