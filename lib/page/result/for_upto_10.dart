
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:school/page/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school/page/common/searchpage.dart';

class ForUpto10 extends StatefulWidget {
  const ForUpto10({Key? key}) : super(key: key);

  @override
  State<ForUpto10> createState() => _ForUpto10State();
}

class _ForUpto10State extends State<ForUpto10> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Form'),
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
class MyCustomFormState  extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  String? studentName = 'StudentName';
  String? grade = 'Grade';
  String? studentId = null;

  final Map<String, dynamic> subjects = {
    'Biology': null,
    'Chemistry': null,
    'Physics': null,
    'Social_Studies': null,
    'English': null,
    'Civics': null,
    'Physical_Education': null,
    'Mathematics': null,
    'ICT': null,
    'Amharic':null,
    'out_of': null,
    'quarter': null,
  };
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "$studentName($grade)"??""
                  ),
                  ElevatedButton(onPressed: () async {
                    var student =   await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const SearchPage()));
                    studentId = student['childOne'];
                    setState(() {
                      studentName = student['fullName'];
                      grade = student['grade'];
                    });
                  }, child: Text("Search student")),
                ]
            ),
            SizedBox(height: 20),
            TextFormField(
                onSaved: (value) {
                  subjects['quarter'] = value;
                },
                decoration: const InputDecoration(
                  icon: const Icon(Icons.numbers),
                  hintText: 'Enter Quarter',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Quarter required';
                  }
                  return null;
                }
            ),

            TextFormField(
              onSaved: (value) {
                subjects['Biology'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Biology Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                subjects['Chemistry'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Chemistry Result',
              ),
              keyboardType: TextInputType.number,
            ),

            TextFormField(
              onSaved: (value) {
                subjects['Physics'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Physics Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                subjects['Social_Studies'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Social_Studies  Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                subjects['English'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'English Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                subjects['Civics'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Civics Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                subjects['Physical_Education'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Physical_Education Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                subjects['Mathematics'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Mathematics Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                subjects['ICT'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'ICT Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                subjects['Amharic'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Amharic Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                subjects['out_of'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'out of ',
              ),
              keyboardType: TextInputType.number,
            ),


            SizedBox(height: 12),




            Center(child: ElevatedButton(onPressed: () async {

              if (_formKey.currentState!.validate() && studentId != null) {
                _formKey.currentState!.save();
                var quarter = subjects['quarter'];
                subjects.remove('quarter');
                var out_of = subjects['out_of'];
                subjects.remove('out_of');
                for (var k in subjects.keys) {
                  subjects[k] = "${subjects[k]}/$out_of";
                }
                FirebaseFirestore.instance.collection('result').add({'subjects':subjects,'studentId':studentId,'quarter':quarter,'grade': grade ,'fullName': studentName}).then((snapshot) => {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Result submitted'), backgroundColor: Colors.green),
                  ),

                });
                _formKey.currentState?.reset();


                // db.collection('result').add({subjects: subjects, studentId: stdId, quarter: quarter, grade,fullName: selected_student_name})
                //     .then(snapshot => {
                // selected_student_name = null;
                // alert("result has been submited.")
                // })
                //
                // try {
                //
                //   FirebaseFirestore.instance.collection('result').add(formData)
                //       .then((doc) {
                //     FirebaseFirestore.instance.collection('teacher').doc(doc.id).update({'teacherId': doc.id});
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text('Registration successful'), backgroundColor: Colors.green),
                //     );
                //     Navigator.pop(context);
                //   }).onError((e, _) {print("Error while writing user: $e");});
                // } catch(e) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text('Registration Failed'), backgroundColor: Colors.red),
                //   );
                // }

              }
            }, child: Text('Submit Result')))
          ],
        ),
      ),
    );
  }
}
