import 'dart:developer';

import 'package:flutter_rust/db/db_message.dart';
import 'package:flutter_rust/db/db.dart';

class Messages {
  const Messages._();

  static Future<DBMessage> get(int id) async {
    final json = (await DB.messages.select().eq('id', id)).first;

    return DBMessage.fromJson(json);
  }

  static Stream<List<DBMessage>> getAll(int chatId) {
    final select = DB.messages.stream(primaryKey: ["id"]).eq('chat_id', chatId);
    return select.map((list) {
      log("Messages updated", name: "Messages.getAll");
      return list.map<DBMessage>((json) => DBMessage.fromJson(json)).toList();
    });
  }
}
