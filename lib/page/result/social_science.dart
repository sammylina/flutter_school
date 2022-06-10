import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:school/page/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SocialScience extends StatefulWidget {
  const SocialScience({Key? key}) : super(key: key);

  @override
  State<SocialScience> createState() => _SocialScienceState();
}

class _SocialScienceState extends State<SocialScience> {
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
                formData['Geography'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Geography Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                formData['History'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'History Result',
              ),
              keyboardType: TextInputType.number,
            ),

            TextFormField(
              onSaved: (value) {
                formData['Economics'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Economics Result',
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
                formData['Civics'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Civics Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                formData['Business'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'General Business Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                formData['Physical Education'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Physical Education Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                formData['Mathematics'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'Mathematics Result',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              onSaved: (value) {
                formData['ICT'] = value;
              },
              decoration: const InputDecoration(
                icon: const Icon(Icons.school),
                hintText: 'ICT Result',
              ),
              keyboardType: TextInputType.number,
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