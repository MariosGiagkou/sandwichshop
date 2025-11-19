class PricingRepository {
  final double sixInchPrice;
  final double footlongPrice;

  PricingRepository({
    this.sixInchPrice = 3.50,
    this.footlongPrice = 6.00,
  });

  /// Calculate total price based on quantity and sandwich size.
  /// - quantity: number of sandwiches
  /// - isFootlong: true => footlong price, false => six-inch price
  double calculateTotal({required int quantity, required bool isFootlong}) {
    if (quantity <= 0) return 0.0;
    final unitPrice = isFootlong ? footlongPrice : sixInchPrice;
    return unitPrice * quantity;
  }
}
