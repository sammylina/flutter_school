import 'package:flutter/material.dart';
import 'package:school/page/common/admin_ann_post.dart';
import 'common/NavBar.dart';
import 'package:school/page/register/main_register.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _Admin_pageState createState() => _Admin_pageState();
}

class _Admin_pageState extends State<AdminPage> {
  bool isSearching = false;
  @override
  Widget build(BuildContext context) => DefaultTabController(

    length: 3,
    child: Scaffold(
      drawer: NavBar(usertype: 'admin'),
      appBar: AppBar(
        title: !isSearching ? Text("admin"): TextField(
          style: TextStyle(
              color: Colors.white
          ),
          decoration: InputDecoration(
            icon: Icon(Icons.search,
              color: Colors.white,),
            hintText: "inter search hear",
            hintStyle: TextStyle(
                color: Colors.white
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              this.isSearching = !this.isSearching;

            });
          }, icon: Icon(Icons.search))
        ],
        //centerTitle: true,

        bottom: TabBar(
          tabs: [
            Tab(text: "Register",icon: Icon(Icons.notifications),),
            Tab(text: "Announcement",icon: Icon(Icons.notifications)),
            Tab(text: "Delete",icon: Icon(Icons.notifications))
          ],
        ),
      ),
      body: TabBarView(
        children: [
          Center(child: Register()),
          Center(child: AdminAnnouncement(),),
          Center(child: Text("Result"),)
        ],
      ),
    ),


  );
}

// ------------------------Register(create account)------------------

// class Register extends StatefulWidget {
//
//     @override
//     _RegisterState createState() => _RegisterState();
// }
//
// class _RegisterState extends State<Register> {
//
//     final nameController = TextEditingController();
//     final phoneController = TextEditingController();
//     final accountTypes = ['Teacher', 'Parent', 'Student', 'Data Encoder'];
//     String? selectedAccount = 'Teacher';
//
//   @override
//   Widget build(BuildContext context) {
//     // Build a Form widget using the _formKey created above.
//     return Column(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: [
//             buildName(),
//             buildPhone(),
//             DropdownButton<String>(
//     items: accountTypes.map((String item) {
//         return DropdownMenuItem(
//             value: item,
//             child: Text(item),
//         );
//     }).toList(),
//     value: selectedAccount,
//     onChanged: (value) => setState(() => this.selectedAccount = value),
// ),
//             submitButton(),
//        ]
//    );
//
//   }
//
//   // -----------Input Widgets-------------
//
//   Widget buildName() => TextFormField(
//     controller: nameController,
//     decoration: InputDecoration(
//         labelText: 'Name',
//         border: OutlineInputBorder(),
//         prefixIcon: Icon(Icons.person),
//         suffixIcon: IconButton(
//             icon: Icon(Icons.close),
//             onPressed: () {
//                 nameController.clear();
//             }
//         ),
//     ),
//     validator: (value) {},
//     onChanged: (value) {}
//   );
//
//   Widget buildPhone() =>
//            TextField(
//                 controller: phoneController,
//                 decoration: InputDecoration(
//                     hintText: 'Enter phone number',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.phone),
//                 ),
//                 keyboardType: TextInputType.number,
//            );
//
//     Widget submitButton() => FlatButton(
//         child: Text('submit'),
//         onPressed: () {},
//     );
// }

