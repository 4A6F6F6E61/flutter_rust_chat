import 'dart:developer';

import 'package:flutter_rust/db/db_message.dart';
import 'package:flutter_rust/global.dart';

class Messages {
  const Messages._();

  static Stream<List<DBMessage>> getAll(int chatId) {
    final select = DB.messages.stream(primaryKey: ["id"]).eq('chat_id', chatId);
    return select.map((list) {
      log("Messages updated", name: "Messages.getAll");
      return list.map<DBMessage>((json) => DBMessage.fromJson(json)).toList();
    });
  }
}
