import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            reverse: true,
            itemCount: chatSnapshot.data!.documents.length,
            itemBuilder: ((context, index) => MessageBubble(
                message: chatSnapshot.data!.documents[index]['text'])));
      },
      stream: Firestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
    );
  }
}
