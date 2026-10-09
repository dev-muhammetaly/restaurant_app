import 'package:restaurant_app/models/menu_item.dart';

class CartItem {
  final MenuItem item;
  final int quantity;

  CartItem({required this.item, required this.quantity});

  CartItem copyWith({int? quantity}) {
    return CartItem(item: item, quantity: quantity ?? this.quantity);
  }

  double get totalRowPrice => item.price * quantity;
}
