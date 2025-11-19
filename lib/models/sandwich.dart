enum BreadType { white, wheat, wholemeal }

enum SandwichType {
  veggieDelight,
  ham,
  tuna,
  blt,
}

class Sandwich {
  final SandwichType type;
  final bool isFootlong;
  final BreadType breadType;

  Sandwich({
    required this.type,
    required this.isFootlong,
    required this.breadType,
  });

  String get name {
    switch (type) {
      case SandwichType.veggieDelight:
        return 'Veggie Delight';
      case SandwichType.ham:
        return 'Ham';
      case SandwichType.tuna:
        return 'Tuna Melt';
      case SandwichType.blt:
        return 'blt';
    }
  }

  String get image {
    String typeString = type.name;
    String sizeString = '';
    if (isFootlong) {
      sizeString = 'footlong';
    } else {
      sizeString = 'six_inch';
    }
    return 'assets/images/${typeString}_$sizeString.png';
  }
}

