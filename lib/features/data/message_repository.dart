import 'dart:async';

import 'package:chat/common/model/post_entity.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../common/service/api_service.dart';

abstract interface class IPostRepository {
  DatabaseReference queryPost(String path);

  Stream<Message> getAllData(String chatPath);

  Future<void> createPost(Message post, String chatPath);

  Future<void> deletePost(String id,  String chatPath);

  Future<void> updatePost(Message post,  String chatPath);

  Future<String> isWrited(String pathOne, String pathTwo);
}

class PostRepository implements IPostRepository {
  PostRepository() : _service = DatabaseService();

  final DatabaseService _service;

  @override
  Future<void> createPost(Message post,  String chatPath) => _service.writeNewPost(message: post, chatPath: chatPath);

  @override
  Future<void> deletePost(String id,  String chatPath) => _service.delete(chatPath, id);



  @override
  Stream<Message> getAllData(String chatPath) => _service.readAllData(chatPath).transform(
        StreamTransformer<DatabaseEvent, Message>.fromHandlers(
          handleData: (data, sink) {
            for (final json in (data.snapshot.value as Map).values) {
              final post = Message.fromJson(Map<String, Object?>.from(json));
              sink.add(post);
            }
          },
        ),
      );

  @override
  DatabaseReference queryPost(String path) => _service.queryFromPath(path);

  @override
  Future<void> updatePost(Message post,  String chatPath) => _service.update(
        dataPath: chatPath,
        id: post.id,
        message: post,
      );

  @override
  Future<String> isWrited(String pathOne, String pathTwo) async{
    String path;
      bool messages = await _service.allUsers(pathOne);
      if(messages){path=pathOne;}
      else{path=pathTwo;}
    return path;
  }
}
