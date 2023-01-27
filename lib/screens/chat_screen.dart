import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String uid = '';
  late String userName = '';

  Future<void> getUserName() async {
    uid = await FirebaseAuth.instance.currentUser!.uid;
    log(uid);

    var userData = await FirebaseFirestore.instance
        .collection('chat')
        .where('userId', isEqualTo: uid)
        .get();

    try {
      userName = await userData.docs[0]['username'];
    } catch (e) {
      userName = 'Unknown';
    }
    log(userName);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Tip')
                  ],
                ),
                value: 'tip',
                onTap: () {},
              ),
              PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout')
                    ],
                  ),
                  onTap: () => FirebaseAuth.instance.signOut()),
            ],
            onSelected: (itemIdentifier) {
              if (itemIdentifier == 'tip') {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text("Delete your Message"),
                          content: Text(
                              "Swipe your message from right to left to delete it."),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: Text("Okay"))
                          ],
                        ));
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Messages()),
            NewMessage(username: userName)
          ],
        ),
      ),
    );
  }
}
