import 'package:chat/common/model/post_entity.dart';
import 'package:chat/common/service/auth_service.dart';
import 'package:chat/features/data/message_repository.dart';
import 'package:chat/features/register_screen/register_screen.dart';
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
  late final TextEditingController editController;

  void createPost() async {
    final post = Message(
      body: messageController.text.trim(),
      uid: 2,
    );
    messageController.clear();
    await repository.createPost(post);
  }

  void editPost(Message message) async {
    final editMessage = Message(
      uid: message.uid,
      body: editController.text == "" ? message.body : editController.text,
      id: message.id,
      edited: "1",
    );

    await repository.updatePost(editMessage);

    if (context.mounted) {
      Navigator.pop(context);
    }

    editController.text = "";
  }

  void logOut() async {
    bool logout = await AuthService.logOut();

    if (logout && mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterPage(),
          ));
    }
  }

  Future<void> deletePost(String id) async {
    await repository.deletePost(id);

    if (context.mounted) {
      Navigator.pop<bool>(context, true);
    }
  }

  @override
  void initState() {
    editController = TextEditingController();
    messageController = TextEditingController();
    repository = PostRepository();
    super.initState();
  }

  @override
  void dispose() {
    editController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AuthService.user.displayName!,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(onPressed: logOut, icon: const Icon(Icons.delete)),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 80, left: 5, right: 5),
              child: FirebaseAnimatedList(
                reverse: true,
                sort: (a, b) {
                  final aValue = Message.fromJson(
                    Map<String, Object?>.from(a.value as Map),
                  );

                  final bValue = Message.fromJson(
                    Map<String, Object?>.from(b.value as Map),
                  );

                  return bValue.createdAt.compareTo(aValue.createdAt);
                },
                query: repository.queryPost(),
                itemBuilder: (context, snapshot, animation, index) {
                  final message = Message.fromJson(
                      Map<String, Object?>.from(snapshot.value as Map));
                  return Align(
                    alignment: message.uid == 1
                        ? Alignment.bottomLeft
                        : Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: InkWell(
                        onLongPress: () => showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                message.uid == 2
                                    ? IconButton(
                                        onPressed: () => showModalBottomSheet(
                                          context: context,
                                          builder: (context) => Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom,
                                              top: 10,
                                              right: 10,
                                              left: 10,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: editController,
                                                  decoration:
                                                      const InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 3),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 3),
                                                    ),
                                                  ),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () =>
                                                        editPost(message),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.blue,
                                                    ),
                                                    child: const Text("OK"))
                                              ],
                                            ),
                                          ),
                                        ),
                                        icon: const Icon(Icons.edit),
                                      )
                                    : const SizedBox.shrink(),
                                IconButton(
                                  onPressed: () => deletePost(message.id),
                                  icon: const Icon(Icons.delete),
                                )
                              ],
                            );
                          },
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                              maxHeight: 50),
                          child: SizedBox(
                            height: 50,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.only(
                                  topRight: const Radius.circular(10),
                                  topLeft: const Radius.circular(10),
                                  bottomLeft: message.uid == 2
                                      ? const Radius.circular(10)
                                      : Radius.zero,
                                  bottomRight: message.uid == 1
                                      ? const Radius.circular(10)
                                      : Radius.zero,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      message.body,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Row(
                                        children: [
                                          message.edited == "1"
                                              ? const Text(
                                                  "edited ",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              : const Text(""),
                                          Text(
                                            "${message.createdAt.hour}:${message.createdAt.minute}",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 10, right: 80),
                child: TextField(
                  onTapOutside: (event) => focusNode.unfocus(),
                  focusNode: focusNode,
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
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(80, 80)),
                  onPressed: createPost,
                  child: const Icon(Icons.send)),
            ),
          ],
        ),
      ),
    );
  }
}
