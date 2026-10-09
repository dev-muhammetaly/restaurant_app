import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/providers/cart_providers.dart';
import 'package:restaurant_app/screens/home_screen.dart';
import 'package:restaurant_app/screens/cart_screen.dart';
import 'package:restaurant_app/screens/profile_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [Homescreen(), CartScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    final totalCartCount = ref.watch(cartCountProvider);

    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: NavigationBar(
                height: 65,
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.surface,
                indicatorColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.15),
                selectedIndex: _currentIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    _currentIndex = value;
                  });
                },
                destinations: [
                  const NavigationDestination(
                    icon: Icon(Icons.restaurant_menu_outlined),
                    selectedIcon: Icon(Icons.restaurant_menu),
                    label: 'Menu',
                  ),
                  NavigationDestination(
                    icon: Badge(
                      label: Text('$totalCartCount'),
                      isLabelVisible: totalCartCount > 0,
                      child: const Icon(Icons.shopping_bag_outlined),
                    ),
                    selectedIcon: Badge(
                      label: Text('$totalCartCount'),
                      isLabelVisible: totalCartCount > 0,
                      child: const Icon(Icons.shopping_bag),
                    ),
                    label: 'Cart',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
