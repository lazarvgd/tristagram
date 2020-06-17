import 'package:flutter/material.dart';
import 'package:tristagram/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String username;
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _autoValidate = false;
  bool canContinue = false;

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar: header(context, isAppTitle: false, title: 'Create account'),
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
                      child: TextFormField(
                        onSaved: (val) => username = val,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(fontSize: 15.0),
                            labelText: "Username",
                            hintText: "Must be at least 3 characters"),
                        autovalidate: _autoValidate,
                        validator: (val) {
                          if (val.length < 3) {
                            canContinue = false;
                            return "Username must be 3 characters long";
                          }
                          canContinue = true;
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
    setState(() {
      _autoValidate = true;
    });
    if (canContinue) {
      _formKey.currentState.save();
      Navigator.pop(context, username);
    }
  }
}
