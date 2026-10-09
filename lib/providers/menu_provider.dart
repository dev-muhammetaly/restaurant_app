import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/models/menu_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final menuItemProvider = FutureProvider<List<MenuItem>>((ref) async {
  final supabase = Supabase.instance.client;

  final response = await supabase.from('menu').select()
  // .order('id', ascending: true)
  ;

  return (response as List<dynamic>)
      .map((row) => MenuItem.fromJson(row as Map<String, dynamic>))
      .toList();
});
