import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school/model/search_child_model.dart';
import 'dart:math';
import 'package:school/page/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:school/page/register/DataController.dart';
import 'package:get/get.dart';


class RegisterParent extends StatefulWidget {
  const RegisterParent({Key? key}) : super(key: key);

  @override
  _RegisterParentState createState() => _RegisterParentState();
}

class _RegisterParentState extends State<RegisterParent> {

  final TextEditingController searchController = TextEditingController();
  var snapshotData;
  bool isExecuted = false;

  @override
  Widget build(BuildContext context) {

    Widget SearchedData() {
      return ListView.builder(
        itemCount: snapshotData.docs.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(snapshotData.docs[index].data()['fullName']),
            subtitle: Text(snapshotData.docs[index].data()['studentId']),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: TextStyle(),
          decoration: InputDecoration(),
          controller: searchController,
        ),
        actions: [
          GetBuilder<DataController>(
            init: DataController(),
            builder: (val) {
              return IconButton(icon: Icon(Icons.search), onPressed: () {
                val.queryData(searchController.text).then((value) {
                    snapshotData = value;
                    setState(() {
                      isExecuted = true;
                    });
                });
              });
            },
          )
        ],
      ),
      body:  Column(
          children: [
            isExecuted ? SearchedData() : Container(
              child: Text('search any course')
            ),
            Expanded(child: SingleChildScrollView(
              child: ParentForm(),
            ))

          ],
        ),
     );
  }
}

class ParentForm extends StatefulWidget {
  const ParentForm({Key? key}) : super(key: key);

  @override
  _ParentFormState createState() => _ParentFormState();
}

class _ParentFormState extends State<ParentForm> {

  final _formKey = GlobalKey<FormState>();
  final _chars = 'ABCDEFGHIJKLMNOPRSTUVWXYZabcedfghijklmnopqrstuvwxyz!@123456789';
  Random rand = Random();
  String? studentName = '';
  final Map<String, dynamic> parentData = {
    'firstName': null,
    'lastName': null,
    'fullName': null,
    'email': null,
    'phone': null,
    'username': 'user name',
    'grade': null,
    'password': null,
    'userType': 'teacher',
    'profile_img': null,
    'teacherId': null,
    'childOne': null,
  };
  var students = ['one', 'two', 'three'];
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            TextFormField(
                onChanged: (value) {
                  parentData['firstName'] = value;
                },
                onSaved: (value) {
                  parentData['firstName'] = value;
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
                  parentData['lastName'] = value;
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
                parentData['phone'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.phone),
                hintText: 'Enter a phone number',
              ),
              keyboardType: TextInputType.number,
            ),

            TextFormField(
              onSaved: (value) {
                parentData['email'] = value;
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
                    parentData['username']
                ),
                ElevatedButton(
                  child: Text("Generate Username"),
                  onPressed: () {
                    var rand = Random();
                    var rand_num = rand.nextInt(900) + 100;
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        parentData['username'] = "${parentData['firstName']}$rand_num";
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
                Text(parentData['password']??'password'),
                ElevatedButton(
                  child: Text("Generate Password"),
                  onPressed: () {
                    final password = String.fromCharCodes(Iterable.generate(6, (_) => _chars.codeUnitAt(rand.nextInt(_chars.length))));
                    setState(() {
                      parentData['password'] = password;
                    });
                  },
                ),

              ],
            ),
            SizedBox(height: 20),
            Center(child: ElevatedButton(onPressed: () async {
              if (parentData['password'] == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('first generate password'),
                      backgroundColor: Colors.redAccent,
                    )
                );
              }
              else if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                User? user = await FireAuth.registerUsingEmailPassword(email: parentData['email'], password: parentData['password']);
                parentData['fullName'] = "${parentData['firstName']} ${parentData['lastName']}";
                try {

                  FirebaseFirestore.instance.collection('parent').add(parentData)
                      .then((doc) {
                    FirebaseFirestore.instance.collection('parent').doc(doc.id).update({'teacherId': doc.id});
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

