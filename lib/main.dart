import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBEmO3tI8eXw0AnGlOecdDlJMQdWbWC_KU",
        appId: "1:1028525014512:android:2b1ae2cee9a7daae3b7135",
        messagingSenderId: "1028525014512",
        projectId: "projetflutter-2e0c2",
        // Your web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
        ),
        fontFamily: 'Roboto',
      ),
      home: LoginPage(), // Directly set LoginPage as the home page
    );
  }
}

