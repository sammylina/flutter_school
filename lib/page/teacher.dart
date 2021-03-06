
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school/page/feedback/teacher_feedback.dart';
import 'package:school/page/result/result.dart';
import 'package:school/page/result/resultForTeacher.dart';
import 'package:school/page/auth.dart';
import 'dart:convert';

import 'common/NavBar.dart';
import 'common/announcement.dart';

class Teacher extends StatefulWidget {
  const Teacher({Key? key}) : super(key: key);

  @override
  _TeacherState createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: NavBar(usertype: 'teacher'),
        appBar: AppBar(
          title: Text("Teacher"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Result",icon: Icon(Icons.school_outlined),), Tab(text: "Announcement",icon: Icon(Icons.notifications_active_outlined)), Tab(text: "Feedback",icon: Icon(Icons.message_outlined)),
            ],
          ),
        ),

        //centerTitle: true,



        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
          child: TabBarView(
            children: [
              Center(child: Result(),),
              Center(child: Announcement()),
              Center(child: TeacherFeedback(),)
            ],
          ),
        ),
      ),
    );
  }
}