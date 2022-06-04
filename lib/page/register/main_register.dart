import 'package:flutter/material.dart';
import 'package:school/page/register/register_teacher.dart';
import 'package:school/page/register/register_encoder.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterTeacher())
            );
          }, child: const Text('Register Teacher')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () {}, child: Text('Register Parent')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterEncoder())
            );
          },
          child: Text('Register DataEncoder'))
        ]
      )
    );
  }
}
