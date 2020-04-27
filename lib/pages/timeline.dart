import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tristagram/widgets/header.dart';
import 'package:tristagram/widgets/progress.dart';

final Firestore firestore = Firestore.instance;
final usersRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
//    getUserById();
    _getUsers();
//    updateUser();
//    createUser();
//  deleteUser();
  }

  void _getUsers() async {
    final QuerySnapshot snapshot = await usersRef.getDocuments();
//    snapshot.documents.forEach((DocumentSnapshot doc) {
//      print(doc.data);
//    });

    setState(() {
      users = snapshot.documents;
    });
  }

  getUserById() async {
    String janeId = 'Bo3DtViFo3oUTOatI1wT';
    usersRef.document(janeId).get().then((DocumentSnapshot doc) {
      debugPrint('${doc.data}');
      debugPrint('${doc.documentID}');
      debugPrint('${doc.exists}');
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: circularProgress(),
    );
  }

  createUser() {
     usersRef.document('asdas').setData({
      'username':'stevo',
      'isAdmin':false,
      'postCounts' : 0,
    });
  }

  updateUser() {
    usersRef.document('asdas').updateData({
      'username':'John',
      'isAdmin':false,
      'postCounts' : 0,
    });
  }

  deleteUser() async {

    final DocumentSnapshot doc = await usersRef.document('asdas').get();
     if(doc.exists) {
       doc.reference.delete();
     }
  }
}
