import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../model/post_entity.dart';

class DatabaseService {
  static final _database = FirebaseDatabase.instance;

  Stream<DatabaseEvent> readAllData(String dataPath) =>
      _database.ref(dataPath).onValue.asBroadcastStream();

  DatabaseReference queryFromPath(String dataPath) => _database.ref(dataPath);

  Future<void> writeNewPost(
      {required Message message, required String chatPath}) async {
    final id = _database.ref(chatPath).push().key;

    Message newMessage = message.copyWith(id: id);

    await _database.ref("$chatPath/$id").set(newMessage.toJson());
  }

  Future<void> update({
    required String dataPath,
    required String id,
    required Message message,
  }) =>
      _database.ref(dataPath).child(id).update(message.toJson());

  Future<void> delete(String dataPath, String id) =>
      _database.ref(dataPath).child(id).remove();

  Future<bool> allUsers(String path) async {
    final snapshot = await _database.ref(path).get();
    if(snapshot.value==null)return false;
    return true;
  }
}
