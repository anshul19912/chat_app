import 'dart:developer';

import 'package:chat_app/screens/user_profile_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {super.key,
      required this.id,
      required this.message,
      required this.isMe,
      required this.username,
      required this.userImage,
      required this.userid,
      required this.createdat});

  final String id;
  final String message;
  final String username;
  final bool isMe;
  final String userImage;
  final String userid;
  final Timestamp createdat;

  // String time = DateFormat('dd-MM-yyy').format(createdAt);
  @override
  Widget build(BuildContext context) {
    final selectedmessage = FirebaseFirestore.instance.collection('chat');
    DateTime time = createdat.toDate();
    String formattedTime = DateFormat.yMMMMd().add_jm().format(time);

    return isMe
        ? GestureDetector(
            onLongPress: () => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("This message was sent at:"),
                content: Text(formattedTime),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("Okay")),
                ],
              ),
            ),
            child: Dismissible(
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(0))),
                        width: 150,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(username,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            Text(
                              message,
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      top: -10,
                      left: null,
                      right: 120,
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(userImage),
                      )),
                ],
                clipBehavior: Clip.none,
              ),
            ),
          )
        : GestureDetector(
            onLongPress: () => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("This message was sent at:"),
                content: Text(formattedTime),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("Okay")),
                ],
              ),
            ),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(12))),
                      width: 150,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(username,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .accentTextTheme
                                      .headline1!
                                      .color)),
                          Text(
                            message,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .accentTextTheme
                                    .headline1!
                                    .color),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                    top: -10,
                    left: 120,
                    right: null,
                    child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UserProfileScreen(userid: userid))),
                        child: CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(userImage),
                        ))),
              ],
              clipBehavior: Clip.none,
            ),
          );
  }
}
