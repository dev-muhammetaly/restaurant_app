import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSignUp = false; // Toggles between Login and Sign Up
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final fullName = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      if (_isSignUp) {
        // 1. SUPABASE SIGN UP WITH USER METADATA (Name & Phone)
        await supabase.auth.signUp(
          email: email,
          password: password,
          data: {'full_name': fullName, 'phone': phone},
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully! Welcome!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // 2. SUPABASE SIGN IN
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Branding Icon
                  Container(
                    height: 200,
                    child: Lottie.asset('assets/loginFork.json'),
                  ),
                  const SizedBox(height: 12),

                  // Header
                  Text(
                    _isSignUp ? 'Create an Account' : 'Welcome Back',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isSignUp
                        ? 'Fill in your details to get started with table ordering'
                        : 'Sign in to access your orders and favorites',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 28),

                  // ---------------- SIGN UP ONLY FIELDS ----------------
                  if (_isSignUp) ...[
                    // Full Name Field
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      validator: (value) {
                        if (!_isSignUp) return null;
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Phone Number Field
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      validator: (value) {
                        if (!_isSignUp) return null;
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                  ],

                  // ---------------- EMAIL (COMMON) ----------------
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // ---------------- PASSWORD (COMMON) ----------------
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: _isSignUp
                        ? TextInputAction.next
                        : TextInputAction.done,
                    onFieldSubmitted: (_) {
                      if (_isSignUp) {
                        FocusScope.of(context).nextFocus();
                      } else {
                        _submit();
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // ---------------- CONFIRM PASSWORD (SIGN UP ONLY) ----------------
                  if (_isSignUp) ...[
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                            );
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      validator: (value) {
                        if (!_isSignUp) return null;
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                  ],

                  const SizedBox(height: 12),

                  // Submit Button
                  FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: Lottie.asset('assets/ForkAndKnife.json'),
                          )
                        : Text(
                            _isSignUp ? 'Create Account' : 'Sign In',
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 16),

                  // Toggle between Login & Sign Up
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isSignUp = !_isSignUp;
                        _formKey.currentState?.reset();
                      });
                    },
                    child: Text(
                      _isSignUp
                          ? 'Already have an account? Sign In'
                          : "Don't have an account? Sign Up",
                    ),
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
