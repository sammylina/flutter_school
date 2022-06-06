

import 'package:flutter/material.dart';



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
              ElevatedButton(onPressed: () {}, child: Text('For grade kg1 upto kg3')),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () {}, child: Text('For grade 1 upto 6')),
              const SizedBox(height: 8),
               ElevatedButton(onPressed: () {}, child: Text('For grade 7 upto 10')),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () {}, child: Text('For grade 11 and 12 natural science')),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () {}, child: Text('For grade 11 and 12 social science')),

            ]
        )
    );
  }
}