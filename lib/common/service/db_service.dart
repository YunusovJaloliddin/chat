import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../model/user_model.dart';


class DBService {
  static final db = FirebaseDatabase.instance;

  Stream<DatabaseEvent> getAllUser()=>
    db.ref(Folder.user).onValue.asBroadcastStream();

  DatabaseReference queryFromPath() => db.ref(Folder.user);

  static Future<bool> storeUser(String email, String password, String username, String uid) async {
    try {
      final folder = db.ref(Folder.user).child(uid);
      final user = UserModel(id: uid, name: username, email: email, password: password);
      await folder.set(user.toJson());
      return true;
    } catch(e) {
      debugPrint("DB ERROR: $e");
      return false;
    }
  }

  static Future<UserModel?> readUser(String uid) async {
    try {
      final data = db.ref(Folder.user).child(uid).get();
      final member = UserModel.fromJson(jsonDecode(jsonEncode(data)) as Map<String, Object>);
      return member;
    } catch(e) {
      debugPrint("DB ERROR: $e");
      return null;
    }
  }

}

sealed class Folder {
  static const user = "User";
}

