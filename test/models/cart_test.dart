import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('Cart', () {
    test('adding items increases items and quantities', () {
      final cart = Cart();
      final s = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.white);

      cart.add(s);
      expect(cart.items.length, 1);
      expect(cart.totalItems, 1);

      cart.add(s, quantity: 2);
      expect(cart.items.length, 1);
      expect(cart.totalItems, 3);
      expect(cart.items.first.quantity, 3);
    });

    test('different bread types create distinct items', () {
      final cart = Cart();
      final s1 = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white);
      final s2 = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.wheat);

      cart.add(s1);
      cart.add(s2);

      expect(cart.items.length, 2);
    });

    test('remove removes the correct item', () {
      final cart = Cart();
      final s1 = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.white);
      final s2 = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.wheat);

      cart.add(s1);
      cart.add(s2);

      expect(cart.items.length, 2);

      cart.remove(s1);
      expect(cart.items.length, 1);
      expect(cart.items.first.sandwich.type, SandwichType.chickenTeriyaki);
    });

    test('updateQuantity updates and removes when zero', () {
      final cart = Cart();
      final s = Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: true,
          breadType: BreadType.wholemeal);

      cart.add(s, quantity: 2);
      expect(cart.items.first.quantity, 2);

      cart.updateQuantity(s, 5);
      expect(cart.items.first.quantity, 5);

      cart.updateQuantity(s, 0);
      expect(cart.items.length, 0);
    });

    test('clear empties the cart', () {
      final cart = Cart();
      cart.add(Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.white));
      cart.add(Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.wheat));

      expect(cart.isEmpty, false);
      cart.clear();
      expect(cart.isEmpty, true);
    });

    test('totalPrice uses PricingRepository for calculation', () {
      final cart = Cart();
      final pricing = PricingRepository();

      // one six-inch (7.0) x2 and one footlong (11.0) x1
      final six = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.white);
      final foot = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.wheat);

      cart.add(six, quantity: 2);
      cart.add(foot, quantity: 1);

      final expected = pricing.calculatePrice(quantity: 2, isFootlong: false) +
          pricing.calculatePrice(quantity: 1, isFootlong: true);

      expect(cart.totalPrice(pricing), expected);
    });
  });
}
