import 'sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

// New: maximum allowed quantity per sandwich
const int kMaxQuantity = 10;

class Cart {
  final Map<Sandwich, int> _items = {};

  // Returns a read-only copy of the items and their quantities
  Map<Sandwich, int> get items => Map.unmodifiable(_items);

  void add(Sandwich sandwich, {int quantity = 1}) {
    if (quantity < 1) {
      // invalid call: ignore or could throw; choose ignore to keep callers simple
      return;
    }

    final int toAdd = quantity;
    final int current = _items[sandwich] ?? 0;
    final int newQty =
        (current + toAdd) > kMaxQuantity ? kMaxQuantity : (current + toAdd);

    _items[sandwich] = newQty;
  }

  void remove(Sandwich sandwich, {int quantity = 1}) {
    if (quantity < 1) {
      return;
    }

    if (_items.containsKey(sandwich)) {
      final currentQty = _items[sandwich]!;
      if (currentQty > quantity) {
        _items[sandwich] = currentQty - quantity;
      } else {
        _items.remove(sandwich);
      }
    }
  }

  // New helper to increment by 1, respecting kMaxQuantity.
  void incrementQuantity(Sandwich sandwich) {
    if (!_items.containsKey(sandwich)) {
      add(sandwich, quantity: 1);
      return;
    }
    final current = _items[sandwich]!;
    if (current >= kMaxQuantity) {
      return;
    }
    _items[sandwich] = current + 1;
  }

  // New helper to decrement by 1; if the result is 0 the item is removed.
  void decrementQuantity(Sandwich sandwich) {
    if (!_items.containsKey(sandwich)) return;
    final current = _items[sandwich]!;
    if (current > 1) {
      _items[sandwich] = current - 1;
    } else {
      // quantity would become 0 -> remove item
      _items.remove(sandwich);
    }
  }

  void clear() {
    _items.clear();
  }

  double get totalPrice {
    final pricingRepository = PricingRepository();
    double total = 0.0;

    for (Sandwich sandwich in _items.keys) {
      int quantity = _items[sandwich]!;
      total += pricingRepository.calculatePrice(
        quantity: quantity,
        isFootlong: sandwich.isFootlong,
      );
    }

    return total;
  }

  bool get isEmpty => _items.isEmpty;

  int get length => _items.length;

  int get countOfItems {
    int total = 0;
    for (Sandwich sandwich in _items.keys) {
      total += _items[sandwich]!;
    }
    return total;
  }

  int getQuantity(Sandwich sandwich) {
    if (_items.containsKey(sandwich)) {
      return _items[sandwich]!;
    }
    return 0;
  }
}
