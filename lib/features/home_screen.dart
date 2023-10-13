import 'package:chat/common/model/user_model.dart';
import 'package:chat/common/service/auth_service.dart';
import 'package:chat/features/chats_screen/chat_screen.dart';
import 'package:chat/features/data/message_repository.dart';
import 'package:chat/features/data/user_repository.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final IUserRepository repository;
  late final IPostRepository postRepository;
  String path="";

  @override
  void initState() {
    repository = UserRepository();
    postRepository=PostRepository();
    super.initState();
  }

  void onTap(String id, String userName) async {
    path= await postRepository.isWrited("chats${AuthService.user!.uid}$id","chats$id${AuthService.user!.uid}");
    if(mounted){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(chatPath: path, userName: userName),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${AuthService.user!.displayName}"),
      ),
      body: FirebaseAnimatedList(
        query: repository.queryPost(),
        itemBuilder: (context, snapshot, animation, index) {
          final user = UserModel.fromJson(
              Map<String, Object?>.from(snapshot.value as Map));
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: ListTile(
              tileColor: Colors.blue,
              onTap: () => onTap(user.id, user.name),
              title: Text(user.name),
            ),
          );
        },
      ),
    );
  }
}
