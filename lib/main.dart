import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

// The main application widget
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

// Stateful widget to manage sandwich order state
class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;

  // Increase sandwich quantity (up to maxQuantity)
  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  // Decrease sandwich quantity (down to zero)
  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canIncrease = _quantity < widget.maxQuantity;
    final bool canDecrease = _quantity > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: OrderItemDisplay(
                _quantity,
                'Footlong',
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Left-aligned button
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: StyledButton(
                        label: 'Add',
                        color: Colors.green,
                        icon: Icons.add,
                        onPressed: canIncrease ? _increaseQuantity : null,
                      ),
                    ),
                  ),
                  // Right-aligned button
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: StyledButton(
                        label: 'Remove',
                        color: Colors.red,
                        icon: Icons.remove,
                        onPressed: canDecrease ? _decreaseQuantity : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Stateless widget for displaying sandwich count
class OrderItemDisplay extends StatelessWidget {
  final String itemType;
  final int quantity;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$quantity $itemType sandwich(es): ${'🥪' * quantity}',
      style: const TextStyle(fontSize: 18),
      textAlign: TextAlign.center,
    );
  }
}

// New reusable styled button widget (accepts nullable onPressed)
class StyledButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;

  const StyledButton({
    super.key,
    required this.label,
    this.onPressed,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle baseStyle = ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: baseStyle.copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) => states.contains(MaterialState.disabled) ? Colors.grey : color,
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) => states.contains(MaterialState.disabled) ? Colors.black38 : Colors.white,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(label),
        ],
      ),
    );
  }
}