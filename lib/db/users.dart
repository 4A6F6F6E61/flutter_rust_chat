import 'package:flutter_rust/global.dart';

class Users {
  Stream<List<Map<String, dynamic>>> getAll() {
    final select = DB.users.select();
    return select.asStream();
  }
}
