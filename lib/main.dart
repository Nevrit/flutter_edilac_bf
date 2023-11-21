import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:toast/toast.dart';

import 'DatabaseHandler/api_db_provider.dart';
import 'Screens/LoginForm.dart';
import 'Screens/TaskForm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();
  // String? sessionToken = await storage.read(key: 'session_token');
  MyStorageFunctions storageFunctions = MyStorageFunctions();

  Map<String, String> storageInfo = await storageFunctions.readStorageInfo();
  print(storageInfo);
  // String? nameUser = storageInfo['name_user'];
  String? sessionToken = storageInfo['session_token'];
  // String? database = storageInfo['database'];
  // String? url = storageInfo['url'];
  // String? userId = storageInfo['user_id'];
  // String? profile = storageInfo['profile'];

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.purple,
    ),
    title: "Login App",
    home: sessionToken != '' ? const TaskForm() : LoginForm(),
  ));
}
