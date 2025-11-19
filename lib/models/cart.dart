import '../repositories/pricing_repository.dart';
import 'sandwich.dart';

class CartItem {
  final Sandwich sandwich;
  int quantity;

  CartItem({required this.sandwich, this.quantity = 1});

  double totalPrice(PricingRepository pricing) {
    return pricing.calculatePrice(
        quantity: quantity, isFootlong: sandwich.isFootlong);
  }

  bool sameSandwich(CartItem other) {
    return sandwich.type == other.sandwich.type &&
        sandwich.isFootlong == other.sandwich.isFootlong &&
        sandwich.breadType == other.sandwich.breadType;
  }
}

class Cart {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void add(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;
    final existing = _items.where((i) =>
        i.sandwich.type == sandwich.type &&
        i.sandwich.isFootlong == sandwich.isFootlong &&
        i.sandwich.breadType == sandwich.breadType);

    if (existing.isNotEmpty) {
      existing.first.quantity += quantity;
    } else {
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
  }

  void remove(Sandwich sandwich) {
    _items.removeWhere((i) =>
        i.sandwich.type == sandwich.type &&
        i.sandwich.isFootlong == sandwich.isFootlong &&
        i.sandwich.breadType == sandwich.breadType);
  }

  void updateQuantity(Sandwich sandwich, int quantity) {
    if (quantity < 0) return;
    final index = _items.indexWhere((item) =>
        item.sandwich.type == sandwich.type &&
        item.sandwich.isFootlong == sandwich.isFootlong &&
        item.sandwich.breadType == sandwich.breadType);

    if (index == -1) return;

    if (quantity == 0) {
      _items.removeAt(index);
    } else {
      _items[index].quantity = quantity;
    }
  }

  void clear() => _items.clear();

  int get totalItems => _items.fold(0, (p, e) => p + e.quantity);

  double totalPrice(PricingRepository pricing) {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice(pricing));
  }

  bool get isEmpty => _items.isEmpty;
}
