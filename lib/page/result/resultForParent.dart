import 'package:flutter/material.dart';

import 'package:school/page/auth.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentResultDispaly extends StatefulWidget {
  const ParentResultDispaly({Key? key}) : super(key: key);

  @override
  _ParentResultDispalyState createState() => _ParentResultDispalyState();
}

class _ParentResultDispalyState extends State<ParentResultDispaly> {

  List<Object> _results = [];


  Future getResult(stdId) async {
    print("looking for student : $stdId");
    var ann = await FirebaseFirestore
        .instance
        .collection('result')
        .where('studentId', isEqualTo: stdId)
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
    CustomAuth.storage.read(key: 'parent').then((res) {
      print("currently..........: $res");
      var stdId  =  json.decode(res!)['childOne'];

      getResult(stdId);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("results length: ${_results.length}");
    return Scaffold(
      body: Container(


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
  Announce();

  Map<dynamic, dynamic> toJson() => {'quarter': quarter, 'subjects': subjects};
  Announce.fromSnapshot(snapshot)
      : quarter = snapshot.data()['quarter'],
        subjects = snapshot.data()['subjects'];
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
        Text("Quarter   ${ _ann.quarter}", style: TextStyle(
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
    // return Container(
    //     child: Card(
    //       child: Padding(
    //         padding: const EdgeInsets.all(12),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //
    //                 Text('${_ann.quarter}', style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 18
    //                 )),
    //                 Spacer(),
    //                 Text(
    //                   'subject gose here',
    //                 ),
    //
    //           ],
    //         ),
    //       ),
    //     )
    // );
  }
}
