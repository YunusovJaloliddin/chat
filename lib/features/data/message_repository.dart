import 'dart:async';

import 'package:chat/common/model/post_entity.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../common/service/api_service.dart';

abstract interface class IPostRepository {
  DatabaseReference queryPost();

  Stream<Message> getAllData();

  Future<void> createPost(Message post);

  Future<void> deletePost(String id);

  Future<void> updatePost(Message post);
}

class PostRepository implements IPostRepository {
  PostRepository() : _service = DatabaseService();

  final DatabaseService _service;

  @override
  Future<void> createPost(Message post) => _service.writeNewPost(message: post);

  @override
  Future<void> deletePost(String id) => _service.delete("chats", id);

  @override
  Stream<Message> getAllData() => _service.readAllData("chats").transform(
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
  DatabaseReference queryPost() => _service.queryFromPath("chats");

  @override
  Future<void> updatePost(Message post) => _service.update(
        dataPath: "chats",
        id: post.id,
        message: post,
      );
}
