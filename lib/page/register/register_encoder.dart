import 'package:flutter/material.dart';
import 'package:school/page/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterEncoder extends StatefulWidget {
  const RegisterEncoder({Key? key}) : super(key: key);

  @override
  _RegisterEncoderState createState() => _RegisterEncoderState();
}

class _RegisterEncoderState extends State<RegisterEncoder> {

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {
    'firstName': null,
    'lastName': null,
    'email': null,
    'phone': null,
    'username': 'user name',
    'password': null,
    'userType': 'dataEncoder',
    'profile_img': null,
  };
  @override
  Widget build(BuildContext context) {


    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Data Encoder'),
      ),
      body: SingleChildScrollView(
        child: Form(
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
                TextFormField(
                  onSaved: (value) {
                    formData['email'] = value;
                  },
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.email),
                    hintText: 'Enter your email',
                  ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'email required';
                      }
                      return null;
                    }
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
                        final password = CustomAuth().generate_password();
                        print('password generated: $password');
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
                    print("------encoder------: $formData");
                    User? user = await FireAuth.registerUsingEmailPassword(email: formData['email'], password: formData['password']);
                    formData['fullName'] = "${formData['firstName']} ${formData['lastName']}";
                    try {

                      FirebaseFirestore.instance.collection('encoder').add(formData)
                          .then((doc) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registration successful'), backgroundColor: Colors.green),
                        );
                        Navigator.pop(context);
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
                }, child: Text('Register')))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
