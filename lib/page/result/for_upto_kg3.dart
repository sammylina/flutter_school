
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:school/page/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForUptoKg3 extends StatefulWidget {
  const ForUptoKg3({Key? key}) : super(key: key);

  @override
  State<ForUptoKg3> createState() => _ForUptoKg3State();
}

class _ForUptoKg3State extends State<ForUptoKg3> {
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
  final accountTypes = ['KG1', 'KG2', 'KG3', '1','2','3','4','5','6','7','8','9','10','11','12',];
  final Map<String, dynamic> formData = {
    'Amharic': null,
    'lastName': null,
    'email': null,
    'phone': null,
    'username': 'user name',
    'password': null,
    'userType': 'parent',
    'profile_img': null,
    'childOne': null,
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
              hint: Text('Select Student Grade'),
            ),

            TextFormField(
                onSaved: (value) {
                  formData['fullName'] = value;
                },
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Enter Student Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Student Name required';
                  }
                  return null;
                }
            ),
            TextFormField(
                onSaved: (value) {
                  formData['Quarter'] = value;
                },
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
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
                formData['Amharic'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Amharic Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                formData['English'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'English Result',
              ),
              keyboardType: TextInputType.number,
            ),

            TextFormField(
              onSaved: (value) {
                formData['Math Result'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Math Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                formData['Math Amharic'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Math Amharic Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                formData['Science Result'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Science Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                formData['Science Amharic'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Science Amharic Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                formData['Music'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Music Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                formData['Sports'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Sports Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                formData['Art'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Art Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                formData['out of'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'out of ',
              ),
              keyboardType: TextInputType.number,
            ),


            SizedBox(height: 12),




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
            }, child: Text('Submit Result')))
          ],
        ),
      ),
    );
  }
}
