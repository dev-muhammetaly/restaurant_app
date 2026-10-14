import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../models/menu_item.dart';
import '../providers/cart_providers.dart';
import '../providers/menu_provider.dart';
import '../widgets/menu_item_cart.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  MenuCategory selectedCategory = MenuCategory.all;

  @override
  Widget build(BuildContext context) {
    final menuAsync = ref.watch(menuItemProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Menu'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          // Category Selector
          SizedBox(
            height: 50,
            width: 350,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: MenuCategory.values.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = MenuCategory.values[index];
                final isSelected = category == selectedCategory;

                return ChoiceChip(
                  label: Text(category.label),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // 2. Handle Loading, Error, and Data from Supabase
          Expanded(
            child: menuAsync.when(
              loading: () =>
                  Center(child: Lottie.asset('assets/ForkAndKnife.json')),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 8),
                    Text('Failed to load menu: $err'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => ref.refresh(menuItemProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (allItems) {
                final filteredItems = selectedCategory == MenuCategory.all
                    ? allItems
                    : allItems
                          .where((item) => item.category == selectedCategory)
                          .toList();

                if (filteredItems.isEmpty) {
                  return const Center(child: Text('No items in this category'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 95),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return MenuItemCart(
                      item: item,
                      onAddToCart: () {
                        ref.read(cartProvider.notifier).addItem(item);

                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.name} added to cart!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
