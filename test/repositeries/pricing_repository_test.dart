import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositeries/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    test('zero quantity returns 0.0', () {
      final repo = PricingRepository();
      expect(repo.calculateTotal(quantity: 0, isFootlong: true), 0.0);
      expect(repo.calculateTotal(quantity: 0, isFootlong: false), 0.0);
    });

    test('six-inch price calculation', () {
      final repo = PricingRepository(); // default six-inch = 3.50
      expect(repo.calculateTotal(quantity: 1, isFootlong: false), 3.50);
      expect(repo.calculateTotal(quantity: 3, isFootlong: false), 10.50);
    });

    test('footlong price calculation', () {
      final repo = PricingRepository(); // default footlong = 6.00
      expect(repo.calculateTotal(quantity: 1, isFootlong: true), 6.00);
      expect(repo.calculateTotal(quantity: 2, isFootlong: true), 12.00);
    });

    test('configurable prices work', () {
      final repo = PricingRepository(sixInchPrice: 4.0, footlongPrice: 7.5);
      expect(repo.calculateTotal(quantity: 2, isFootlong: false), 8.0);
      expect(repo.calculateTotal(quantity: 3, isFootlong: true), 22.5);
    });
  });
}
