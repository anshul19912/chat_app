import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              reverse: true,
              itemCount: chatSnapshot.data!.docs.length,
              itemBuilder: ((context, index) => MessageBubble(
                
                    id: chatSnapshot.data!.docs[index].id,
                    message: chatSnapshot.data!.docs[index].data()['text'],
                    isMe: chatSnapshot.data!.docs[index].data()['userId'] ==
                        user!.uid,
                    username: chatSnapshot.data!.docs[index].data()['username'],
                    userImage:
                        chatSnapshot.data!.docs[index].data()['userImage'],
                  )));
        });
  }
}
