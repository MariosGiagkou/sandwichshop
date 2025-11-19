import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Friendly error UI for uncaught build/frame errors.
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(title: const Text('Something went wrong')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'An unexpected error occurred:\n${details.exceptionAsString()}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  };

  FlutterError.onError = (FlutterErrorDetails details) {
    // Keep default behavior (prints in debug) and continue.
    FlutterError.presentError(details);
  };

  runZonedGuarded(() {
    runApp(const App());
  }, (error, stack) {
    // Log uncaught asynchronous errors.
    debugPrint('Uncaught async error: $error\n$stack');
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      // Catch exceptions thrown when creating the home widget and show a small
      // error screen instead of letting the whole app crash.
      home: Builder(builder: (context) {
        try {
          return const OrderScreen(maxQuantity: 5);
        } catch (e, st) {
          return ErrorScreen(error: e, stack: st);
        }
      }),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  // Replaced OrderRepository with a simple local counter and logic
  int _quantity = 0;
  final TextEditingController _notesController = TextEditingController();
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  late final PricingRepository _pricingRepository;

  @override
  void initState() {
    super.initState();
    // no repository to initialize
    _pricingRepository = PricingRepository();
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  VoidCallback? _getIncreaseCallback() {
    if (_quantity < widget.maxQuantity) {
      return () => setState(() => _quantity++);
    }
    return null;
  }

  VoidCallback? _getDecreaseCallback() {
    if (_quantity > 0) {
      return () => setState(() => _quantity--);
    }
    return null;
  }

  void _onSandwichTypeChanged(bool value) {
    setState(() => _isFootlong = value);
  }

  void _onBreadTypeSelected(BreadType? value) {
    if (value != null) {
      setState(() => _selectedBreadType = value);
    }
  }

  List<DropdownMenuItem<BreadType>> _buildDropdownEntries() {
    return BreadType.values
        .map(
          (bread) => DropdownMenuItem<BreadType>(
            value: bread,
            child: Text(bread.name, style: normalText),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice = _pricingRepository.calculatePrice(
      quantity: _quantity,
      isFootlong: _isFootlong,
    );

    String sandwichType = 'footlong';
    if (!_isFootlong) {
      sandwichType = 'six-inch';
    }

    String noteForDisplay;
    if (_notesController.text.isEmpty) {
      noteForDisplay = 'No notes added.';
    } else {
      noteForDisplay = _notesController.text;
    }

    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          height: 100,
          child: Image.asset('assets/images/logo.png'),
        ),
        title: const Text(
          'Sandwich Counter',
          style: heading1,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OrderItemDisplay(
              quantity: _quantity,
              itemType: sandwichType,
              breadType: _selectedBreadType,
              orderNote: noteForDisplay,
            ),
            const SizedBox(height: 20),
            Text(
              'Total Price: £${totalPrice.toStringAsFixed(2)}',
              style: heading2,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('six-inch', style: normalText),
                Switch(
                  value: _isFootlong,
                  onChanged: _onSandwichTypeChanged,
                ),
                const Text('footlong', style: normalText),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButton<BreadType>(
              value: _selectedBreadType,
              items: _buildDropdownEntries(),
              onChanged: _onBreadTypeSelected,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextField(
                key: const Key('notes_textfield'),
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Add a note (e.g., no onions)',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  onPressed: _getIncreaseCallback(),
                  icon: Icons.add,
                  label: 'Add',
                  backgroundColor: Colors.green,
                ),
                const SizedBox(width: 8),
                StyledButton(
                  onPressed: _getDecreaseCallback(),
                  icon: Icons.remove,
                  label: 'Remove',
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
    ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      textStyle: normalText,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: myButtonStyle,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;
  final BreadType breadType;
  final String orderNote;

  const OrderItemDisplay({
    super.key,
    required this.quantity,
    required this.itemType,
    required this.breadType,
    required this.orderNote,
  });

  @override
  Widget build(BuildContext context) {
    final String sandwiches = List.filled(quantity, '🥪').join();
    String displayText =
        '$quantity ${breadType.name} $itemType sandwich(es): $sandwiches';

    return Column(
      children: [
        Text(
          displayText,
          style: normalText,
        ),
        const SizedBox(height: 8),
        Text(
          'Note: $orderNote',
          style: normalText,
        ),
      ],
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final Object error;
  final StackTrace? stack;

  const ErrorScreen({super.key, required this.error, this.stack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App error')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'An error occurred:\n${error.toString()}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Try to replace the error screen with a fresh OrderScreen.
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => const OrderScreen(maxQuantity: 5)),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
