
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:school/page/auth.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentFeedback extends StatefulWidget {
  const ParentFeedback({Key? key}) : super(key: key);

  @override
  _ParentFeedbackState createState() => _ParentFeedbackState();
}

class _ParentFeedbackState extends State<ParentFeedback> {

  var sender;
  var _teacher = types.User(id: 'teacher');
  var _parent = types.User(id: 'parent');
  var user;
  List<types.Message> _messages = [];

  @override
  void initState()  {
    super.initState();
    CustomAuth.storage.read(key: 'parent').then((res) {
      print("currently..........: $res");
      sender = json.decode(res!);

      print("currently logged in user childOne: ${sender['childOne']}");
      FirebaseFirestore.instance.collection('feedback').where(
          'studentId', isEqualTo: sender['childOne']).get()
          .then((value) {
        print("response from firebase");
        final new_msg = value.docs.map((chat_msg) {
          print("chat message from server: ${chat_msg.data()['message']}");

          if (chat_msg['sender'] == sender['firstName']) {
            user = _parent;
          } else {
            user = _teacher;
          }
          return types.TextMessage(
            author: user,
            id: chat_msg.data()['studentId'] as String,
            text: chat_msg.data()['message'] as String,
          );
          return chat_msg.data()['message'];
        }).toList();
        setState(() {
          _messages = [...new_msg];
        });
      });
    }).catchError((err) {
      print("there is no logged in user found");
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Chat(
        messages: _messages,
        onSendPressed: (types.PartialText msg) {},
        user: _parent,
        theme: DefaultChatTheme(
            inputBackgroundColor: Colors.cyan
        ),
      ),

    );
  }
}
