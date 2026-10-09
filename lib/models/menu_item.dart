enum MenuCategory {
  all('All'),
  soups('Soups'),
  salads('Salads'),
  drinks('Drinks');

  final String label;
  const MenuCategory(this.label);
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final MenuCategory category;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  // Factory to convert Supabase JSON row into a MenuItem object
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    // 1. Safe Category Parsing
    final catString = (json['category']?.toString() ?? '').toLowerCase().trim();
    final category = MenuCategory.values.firstWhere(
      (c) => c.name.toLowerCase() == catString,
      orElse: () => MenuCategory.soups,
    );

    // 2. Safe Price Parsing (Prevents NaN error whether it's int, double, or string)
    double parsedPrice = 0.0;
    final rawPrice = json['price'];
    if (rawPrice is num) {
      parsedPrice = rawPrice.toDouble();
    } else if (rawPrice != null) {
      parsedPrice = double.tryParse(rawPrice.toString()) ?? 0.0;
    }

    return MenuItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unnamed',
      description: json['description']?.toString() ?? '',
      price: parsedPrice,
      imageUrl: json['image_url']?.toString() ?? 'Picture is not avaible',
      category: category,
    );
  }
}
