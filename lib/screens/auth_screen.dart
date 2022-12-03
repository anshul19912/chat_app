import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;

  void _submitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext ctx) async {
    AuthResult authResult;

    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
      
      await Firestore.instance
          .collection('users')
          .document(authResult.user.uid)
          .setData({'username': username, 'email': email});
    } on PlatformException catch (e) {
      var message = 'An error occured, please check your credentials';

      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: AuthForm(
        submitFn: _submitAuthForm,
        isLoading: isLoading,
      ),
    );
  }
}
