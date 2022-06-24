

import 'package:flutter/material.dart';
import 'package:school/page/result/for_upto_10.dart';
import 'package:school/page/result/for_upto_6.dart';
import 'package:school/page/result/natural_science.dart';
import 'package:school/page/result/resultForTeacher.dart';

import 'package:school/page/result/social_science.dart';

import 'for_upto_kg3.dart';



class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ForUptoKg3()));
              }, child: Text('For grade kg1 upto kg3')),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ForUpto6()));
              }, child: Text('For grade 1 upto 6')),
              const SizedBox(height: 8),
               ElevatedButton(onPressed: () {
                 Navigator.push(context,
                     MaterialPageRoute(builder: (context) => const ForUpto10()));
               }, child: Text('For grade 7 upto 10')),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const NaturalScience()));
              }, child: Text('For grade 11 and 12 natural science')),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SocialScience()));
              }, child: Text('For grade 11 and 12 social science')),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const TeacherResult()));
              }, child: Text('see Result')),
            ]
        )
    );
  }
}