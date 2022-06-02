import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


class Login extends StatefulWidget {
		const Login({Key? key}) : super(key: key);
    @override
    _LoginState createState() => _LoginState(); 
}

class _LoginState extends State<Login> {

		final email_controller = TextEditingController();
		final password_controller = TextEditingController();


		late FocusNode focus;
		

		static Future<User?> login({required String email, required String password, required BuildContext context}) async {
			User? user;
			
			FirebaseAuth auth = FirebaseAuth.instance;
			try {
				UserCredential cred = await auth.signInWithEmailAndPassword(
					email: email,
					password: password,
				);	
				user = cred.user;
			} on FirebaseAuthException catch(e) {
				if (e.code == 'user-not-found') {
					print("No user found ");	
				}	else if (e.code == 'wrong-password') {
					print('Wrong password provided');	
				}
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
			return Container(
				padding: EdgeInsets.all(40.0),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						Text('Welcome to Login page'),

						// Email Login
						TextField(
							controller: email_controller,
							decoration: InputDecoration(
								labelText: 'Email',	
								prefixIcon: Icon(Icons.email),
							),
							onSubmitted: (userinput) {
								focus.requestFocus();
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
						SizedBox(height: 20),

						// Login Button
						FlatButton(
							padding: EdgeInsets.symmetric(vertical: 10),
							shape: RoundedRectangleBorder(
								borderRadius: BorderRadius.circular(6.0),	
							),
							child: Text(
								'click me',
								style: TextStyle(
									color: Colors.white,	
								),
							),
							color: Theme.of(context).primaryColor,
							onPressed: () async {
								User? user = await login(email: email_controller.text, password: password_controller.text, context: context);
								if (user == null) {
								
								} else {
								
								}

								print("user: $user");
							},	
						),
					]
				),
			); 
    }
}
