
import 'package:flutter/material.dart';
import 'package:school/page/feedback/parent_feedback.dart';
import 'package:school/page/result/resultForParent.dart';

import 'common/NavBar.dart';
import 'common/announcement.dart';

class Parent extends StatefulWidget {
  const Parent({Key? key}) : super(key: key);

  @override
  _ParentState createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: NavBar(usertype: 'parent'),
        appBar: AppBar(
          title: Text("Parent"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Announcement",icon: Icon(Icons.notifications_active_outlined),), Tab(text: "Feedback",icon: Icon(Icons.message_outlined)), Tab(text: "Result",icon: Icon(Icons.school_outlined)),
            ],
          ),
        ),

        //centerTitle: true,



        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
          child: TabBarView(
            children: [
              Center(child: Announcement(),),
              Center(child: ParentFeedback(),),
              Center(child: ParentResultDispaly(),)
            ],
          ),
        ),
      ),
    );
  }
}
