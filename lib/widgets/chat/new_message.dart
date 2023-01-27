import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewMessage extends StatefulWidget {
  NewMessage({super.key, required});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  var user;
  var userData;
  // String? uid;
  // String? userName;
  TextEditingController messagecontroller = new TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });

    log(userData.data()!['username']);

    //send notification
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA0U3izyE:APA91bGxYzaOxb6UeCA6L4AtQ-goCGPu3zmxTyAmtjT70qNtiT3vdgN67HcNtAW7t1kDjbUhHWq2A58G1ROAUMfXMOQ9X0_vn9_2yHBttSsF-zRMVfuIHMhuFxvDPfCQIJknSW0l6N-x',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': _enteredMessage,
            'title': userData.data()!['username'],
          },
          "notification": <String, dynamic>{
            "title": userData.data()!['username'],
            "body": _enteredMessage,
            "android_channel_id": "Chat 24x7"
          },
          "to": "/topics/TPITO"
        }));
    messagecontroller.clear();
  }

  // Future<void> getUserName() async {
  //   uid = await FirebaseAuth.instance.currentUser!.uid;
  //   log(uid!);

  //   var userData = await FirebaseFirestore.instance
  //       .collection('chat')
  //       .where('userId', isEqualTo: uid)
  //       .get();

  //   try {
  //     userName = await userData.docs[0]['username'];
  //   } catch (e) {
  //     userName = 'Unknown';
  //   }
  //   log(userName!);
  // }

  // void sendPushMessage(String body, String title) async {
  //   await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization':
  //             'key=AAAA0U3izyE:APA91bGxYzaOxb6UeCA6L4AtQ-goCGPu3zmxTyAmtjT70qNtiT3vdgN67HcNtAW7t1kDjbUhHWq2A58G1ROAUMfXMOQ9X0_vn9_2yHBttSsF-zRMVfuIHMhuFxvDPfCQIJknSW0l6N-x',
  //       },
  //       body: jsonEncode(<String, dynamic>{
  //         'priority': 'high',
  //         'data': <String, dynamic>{
  //           'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //           'status': 'done',
  //           'body': body,
  //           'title': title,
  //         },
  //         "notification": <String, dynamic>{
  //           "title": title,
  //           "body": body,
  //           "android_channel_id": "Chat 24x7"
  //         },
  //         "to": "/topics/TPITO"
  //       }));
  // }

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
            decoration: InputDecoration(labelText: 'Send a Message'),
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
              await FirebaseMessaging.instance.unsubscribeFromTopic("TPITO");
              messagecontroller.text.trim().isEmpty ? null : _sendMessage();
              // sendPushMessage(_enteredMessage, userName!);
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
