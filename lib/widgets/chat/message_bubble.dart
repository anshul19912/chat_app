import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {super.key,
      required this.id,
      required this.message,
      required this.isMe,
      required this.username,
      required this.userImage});

  final String id;
  final String message;
  final String username;
  final bool isMe;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    final selectedmessage = FirebaseFirestore.instance.collection('chat');

    return isMe
        ? Dismissible(
            key: ValueKey(id),
            background: Container(
              color: Theme.of(context).errorColor,
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 40,
              ),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
            ),
            direction: DismissDirection
                .endToStart, // will only swipe from right to left
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Are you Sure?"),
                  content: Text("Do you want to delete this message.?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Text("No")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: Text("Yes")),
                  ],
                ),
              );
            },
            onDismissed: ((direction) async {
              await selectedmessage.doc(id).delete();
            }),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: isMe
                              ? Colors.grey
                              : Theme.of(context).accentColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: !isMe
                                  ? Radius.circular(0)
                                  : Radius.circular(12),
                              bottomRight: isMe
                                  ? Radius.circular(0)
                                  : Radius.circular(12))),
                      width: 140,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(username,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isMe
                                      ? Colors.black
                                      : Theme.of(context)
                                          .accentTextTheme
                                          .headline1!
                                          .color)),
                          Text(
                            message,
                            style: TextStyle(
                                color: isMe
                                    ? Colors.black
                                    : Theme.of(context)
                                        .accentTextTheme
                                        .headline1!
                                        .color),
                            textAlign: isMe ? TextAlign.end : TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                    top: -10,
                    left: isMe ? null : 120,
                    right: isMe ? 120 : null,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(userImage),
                    )),
              ],
              clipBehavior: Clip.none,
            ),
          )
        : Stack(
            children: [
              Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color:
                            isMe ? Colors.grey : Theme.of(context).accentColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: !isMe
                                ? Radius.circular(0)
                                : Radius.circular(12),
                            bottomRight: isMe
                                ? Radius.circular(0)
                                : Radius.circular(12))),
                    width: 140,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(username,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isMe
                                    ? Colors.black
                                    : Theme.of(context)
                                        .accentTextTheme
                                        .headline1!
                                        .color)),
                        Text(
                          message,
                          style: TextStyle(
                              color: isMe
                                  ? Colors.black
                                  : Theme.of(context)
                                      .accentTextTheme
                                      .headline1!
                                      .color),
                          textAlign: isMe ? TextAlign.end : TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  // if (isMe)
                  //   IconButton(
                  //       onPressed: () async {
                  //         await selectedmessage.doc(id).delete();
                  //       },
                  //       icon: Icon(Icons.delete)),
                ],
              ),
              Positioned(
                  top: -10,
                  left: isMe ? null : 120,
                  right: isMe ? 120 : null,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(userImage),
                  )),
            ],
            clipBehavior: Clip.none,
          );
  }
}
