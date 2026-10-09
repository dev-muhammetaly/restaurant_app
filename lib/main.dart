import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:restaurant_app/screens/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  // Initialize Supabase with your project credentials
  await Supabase.initialize(
    url: 'https://bvcwdcxvuorylpbnanhh.supabase.co',
    publishableKey: 'sb_publishable_MakFt41Pg4eJYmxCXWsxsw_r5ndVmKe',
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: AuthGate(),
    );
  }
}
