import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'edit_profile_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
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
                      Icons.manage_accounts,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('My Profile')
                  ],
                ),
                value: 'profile',
                onTap: () {},
              ),
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
                    Text('Tips')
                  ],
                ),
                value: 'tip',
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
                          title: Text("Tips"),
                          content: Text(
                              "1- Swipe your message from right to left to delete it. \n2- Long press on the message to view when it was sent."),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: Text("Okay"))
                          ],
                        ));
              }
              if (itemIdentifier == 'profile') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => EditProfileScreen()));
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [Expanded(child: Messages()), NewMessage()],
        ),
      ),
    );
  }
}
