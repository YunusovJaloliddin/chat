import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../../common/model/user_model.dart';
import '../../common/service/db_service.dart';

abstract interface class IUserRepository {
  Stream<UserModel> getUllUsers();

  DatabaseReference queryPost();
}

class UserRepository implements IUserRepository {
  UserRepository() : _service = DBService();

  final DBService _service;

  @override
  Stream<UserModel> getUllUsers()=>_service.getAllUser().transform(
    StreamTransformer<DatabaseEvent, UserModel>.fromHandlers(
      handleData: (data, sink) {
        for (final json in (data.snapshot.value as Map).values) {
          final user = UserModel.fromJson(Map<String, Object?>.from(json));
          sink.add(user);
        }
      },
    ),
  );

  @override
  DatabaseReference queryPost() => _service.queryFromPath();
}