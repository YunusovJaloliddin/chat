import 'package:chat/common/service/auth_service.dart';
import 'package:chat/features/chats_screen/chat_screen.dart';
import 'package:chat/features/register_screen/register_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // ignore: unnecessary_null_comparison
      home: (AuthService.user==null)? const RegisterPage(): const ChatScreen(),
    );
  }
}
