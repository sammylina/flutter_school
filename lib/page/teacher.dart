
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school/page/result/result.dart';

import 'common/NavBar.dart';

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
        drawer: NavBar(),
        appBar: AppBar(
          title: Text("Teacher"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Result",icon: Icon(Icons.notifications),), Tab(text: "Annaounce",icon: Icon(Icons.notifications)), Tab(text: "Feedback",icon: Icon(Icons.notifications)),
            ],
          ),
        ),

        //centerTitle: true,



        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
          child: TabBarView(
            children: [
              Center(child: Result(),),
              Center(child: Text("Annaounce"),),
              Center(child: Text("Feedback"),)
            ],
          ),
        ),
      ),
    );
  }
}