import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/providers/auth_provider.dart';
import 'package:restaurant_app/screens/info_detail_screen.dart';
import 'package:restaurant_app/screens/order_history_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(title: Text('My Profile'), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,

                  child: Icon(
                    Icons.person_2_rounded,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  user?.email ?? 'Logged In User',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),

                Text(
                  'Member since ${DateTime.now().year}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                SizedBox(height: 32),
                ListTile(
                  leading: Icon(Icons.receipt_long_outlined),
                  title: Text('Order History'),
                  subtitle: Text('Track and view previous orders'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderHistoryScreen(),
                      ),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.notifications_on_outlined),
                  title: Text('User Manual & Table Guide'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfoDetailScreen(
                          title: 'User manual',
                          content: '''
WELCOME TO SMARTDINE TABLE ORDERING
1. Browsing the Menu:
Use the top category tabs (Soups, Salads, Drinks) to browse items, or use the search bar to locate specific dishes.
2. Customizing Your Cart:
Tap the '+' button on any dish card to add it to your order. In the Cart tab, you can adjust quantities or remove items.
3. Ordering to Your Table:
Once you are ready, review your order and tap 'Place Order'. Your order will be immediately transmitted to the restaurant kitchen.
4. Tracking Status:
Visit 'My Orders History' in your Profile tab to check the current preparation status of your items.
''',
                        ),
                      ),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text('Privacy Policy'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InfoDetailScreen(
                          title: 'Privacy Policy',
                          content: '''
PRIVACY POLICY & DATA PROTECTION
Last Updated: October 2026
1. Data Collection:
We collect user email addresses for authentication purposes via Supabase. We do not store sensitive payment information or share user credentials with third parties.
2. Order Data:
Transaction and order histories are stored securely in encrypted cloud databases solely for order fulfillment and kitchen coordination.
3. User Rights:
You have the right to request deletion of your account and personal history at any time through customer support.
''',
                        ),
                      ),
                    );
                  },
                ),
                Divider(),
                SizedBox(height: 24),

                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  icon: Icon(Icons.logout_rounded),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Sign out'),
                        content: Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),

                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              ref
                                  .read(authControllerProvider.notifier)
                                  .signOut();
                            },
                            child: Text('Sign Out'),
                          ),
                        ],
                      ),
                    );
                  },
                  label: Text('Sign Out', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
