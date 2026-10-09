import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../providers/cart_providers.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the cart items and total amount
    final cart = ref.watch(cartProvider);
    final totalAmount = ref.watch(cartTotalProvider);
    final cartItems = cart.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        centerTitle: true,
        actions: [
          if (cart.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                ref.read(cartProvider.notifier).clearCart();
              },
            ),
        ],
      ),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    child: Lottie.asset('assets/emptyCart.json'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = cartItems[index].key;
                final quantity = cartItems[index].value;

                return Row(
                  children: [
                    // Item Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Name & Price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'TM ${(item.price * quantity).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Quantity Controls (- QTY +)
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        ref.read(cartProvider.notifier).removeItem(item);
                      },
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        ref.read(cartProvider.notifier).addItem(item);
                      },
                    ),
                  ],
                );
              },
            ),

      // Bottom Bar with Grand Total and Order Button
      bottomNavigationBar: cart.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Price',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'TM ${totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    FilledButton(
                      onPressed: () async {
                        // Show a loading dialog while sending to database
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => Center(
                            child: Lottie.asset('assets/ForkAndKnife.json'),
                          ),
                        );

                        // Call Supabase!
                        final success = await ref
                            .read(cartProvider.notifier)
                            .placeOrder(totalAmount);

                        // Close the loading dialog
                        if (context.mounted) Navigator.pop(context);

                        if (success) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Order placed successfully and sent to kitchen!',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Failed to place order. Please try again.',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Place Order'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
