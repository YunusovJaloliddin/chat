import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'common/service/notification_service.dart';
import 'common/widget/app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationService()
    ..requestPermisson()
    ..generateToken()
    ..notificationSettings();

  runApp(const MyApp());
}
