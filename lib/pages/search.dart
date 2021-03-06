import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/user.dart';
import '../widgets/progress.dart';
import 'home.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<QuerySnapshot> searchResultsFuture;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: buildSearchField(),
      body: searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }

  Widget buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          hintText: 'Search for a user...',
          filled: true,
          prefix: Container(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.account_box,
              color: Colors.grey,
              size: 28.0,
            ),
          ),
          suffix: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.grey,
            ),
            onPressed: () => textEditingController.clear(),
          ),
        ),
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  Widget buildNoContent() {
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/search.svg',
              height: orientation == Orientation.portrait ? 300 : 150,
            ),
            Text(
              'Find Users',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  void handleSearch(String query) {
    Future<QuerySnapshot> users = usersRef.where('displayName', isGreaterThanOrEqualTo: query).getDocuments();
    setState(() {
      searchResultsFuture = users;
    });
  }

  Widget buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<Widget> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          User user = User.fromDocument(doc);
          searchResults.add(Container(
            color: Colors.orange,
            padding: const EdgeInsets.all(8.0),
            child: Text(user.username),
          ));
        });
        print('Len ; ${searchResults.length}');
        return ListView(
          children: searchResults,
        );
      },
    );
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('User result'),
    );
  }
}
