import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tristagram/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String username;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, isAppTitle: false, title: 'Create account', removeBackButton: true),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      'Create a username',
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: TextFormField(
                        onSaved: (val) => username = val,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(fontSize: 15.0),
                            labelText: "Username",
                            hintText: "Must be at least 3 characters"),
                        validator: (val) {
                          if (val.trim().isEmpty || val.trim().length < 3) {
                            return 'username is too short';
                          } else if (val.trim().length > 12) {
                            return 'username is too long';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      SnackBar snackBar = SnackBar(
        content: Text('Welcome ${username}!'),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 3), () {
        Navigator.pop(context, username);
      });
      _formKey.currentState.save();
    }
  }
}
