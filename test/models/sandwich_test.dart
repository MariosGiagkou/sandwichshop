import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name returns correct display names', () {
      expect(
        Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white,
        ).name,
        'Veggie Delight',
      );

      expect(
        Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.wheat,
        ).name,
        'Chicken Teriyaki',
      );

      expect(
        Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.wholemeal,
        ).name,
        'Tuna Melt',
      );

      expect(
        Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: false,
          breadType: BreadType.white,
        ).name,
        'Meatball Marinara',
      );
    });

    test('image path includes enum name and size', () {
      final footlong = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.wheat,
      );

      expect(
        footlong.image,
        'assets/images/${SandwichType.chickenTeriyaki.name}_footlong.png',
      );

      final sixInch = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.white,
      );

      expect(
        sixInch.image,
        'assets/images/${SandwichType.tunaMelt.name}_six_inch.png',
      );
    });

    test('breadType is preserved after construction', () {
      final s = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.wholemeal,
      );

      expect(s.breadType, BreadType.wholemeal);
    });
  });
}
