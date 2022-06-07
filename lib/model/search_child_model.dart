import 'package:cloud_firestore/cloud_firestore.dart';

class SearchChildModel {
  final String? id;
  final String? firstName;

  SearchChildModel({
    this.id,
    this.firstName,});

  List<SearchChildModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap = snapshot.data as Map<String, dynamic>;
      return SearchChildModel(id: dataMap['id'], firstName: dataMap['firstName']);
    }).toList();
  }
}