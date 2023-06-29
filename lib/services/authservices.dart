import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthServices {
  //1- change password method
  void changepass(String email, String currentpass, String newpass,
      BuildContext ctx, var currentUser) async {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      var cred =
          EmailAuthProvider.credential(email: email, password: currentpass);
      await currentUser!
          .reauthenticateWithCredential(cred)
          .then((value) => currentUser.updatePassword(newpass))
          .then((value) => FirebaseAuth.instance.signOut());

      Navigator.pop(ctx);
      Navigator.pop(ctx);

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(
        'Your Password has been changed successfully, You can now login with your new password',
      )));
    } on FirebaseAuthException catch (e) {
      var message = 'An error occured, please check your credentials';
      if (e.message != null) {
        message = e.message!;
      }
      Navigator.pop(ctx);
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }

  //2-myprofile edit method
  void submitChangeForm(File? _userImageFile, var currentuser, var initValues,
      BuildContext ctx) async {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      //to store image in firestorage
      if (_userImageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(currentuser!.uid + '.jpg');
        await ref.putFile(_userImageFile);
        final url = await ref.getDownloadURL();
        initValues['image_url'] = url;
      }

      //to store username and email in users collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentuser!.uid)
          .update({
        'username': initValues['username'],
        'image_url': initValues['image_url'],
        'phone_numer': initValues['phone_number']
      });

      //change username and userImage of every messages that have been sent before
      var messages = await FirebaseFirestore.instance
          .collection('chat')
          .where('userId', isEqualTo: currentuser!.uid)
          .get();

      for (int i = 0; i < messages.docs.length; i++) {
        await FirebaseFirestore.instance
            .collection('chat')
            .doc(messages.docs[i]['messageId'])
            .update({
          'username': initValues['username'],
          'userImage': initValues['image_url'],
        });
      }
      Navigator.pop(ctx);
      Navigator.pop(ctx);
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(
        'The changes have been made successfully',
      )));
    } on FirebaseAuthException catch (e) {
      var message = 'An error occured, please check your credentials';
      if (e.message != null) {
        message = e.message!;
      }
      Navigator.of(ctx).pop();
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }

  //3- Forgot password method
  void forgotpass(BuildContext ctx, String email) async {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) => Navigator.of(ctx).pop())
          .then((value) => Navigator.of(ctx).pop())
          .then((value) => ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                content: Text(
                    'We have sent you an email to recover password. Please check your mail'),
              )));
    } on FirebaseAuthException catch (e) {
      var message = 'An error occured, please check your credentials';
      if (e.message != null) {
        message = e.message!;
      }
      Navigator.of(ctx).pop();
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }

  //4- Submit auth form (login or signup)
  Future submitAuthForm(String email, String password, String username,
      String phonenumber, File? image, bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    if (image == null && !isLogin) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text('Please pick an image'),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      return;
    }

    showDialog(
        context: ctx,
        builder: (ctx) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      if (isLogin) {
        authResult = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      }

      Navigator.of(ctx).pop();
      if (isLogin)
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text('Login Successfully'),
        ));
      if (!isLogin)
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text('SignUp Successfully'),
        ));

      
      if (!isLogin) {
        // to store image in firestorage
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user!.uid + '.jpg');
        await ref.putFile(image!);
        final url = await ref.getDownloadURL();

        //to store username and email in users collection
        if (!isLogin)
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'username': username,
            'email': email,
            'image_url': url,
            'phone_numer': phonenumber
          });
      }
    } on FirebaseAuthException catch (e) {
      var message = 'An error occured, please check your credentials';

      if (e.message != null) {
        message = e.message!;
      }
      Navigator.of(ctx).pop();
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }
}
