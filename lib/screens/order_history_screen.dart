import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider that queries the orders table
final orderHistoryProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final supabase = Supabase.instance.client;
  final currentUser = supabase.auth.currentUser;

  if (currentUser == null) return [];

  // Query ONLY this user's orders (extra safety on top of RLS)
  final response = await supabase
      .from('orders')
      .select()
      .eq('user_id', currentUser.id) // <--- FILTERS ONLY CURRENT USER!
      .order('created_at', ascending: false);

  return List<Map<String, dynamic>>.from(response);
});

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Order History'), centerTitle: true),
      body: ordersAsync.when(
        loading: () => Center(child: Lottie.asset('assets/ForkAndKnife.json')),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 8),
                Text(
                  'Failed to load orders: $err',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref.refresh(orderHistoryProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No orders placed yet',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(orderHistoryProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];

                // 1. SAFE TOTAL AMOUNT PARSING (handles num, int, double, or String)
                double total = 0.0;
                final rawTotal = order['total_amount'] ?? order['total'];
                if (rawTotal is num) {
                  total = rawTotal.toDouble();
                } else if (rawTotal != null) {
                  total = double.tryParse(rawTotal.toString()) ?? 0.0;
                }

                // 2. SAFE STATUS
                final status = (order['status']?.toString() ?? 'RECEIVED')
                    .toUpperCase();

                // 3. SAFE ITEMS PARSING (handles List, or JSON String, or null)
                List<dynamic> itemsList = [];
                final rawItems = order['items'];
                if (rawItems is List) {
                  itemsList = rawItems;
                } else if (rawItems is String) {
                  try {
                    itemsList = jsonDecode(rawItems) as List<dynamic>;
                  } catch (_) {}
                }

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Order ID + Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${order['id'] ?? index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: status == 'COMPLETED'
                                    ? Colors.green.shade50
                                    : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: status == 'COMPLETED'
                                      ? Colors.green.shade300
                                      : Colors.orange.shade300,
                                ),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: status == 'COMPLETED'
                                      ? Colors.green.shade800
                                      : Colors.orange.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),

                        // List of items
                        if (itemsList.isEmpty)
                          const Text(
                            'No item details available',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        else
                          ...itemsList.map((item) {
                            final map = item is Map ? item : {};
                            final name = map['name'] ?? map['ady'] ?? 'Item';
                            final qty = map['quantity'] ?? map['qty'] ?? 1;

                            double itemPrice = 0.0;
                            final rawPrice = map['price'] ?? map['baha'];
                            if (rawPrice is num) {
                              itemPrice = rawPrice.toDouble();
                            } else if (rawPrice != null) {
                              itemPrice =
                                  double.tryParse(rawPrice.toString()) ?? 0.0;
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('$qty x $name'),
                                  Text(
                                    'TM ${(itemPrice * qty).toStringAsFixed(2)}',
                                  ),
                                ],
                              ),
                            );
                          }),

                        const Divider(height: 24),

                        // Grand Total Paid
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Paid',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'TM ${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
