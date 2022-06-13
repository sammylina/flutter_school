import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:school/page/auth.dart';
import 'dart:convert';


class Login extends StatefulWidget {
		const Login({Key? key}) : super(key: key);
    @override
    _LoginState createState() => _LoginState(); 
}

class _LoginState extends State<Login> {

		final email_controller = TextEditingController();
		final password_controller = TextEditingController();
		List<String> userTypes = ['teacher','encoder', 'parent','admin'];
		String selectedUserType = 'admin';
		bool allowLogin = false;

		late FocusNode focus;
		

		 Future<User?> login({required String email, required String password, required BuildContext context, routeTo}) async {
			User? user;
			
			FirebaseAuth auth = FirebaseAuth.instance;
			try {
				UserCredential cred = await auth.signInWithEmailAndPassword(
					email: email,
					password: password,
				);
				user = cred.user;
				if (user != null) {
					print("route to value: $routeTo");
					print("user found: $user");
					var loggedUser;
					FirebaseFirestore.instance.collection(selectedUserType).where('email', isEqualTo: user.email).snapshots()
						.forEach((user) {
							if(user == null) return;
							loggedUser = user.docs.map((e) => e.data()).toList()[0];
							CustomAuth.storage.write(key: selectedUserType, value: json.encode(loggedUser));

					});


					Navigator.pushNamed(context, "/$routeTo");
				}else {
						ScaffoldMessenger.of(context).showSnackBar(
							SnackBar(content: Text("User doesn't exist"), backgroundColor: Colors.yellowAccent),
						);
				}
			} on FirebaseAuthException catch(e) {
				if (e.code == 'user-not-found') {
					print("No user found ");	
				}	else if (e.code == 'wrong-password') {
					print('Wrong password provided');	
				}
				ScaffoldMessenger.of(context).showSnackBar(
						const SnackBar(
							content: Text("Wrong credentials"),
							backgroundColor: Colors.redAccent,
						)
				);
			}
			
			return user;
		
		}


		@override
		void initState() {
			super.initState();
			focus = FocusNode();
		}

		@override
		void dispose() {
			email_controller.dispose();
			password_controller.dispose();

			focus.dispose();

			super.dispose();
		}

    
    @override
    Widget build(BuildContext context) {
			return SingleChildScrollView(
				padding: EdgeInsets.symmetric(vertical: 50),
			  child: Container(
					alignment: Alignment.center,
			  	padding: EdgeInsets.all(40.0),
			  	child: Column(
			  		mainAxisAlignment: MainAxisAlignment.center,
			  		children: [
			  			Center(
			  			  child: Text('Welcome to Bethel Mekaneyesus School', style: TextStyle(
			  			  	fontWeight: FontWeight.bold,
			  			  	fontSize: 24,
			  					letterSpacing: 2,
			  			  ),
			  					textAlign: TextAlign.center,
			  				),
			  			),
			  			SizedBox(height: 20),
			  			DropdownButton(
			  				value: selectedUserType,
			  				icon: const Icon(Icons.keyboard_arrow_down),
			  				items: userTypes.map((String types) {
			  					return DropdownMenuItem(
			  						value: types,
			  						child: Text(types),
			  					);
			  				}).toList(),
			  				onChanged: (String? newValue) async {
			  					setState(() {
			  						selectedUserType = newValue!;
			  					});
			  					CollectionReference users = FirebaseFirestore.instance.collection(selectedUserType);
			  					QuerySnapshot allresults = await users.get();
			  					var emails = allresults.docs.map((DocumentSnapshot res) => res['email']);
			  					if (emails.contains(email_controller.text)) {
			  						this.allowLogin = true;
			  					}
			  					else {
			  						ScaffoldMessenger.of(context).showSnackBar(
			  							SnackBar(content: Text('user is not ${selectedUserType}'), backgroundColor: Colors.redAccent),
			  						);
			  						print("user not found: $emails");
			  						this.allowLogin = false;
			  					}
			  				},
			  			),
			  			// Email Login
			  			TextField(
			  				controller: email_controller,
			  				autofocus: true,
			  				decoration: InputDecoration(
			  					labelText: 'Email',	
			  					prefixIcon: Icon(Icons.email),
			  				),
			  				onSubmitted: (userinput) async{
			  					focus.requestFocus();

			  					print("selected user type: $selectedUserType");
			  					CollectionReference users = FirebaseFirestore.instance.collection(selectedUserType);
			  					QuerySnapshot allresults = await users.get();
			  					var emails = allresults.docs.map((DocumentSnapshot res) => res['email']);
			  					if (emails.contains(email_controller.text)) {
			  						this.allowLogin = true;
			  					}
			  					else {
			  						ScaffoldMessenger.of(context).showSnackBar(
			  							SnackBar(content: Text('user is not ${selectedUserType}'), backgroundColor: Colors.redAccent),
			  						);
			  						print("user not found: $emails");
			  						this.allowLogin = false;
			  					}
			  				},
			  			),
			  			SizedBox(height: 40),

			  			// Password Login
			  			TextField(
			  				focusNode: focus,
			  				obscureText: true,
			  				decoration: InputDecoration(
			  					labelText: 'Password',	
			  					prefixIcon: Icon(Icons.lock),
			  				),	
			  				controller: password_controller,
			  			),
			  			SizedBox(height: 40),

			  			// Login Button
			  			FlatButton(
								minWidth: double.infinity,
			  				padding: EdgeInsets.symmetric(vertical: 10),
			  				shape: RoundedRectangleBorder(
			  					borderRadius: BorderRadius.circular(6.0),	
			  				),
			  				child: Text(
			  					'Login',
			  					style: TextStyle(
			  						color: Colors.white,	
			  					),
			  				),
			  				color: Theme.of(context).primaryColor,
			  				onPressed: () async {
			  					if ( this.allowLogin && selectedUserType != null) {
			  						login(email: email_controller.text,
			  								password: password_controller.text,
			  								context: context,
			  								routeTo: selectedUserType);
			  					} else {
			  						ScaffoldMessenger.of(context).showSnackBar(
			  							SnackBar(content: Text('user is not ${selectedUserType}'), backgroundColor: Colors.redAccent),
			  						);
			  						print("please selecte user: $selectedUserType");
			  					}
			  				},	
			  			),
			  		]
			  	),
			  ),
			); 
    }


}
