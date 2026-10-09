import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authStateProvider = StreamProvider.autoDispose<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider).value;
  return authState?.session?.user ?? Supabase.instance.client.auth.currentUser;
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  AuthNotifier() : super(AsyncValue.data(null));

  final _supabase = Supabase.instance.client;

  Future<bool> signIn(String email, String password) async {
    state = AsyncValue.loading();
    try {
      await _supabase.auth.signInWithPassword(
        password: password.trim(),
        email: email.trim(),
      );
      state = AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    state = AsyncValue.loading();
    try {
      await _supabase.auth.signUp(
        password: password.trim(),
        email: email.trim(),
      );
      state = AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier();
});
