import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tristagram/models/user.dart';
import 'package:tristagram/pages/activity_feed.dart';
import 'package:tristagram/pages/create_account.dart';
import 'package:tristagram/pages/profile.dart';
import 'package:tristagram/pages/search.dart';
import 'package:tristagram/pages/upload.dart';

import '../models/user.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = Firestore.instance.collection('users');

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;
  User currentUser;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: pageIndex,
    );
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      handleSignIn(account);
    }, onError: (error) {
      debugPrint('Error Signing in :${error}');
      setState(() {
        isAuth = false;
      });
    });
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    });
  }

  void handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }

  Widget buildAuthScreen() {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.photo_camera,
            size: 35.0,
          )),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.person_pin)),
        ],
      ),
      body: PageView(
        onPageChanged: onPageChanged,
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
//          Timeline(),
          RaisedButton(
            child: Text('Logout'),
            onPressed: logout,
          ),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile(),
        ],
      ),
    );
  }

  Widget buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Tristagram',
                style: TextStyle(fontFamily: 'Signatra', fontSize: 70.0, color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260,
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google_signin_button.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void login() async {
    await googleSignIn.signIn();
  }

  void logout() {
    googleSignIn.signOut();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int value) {
    setState(() {
      pageIndex = value;
    });
  }

  void onTap(int nextPage) {
    pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void createUserInFirestore() async {
    // check if user exists in users collection in db
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();
    final timestamp = DateTime.now();

    if (!doc.exists) {
      // if user does not exists then take them to create account page
      String username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));
      // get username from create acc use it to make new user document in users collection

      usersRef.document(user.id).setData({
        'id': user.id,
        'username': username,
        'photoUrl': user.photoUrl,
        'email': user.email,
        'displayName': user.displayName,
        'bio': '',
        'timestamp': timestamp,
      });
      doc = await usersRef.document(user.id).get();
    }
    currentUser = User.fromDocument(doc);
    print(currentUser);
    print(currentUser.username);
  }
}
