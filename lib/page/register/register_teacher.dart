import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:school/page/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterTeacher extends StatefulWidget {
  const RegisterTeacher({Key? key}) : super(key: key);

  @override
  _RegisterTeacherState createState() => _RegisterTeacherState();
}

class _RegisterTeacherState extends State<RegisterTeacher> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Registration'),
      ),
      body: SingleChildScrollView(
        child: MyCustomForm(),
      ),
    );
  }

}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final accountTypes = ['KG1', 'KG2', 'KG3', '1','2','3','4','5','6','7','8','9','10','11','12',];
  final _chars = 'ABCDEFGHIJKLMNOPRSTUVWXYZabcedfghijklmnopqrstuvwxyz!@123456789';
  Random rand = Random();
  final Map<String, dynamic> formData = {
    'firstName': null,
    'lastName': null,
    'email': null,
    'phone': null,
    'username': 'user name',
    'grade': null,
    'password': null,
    'userType': 'teacher',
    'profile_img': null,
    'teacherId': null,
  };

  @override
  Widget build(BuildContext context) {


    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              onChanged: (value) {
                formData['firstName'] = value;
              },
              onSaved: (value) {
                formData['firstName'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Enter first name',
              ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'first name required';
                  }
                  return null;
                }
            ),
            TextFormField(
              onSaved: (value) {
                formData['lastName'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Enter middle name',
              ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'middle name required';
                  }
                  return null;
                }
            ),
            TextFormField(
              onSaved: (value) {
                formData['phone'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.phone),
                hintText: 'Enter a phone number',
              ),
              keyboardType: TextInputType.number,
            ),
            DropdownButton(
              icon: Padding(
                padding: EdgeInsets.only(left: 20),
              child: Icon(Icons.arrow_circle_down_sharp)
            ),
              items: accountTypes.map((String item) {
        return DropdownMenuItem(
            value: item,
            child: Text(item),
                 );
                }).toList(),
              onChanged: (value) {
                setState(() {
                  formData['grade'] = value;
                });
              },
              value: formData['grade'],
              hint: Text('Grade'),
             ),
            TextFormField(
              onSaved: (value) {
                formData['email'] = value;
              },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'email required';
                  }
                  return null;
                },
              decoration: const InputDecoration(
                icon: const Icon(Icons.email),
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formData['username']
                ),
                ElevatedButton(
                  child: Text("Generate Username"),
                  onPressed: () {
                    var rand = Random();
                    var rand_num = rand.nextInt(900) + 100;
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        formData['username'] = "${formData['firstName']}$rand_num";
                      });
                    }
                  },
                ),

              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formData['password']??'password'),
                ElevatedButton(
                  child: Text("Generate Password"),
                  onPressed: () {
                    final password = String.fromCharCodes(Iterable.generate(6, (_) => _chars.codeUnitAt(rand.nextInt(_chars.length))));
                    setState(() {
                      formData['password'] = password;
                    });
                  },
                ),

              ],
            ),
            SizedBox(height: 20),
            Center(child: ElevatedButton(onPressed: () async {
              if (formData['password'] == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('first generate password'),
                      backgroundColor: Colors.redAccent,
                  )
                );
              }
              else if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                User? user = await FireAuth.registerUsingEmailPassword(email: formData['email'], password: formData['password']);
                formData['fullName'] = "${formData['firstName']} ${formData['lastName']}";
                try {

                  FirebaseFirestore.instance.collection('teacher').add(formData)
                      .then((doc) {
                        FirebaseFirestore.instance.collection('teacher').doc(doc.id).update({'teacherId': doc.id});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration successful'), backgroundColor: Colors.green),
                    );
                    Navigator.pop(context);
                  }).onError((e, _) {print("Error while writing user: $e");});
                } catch(e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registration Failed'), backgroundColor: Colors.red),
                  );
                }

              }
            }, child: Text('Register')))
          ],
        ),
      ),
    );
  }
}


