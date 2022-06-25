

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../common/searchpage.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:school/page/auth.dart';
import 'package:uuid/uuid.dart';


import 'dart:convert';

class TeacherFeedback extends StatefulWidget {
  const TeacherFeedback({Key? key}) : super(key: key);

  @override
  _TeacherFeedbackState createState() => _TeacherFeedbackState();
}

class _TeacherFeedbackState extends State<TeacherFeedback> {

  String studentId = '';
  String studentName = '';
  String studentGrade = '';
  var sender;

  var _user = types.User(id: 'teacher');
  final _other = types.User(id: 'other');

  @override
  void initState()  {
    super.initState();
     CustomAuth.storage.read(key: 'teacher').then((res) {
       print("response from local stroage: $res");
       sender = json.decode(res!);
    });
  }

  List<types.Message> _messages = [];
  @override
  Widget build(BuildContext context) {
    print("parent build is rendering: $_messages");
    return Scaffold(
      appBar: AppBar(title: Text(studentName), automaticallyImplyLeading: false, actions: [IconButton(onPressed: () async{

        var student =   await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const SearchPage()));
                print("grades: ${student['grade']}, teacher: ${sender['grade']}");
                studentGrade = student['grade'];
                studentId = '';
                studentName = '';
                if (student['grade'] == sender['grade']) {
                  studentId = student['childOne'];
                  print("selected std: $student");
                  setState(() {
                    studentName = student['fullName'];
                    // studentGrade = student['grade'];
                  });
                  FirebaseFirestore.instance.collection('feedback').where(
                      'studentId', isEqualTo: studentId).orderBy('timestamp')
                      .get()
                      .then((value) {
                    print("response from firebase");
                    final new_msg = value.docs.map((chat_msg) {
                      print("chat message from server: ${chat_msg
                          .data()['message']}");
                      var user;
                      if (chat_msg['sender'] == sender['firstName']) {
                        user = _user;
                      } else {
                        user = _other;
                      }
                      return types.TextMessage(
                        author: user,
                        id: chat_msg.data()['sender'] as String,
                        text: chat_msg.data()['message'] as String,
                      );
                      return chat_msg.data()['message'];
                    }).toList();
                    setState(() {
                      _messages = [...new List.from(new_msg.reversed)];
                    });
                  });
                }
      }, icon: Icon(Icons.person_add))]),
      body: Chat(
          messages: _messages,
          onSendPressed: (types.PartialText msg) {
            final message = types.TextMessage(
              author: _user,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              id: const Uuid().v4(),
              text: msg.text
            );
            if (studentGrade == sender['grade']) {
              setState(() {
                _messages.insert(0, message);
              });
              FirebaseFirestore.instance.collection('feedback').add({
                'message': msg.text,
                'sender': sender['firstName'],
                'studentId': studentId,
                'timestamp': DateTime.now().millisecondsSinceEpoch
              }).then((res) {
                print("successfuly writen: $res");
              });
            }
          },
          user: _user,
          theme: DefaultChatTheme(
            inputBackgroundColor: Colors.cyan
          ),
      ),

    );
    // return Container(
    //   child: Column(
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           Text(studentName),
    //           ElevatedButton(onPressed: () async {
    //             print("going to search page");
    //             var student =   await Navigator.push(context,
    //                 MaterialPageRoute(builder: (context) => const SearchPage()));
    //             studentId = student['childOne'];
    //             print("selected std: $student");
    //             setState(() {
    //               studentName = student['fullName'];
    //               // studentGrade = student['grade'];
    //             });
    //           }, child: Text("Search student")),
    //         ],
    //       ),
    //       Chat(
    //         messages: _messages,
    //         onSendPressed: (types.PartialText message) {
    //
    //       },
    //         user: _teacher,
    //       ),
    //     ],
    //   )
    // );
  }
}
