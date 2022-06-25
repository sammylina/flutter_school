import 'package:flutter/material.dart';

import 'package:school/page/auth.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherResult extends StatefulWidget {
  const TeacherResult({Key? key}) : super(key: key);

  @override
  _TeacherResultState createState() => _TeacherResultState();
}

class _TeacherResultState extends State<TeacherResult> {


  List<Object> _results = [];
  String? student_grade;


  Future getResult(stdGrade) async {
    print("looking for grade : $stdGrade result");
    var ann = await FirebaseFirestore
        .instance
        .collection('result')
        .where('grade', isEqualTo: stdGrade)
        .get();
    setState(() {
      _results = List.from(ann.docs.map((doc) => Announce.fromSnapshot(doc)));
      print("fetched data: $_results");
    });
    print("student result: $_results");
  }

  @override
  void initState() {
    print("initstate run first");
    super.initState();
    CustomAuth.storage.read(key: 'teacher').then((res) {
      print("currently..........: $res");
      var stdGrade  =  json.decode(res!)['grade'];
      setState(() {
        student_grade = stdGrade;
      });
      getResult(stdGrade);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("results length: ${_results.length}");
    return Scaffold(
      appBar: AppBar(title: Text('Grade $student_grade students result'), ),
      body: Container(

        padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _results.length,
          itemBuilder: (context, index) {
            return AnnList(_results[index] as Announce);
          },
        ),
      ),

    );
  }
}


class Announce {
  String? quarter;
  Map<dynamic, dynamic>? subjects;
  String? fullName;
  Announce();

  Map<dynamic, dynamic> toJson() => {'quarter': quarter, 'subjects': subjects, 'fullName': fullName};
  Announce.fromSnapshot(snapshot)
      : quarter = snapshot.data()['quarter'],
        subjects = snapshot.data()['subjects'],
        fullName = snapshot.data()['fullName'];
}

class AnnList extends StatelessWidget {
  final Announce _ann;

  AnnList(this._ann);
  var subjects;
  @override
  Widget build(BuildContext context) {
    subjects = _ann.subjects!.keys.toList();
    return Column(
      children: [
        Text("${ _ann.fullName}(Q${_ann.quarter})", style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        )),
        Card(
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _ann.subjects!.length,
                itemBuilder: (BuildContext context, int idx) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${subjects![idx]}'),
                        Text('${_ann.subjects![subjects[idx]]}')
                      ],
                    ),
                  );
                }
            )
        ),
      ],
    );
  }
}

