import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../model/post_entity.dart';

class DatabaseService {
  static final _database = FirebaseDatabase.instance;

  Stream<DatabaseEvent> readAllData(String dataPath) =>
      _database.ref(dataPath).onValue.asBroadcastStream();

  DatabaseReference queryFromPath(String dataPath) => _database.ref(dataPath);

  Future<void> writeNewPost({required Message message,}) async {
    final id=_database.ref("chats").push().key;

    Message newMessage=message.copyWith(id: id);

    await _database.ref("chats/$id").set(newMessage.toJson());
  }

  Future<void> update({
    required String dataPath,
    required String id,
    required Message message,
  }) =>
      _database.ref(dataPath).child(id).update(message.toJson());

  Future<void> delete(String dataPath, String id) => _database.ref(dataPath).child(id).remove();
}
