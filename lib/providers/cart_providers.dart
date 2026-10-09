import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/menu_item.dart';

// State is just a Map: MenuItem -> Quantity
class CartNotifier extends StateNotifier<Map<MenuItem, int>> {
  CartNotifier() : super({});

  // 1. Add item
  void addItem(MenuItem item) {
    final currentQty = state[item] ?? 0;
    state = {...state, item: currentQty + 1};
  }

  // 2. Remove / Decrement item
  void removeItem(MenuItem item) {
    if (!state.containsKey(item)) return;

    final newQty = state[item]! - 1;
    final newState = Map<MenuItem, int>.from(state);

    if (newQty <= 0) {
      newState.remove(item); // 0 or less? Gone from cart!
    } else {
      newState[item] = newQty; // Still has items? Update count!
    }

    state = newState;
  }

  // 3. Clear cart
  void clearCart() => state = {};

  // Place order to Supabase
  Future<bool> placeOrder(double totalAmount) async {
    if (state.isEmpty) return false;

    try {
      final supabase = Supabase.instance.client;
      final currentUser = supabase.auth.currentUser;

      if (currentUser == null) {
        print('Cannot place order: User not logged in!');
        return false;
      }

      final orderItemsPayload = state.entries.map((entry) {
        return {
          'name': entry.key.name,
          'price': entry.key.price,
          'quantity': entry.value,
        };
      }).toList();

      // Insert order with USER_ID attached!
      await supabase.from('orders').insert({
        'user_id': currentUser.id, // <--- ATTACHES CURRENT LOGGED-IN USER!
        'total_amount': totalAmount,
        'items': orderItemsPayload,
        'status': 'received',
      });

      clearCart();
      return true;
    } catch (e) {
      print('Error placing order: $e');
      return false;
    }
  }
}

// The Cart Provider
final cartProvider = StateNotifierProvider<CartNotifier, Map<MenuItem, int>>((
  ref,
) {
  return CartNotifier();
});

// Grand total price
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.entries.fold(
    0.0,
    (sum, entry) => sum + (entry.key.price * entry.value),
  );
});

// Total item count for cart badge
final cartCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.values.fold(0, (sum, qty) => sum + qty);
});
