import 'package:flutter_rust/db/db_user.dart';
import 'package:flutter_rust/db/db.dart';

class Users {
  static Stream<List<Map<String, dynamic>>> getAll() {
    final select = DB.users.select();
    return select.asStream();
  }

  static Future<DBUser> get(String id) async {
    final response = await DB.users.select().eq('id', id);
    return DBUser.fromMap(response.first);
  }
}
