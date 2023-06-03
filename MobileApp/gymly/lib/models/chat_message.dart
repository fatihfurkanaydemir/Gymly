class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime messageTime;

  ChatMessage(
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.messageTime,
  );

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      json['id'] as String,
      json['senderId'] as String,
      json['receiverId'] as String,
      json['message'] as String,
      DateTime.parse(json["messageTime"]),
    );
  }
}
