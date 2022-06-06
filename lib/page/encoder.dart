import 'package:flutter/material.dart';
import 'common/NavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Encoder extends StatefulWidget {
  const Encoder({Key? key}) : super(key: key);

  @override
  _EncoderState createState() => _EncoderState();
}

class _EncoderState extends State<Encoder> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
            title: Text("Data Encoder"),
            bottom: TabBar(
             tabs: [
              Tab(text: "Register",icon: Icon(Icons.notifications),), Tab(text: "Annaounce",icon: Icon(Icons.notifications)),
             ],
            ),
        ),

          //centerTitle: true,



        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
          child: TabBarView(
            children: [
              Center(child: RegisterStudent(),),
              Center(child: Text("Post"),)
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterStudent extends StatefulWidget {
  const RegisterStudent({Key? key}) : super(key: key);

  @override
  _RegisterStudentState createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {

  final _formKey = GlobalKey<FormState>();
  final accountTypes = ['KG1', 'KG2', 'KG3', '1','2','3','4','5','6','7','8','9','10','11','12',];
  final gender = ['Male', 'Female'];
  final Map<String, dynamic> formData = {
    'fullName': null,
    'grade': null,
    'gender': null,
    'studentId': '',
    'parentId': '',
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                    onChanged: (value) {
                      formData['fullName'] = value;
                    },
                    onSaved: (value) {
                      formData['fullName'] = value;
                    },
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter full name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'full name required';
                      }
                      return null;
                    }
                ),
                SizedBox(height: 30),
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
                SizedBox(height: 20),
                DropdownButton(
                  icon: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(Icons.arrow_circle_down_sharp)
                  ),
                  items: gender.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      formData['gender'] = value;
                    });
                  },
                  value: formData['gender'],
                  hint: Text('Gender'),
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    print("form data value: $formData");
                    try {

                      FirebaseFirestore.instance.collection('student').add(formData)
                          .then((doc) {
                        FirebaseFirestore.instance.collection('student').doc(doc.id).update({'studentId': doc.id});
                        print("student registerd id: $doc.id");
                        setState(() {
                          formData['fullName'] = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registration successful'), backgroundColor: Colors.green),
                        );

                      }).onError((e, _) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registration Failed'), backgroundColor: Colors.red),
                        );
                      });
                    } catch(e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registration Failed'), backgroundColor: Colors.red),
                      );
                    }

                  }
                }, child: Text('Register Student'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

