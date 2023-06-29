import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> sendNotification(String body, String title) async {
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
            'body': body,
            'title': title,
          },
          "notification": <String, dynamic>{
            "title": title,
            "body": body,
            "android_channel_id": "Chat 24x7"
          },
          "to": "/topics/TPITO"
        }));
}