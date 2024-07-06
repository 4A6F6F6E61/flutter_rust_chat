import 'package:supabase_flutter/supabase_flutter.dart';

class DB {
  DB._();
  static SupabaseClient get _db => Supabase.instance.client;

  static SupabaseQueryBuilder get users => _db.from('users');
  static SupabaseQueryBuilder get chats => _db.from('chats');
  static SupabaseQueryBuilder get chatUser => _db.from('chat_user');
}
