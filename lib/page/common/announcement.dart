import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Announcement extends StatefulWidget {
  const Announcement({Key? key}) : super(key: key);

  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {

  List<Object> _annList = [];

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

  @override
  Widget build(BuildContext context) {
    print("in the build");
    return Scaffold(
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
