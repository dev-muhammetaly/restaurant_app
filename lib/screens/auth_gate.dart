import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_app/providers/auth_provider.dart';
import 'package:restaurant_app/screens/login_screen.dart';
import 'package:restaurant_app/screens/main_navigation_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => Scaffold(
        body: Center(child: Lottie.asset('assets/ForkAndKnife.json')),
      ),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Authentication error: $error'))),
      data: (data) {
        final session = data.session;

        if (session != null) {
          return MainNavigationScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
