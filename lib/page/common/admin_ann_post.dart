import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class AdminAnnouncement extends StatefulWidget {
  const AdminAnnouncement({Key? key}) : super(key: key);

  @override
  _AdminAnnouncementState createState() => _AdminAnnouncementState();
}

class _AdminAnnouncementState extends State<AdminAnnouncement> {

  List<Object> _annList = [];
  late TextEditingController titleCtl = TextEditingController();
  late TextEditingController contentCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAnnouncement();
  }
  Future getAnnouncement() async {
    var ann = await FirebaseFirestore
        .instance
        .collection('announcements')
        .get();
    setState(() {
      _annList = List.from(ann.docs.map((doc) => Announce.fromSnapshot(doc)));
      print("fetched data: $_annList");
    });
  }

  Future openDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("New Announcement"),
      content: Column(
        children: [
          TextField(
            autofocus: true,
            controller: titleCtl,
            decoration: InputDecoration(
              hintText: 'Title',
            ),
          ),
          TextField(
            controller: contentCtl,
            decoration: InputDecoration(
                hintText: 'Type your Announcement here '
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(onPressed: () {
          Navigator.of(context).pop();
          print("title: ${titleCtl.text} content: ${contentCtl.text}");
          FirebaseFirestore.instance.collection('announcements').add({
            'title': titleCtl.text,
            'content': contentCtl.text,
            'date': "${DateFormat('mm/dd/yyyy').format(DateTime.now())}",
          }).then((snapshot) {
            getAnnouncement();
          });

        }, child: Text("Post")),
      ],
    )
  );

  @override
  Widget build(BuildContext context) {
    print("in the build");
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          openDialog();
        },
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _annList.length,
          itemBuilder: (context, index) {
            return AnnList(_annList[index] as Announce);
          },
        ),
      ),
    );

  }
}

class Announce {
  String? title;
  String? date;
  String? content;
  Announce();

  Map<String, dynamic> toJson() => {'title': title, 'content': content, 'date': date};
  Announce.fromSnapshot(snapshot)
      : title = snapshot.data()['title'],
        content = snapshot.data()['content'],
        date = snapshot.data()['date'];
}

class AnnList extends StatelessWidget {
  final Announce _ann;
  AnnList(this._ann);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('${_ann.title}', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    )),
                    Spacer(),
                    Text(
                      '${_ann.date}',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text('${_ann.content}')
                    ),
                  ],
                ),
                Row(),
              ],
            ),
          ),
        )
    );
  }
}
