import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.orange,
          backgroundColor: Colors.orange,
          accentColor: Colors.blue,
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.orange,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)))),
      home: StreamBuilder(
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return ChatScreen();
          }
          ;
          return AuthScreen();
        },
        stream: FirebaseAuth.instance.onAuthStateChanged,
      ),
    );
  }
}
