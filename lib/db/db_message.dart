class DBMessage {
  final int id;
  final int chatId;
  final String userId;
  final String content;
  final String? replyTo;
  final DateTime createdAt;
  final DateTime updatedAt;

  DBMessage({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.content,
    this.replyTo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DBMessage.fromJson(Map<String, dynamic> json) {
    return DBMessage(
      id: json['id'],
      chatId: json['chat_id'],
      userId: json['user_id'],
      content: json['content'],
      replyTo: json['reply_to'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'user_id': userId,
      'content': content,
      'reply_to': replyTo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
