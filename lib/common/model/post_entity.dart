import 'package:meta/meta.dart';

class Message {
  final int uid;
  final String body;
  final String id;
  final DateTime createdAt;

  Message({
    required this.uid,
    required this.body,
    this.id = "",
    final DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toUtc();

  factory Message.fromJson(Map<String, Object?> json) => Message(
        uid: json["uid"] as int,
        body: json["body"] as String,
        id: json["id"] as String,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"] as String)
            : null,
      );

  Map<String, Object?> toJson() => {
        "uid": uid,
        "body": body,
        "id": id,
        "created_at": createdAt.toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          body == other.body &&
          id == other.id &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      uid.hashCode ^ body.hashCode ^ id.hashCode ^ createdAt.hashCode;

  @override
  String toString() {
    return 'Message{uid: $uid, body: $body, id: $id, createdAt: $createdAt}';
  }

  @useResult
  Message copyWith({
    int? uid,
    String? body,
    String? id,
  }) =>
      Message(
        uid: uid ?? this.uid,
        body: body ?? this.body,
        id: id ?? this.id,
      );
}
