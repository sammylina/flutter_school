import 'package:flutter/material.dart';
import 'package:school/page/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:convert';


class NavBar extends StatefulWidget {
  final usertype;

  const NavBar({Key? key, required this.usertype}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState(usertype);
}

class _NavBarState extends State<NavBar> {

  _NavBarState(this.usertype);
  var userName;
  var email;
  var usertype;
  @override
  void initState() {
    super.initState();
    print("usertype in current situation: $usertype");
    CustomAuth.storage.read(key: usertype).then((res) {
      var user = json.decode(res!);
      setState(() {
        userName = user['fullName'];
        email = user['email'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(accountName: Text("${userName}"),
            accountEmail: Text("${email}"),
            currentAccountPicture:CircleAvatar(
              child: ClipOval(
                child: Image.network("https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png",
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.cyan,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("img/12.jpg"),
              ),
            ),

          ),

          ListTile(
            leading: Icon(Icons.person),
            title: Text('Update info'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.password  ),
            title: Text('Change Password'),
            onTap: () {
              FirebaseAuth.instance.sendPasswordResetEmail(email: email)
                .then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("check your email to reset password"), backgroundColor: Colors.lightBlueAccent),
                );
                Navigator.pop(context);
              } );


            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Request'),
            onTap: () => null,
            trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20,
                height: 20,
                child: Center(
                  child: Text(
                    "8",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12
                    ),
                  ),
                ),
              ),
            ),
          ),

          Divider(),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
            onTap: ()  {
               FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
