import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/services/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class NewMessage extends StatefulWidget {
  NewMessage({super.key, required});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  var userData = null;

  TextEditingController messagecontroller = new TextEditingController();

  Future<void> _sendMessage() async {
    messagecontroller.clear();
    FocusScope.of(context).unfocus();

    final user = await FirebaseAuth.instance.currentUser;
    userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    String messageId = const Uuid().v1();

    await FirebaseFirestore.instance.collection('chat').doc(messageId).set({
      'messageId': messageId,
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });
  }

  //

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: messagecontroller,
            decoration: InputDecoration(
                labelText: 'Send a Message',
                labelStyle: TextStyle(color: Colors.black)),
            onChanged: (value) {
              // this will execute on every key stroke
              setState(() {
                _enteredMessage = value;
              });
            },
            autocorrect: true,
            enableSuggestions: true,
            textCapitalization: TextCapitalization.sentences,
          )),
          IconButton(
            onPressed: () async {
              await _sendMessage();
              await FirebaseMessaging.instance.unsubscribeFromTopic("TPITO");
              await sendNotification(
                _enteredMessage,
                userData.data()!['username'],
              );
              await FirebaseMessaging.instance.subscribeToTopic("TPITO");
            },
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
