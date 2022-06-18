
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
  final _user = const types.User(id: 'parent');
  final _other = const types.User(id: 'teacher');
  List<types.Message> _messages = [];


  @override
  void initState()  {

    super.initState();
    CustomAuth.storage.read(key: 'parent').then((res) {
      print("currently..........: $res");
      sender = json.decode(res!);

      print("currently logged in user childOne: ${sender['childOne']}");
      FirebaseFirestore.instance.collection('feedback').where(
          'studentId', isEqualTo: sender['childOne']).orderBy('timestamp').get()
          .then((value) {
        print("response from firebase");
        final new_msg = value.docs.map((chat_msg) {
          print("chat message from server: ${chat_msg.data()['message']}");
          var user;
          if (chat_msg['sender'] == sender['firstName']) {
            print('chat msg sender: $chat_msg');
            user = _user;
          } else {
            user = _other;
          }
          return types.TextMessage(
            author: user,
            id: chat_msg.data()['studentId'] as String,
            text: chat_msg.data()['message'] as String,
          );
          return chat_msg.data()['message'];
        }).toList();
        setState(() {
          // _messages = [...new_msg];
          _messages = [...new List.from(new_msg.reversed)];
        });
      });
    }).catchError((err) {
      print("there is no logged in user found");
    });
  }


  @override
  Widget build(BuildContext context) {
    print("parent value: $_user and _messages: $_messages");
    return Scaffold(
      body: Chat(
        messages: _messages,
        onSendPressed: (types.PartialText msg) {
          final message = types.TextMessage(
              author: _user,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              id: sender['childOne'],
              text: msg.text
          );
          setState(() {
            _messages.insert(0, message);
          });
          FirebaseFirestore.instance.collection('feedback').add({
            'message': msg.text,
            'sender': sender['firstName'],
            'studentId': sender['childOne'],
            'timestamp': DateTime.now().millisecondsSinceEpoch
          }).then((res) {
            print("successfuly writen: $res");
          });
        },
        user: _user,
        theme: DefaultChatTheme(
            inputBackgroundColor: Colors.cyan
        ),
      ),

    );
  }
}
