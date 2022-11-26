import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('chats/ZbQEbt652rvKZDJpPNWj/Messages')
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            final documents = streamSnapshot.data!.documents;
            return ListView.builder(
              itemBuilder: (ctx, index) => Container(
                padding: EdgeInsets.all(8),
                child: Text(documents[index]['text']),
              ),
              itemCount: streamSnapshot.data!.documents.length,
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Firestore.instance
              .collection('chats/ZbQEbt652rvKZDJpPNWj/Messages')
              .add({
            'text': 'This was added by clicking the button!',
          });
        },
      ),
    );
  }
}
