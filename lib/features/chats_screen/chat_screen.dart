import 'package:chat/common/model/post_entity.dart';
import 'package:chat/features/data/message_repository.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final IPostRepository repository;
  late final TextEditingController messageController;

  void createPost() async {
    final post = Message(
      body: messageController.text.trim(),
      uid: 2,
    );

    await repository.createPost(post);
  }

  @override
  void initState() {
    messageController = TextEditingController();
    repository = PostRepository();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FirebaseAnimatedList(
            query: repository.queryPost(),
            itemBuilder: (context, snapshot, animation, index) {
              final message = Message.fromJson(
                  Map<String, Object?>.from(snapshot.value as Map));
              return Align(
                alignment: message.uid == 1
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: Text(message.body),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 10, right: 80),
              child: TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.black, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.black, width: 3),
                  ),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: const Size(80, 80)),
                onPressed: createPost,
                child: const Icon(Icons.send)),
          ),
        ],
      ),
    );
  }
}
