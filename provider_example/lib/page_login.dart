import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_form_demo_v2.dart';
import 'state_simple.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController =
      TextEditingController(text: 'your_email@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'input password');

  void _onLogin(BuildContext context) {
    final String email = _emailController.text;
    final SimpleState state = Provider.of<SimpleState>(context, listen: false);
    state.setEmail(email);

    Navigator.pushNamed(context, MAIN_PAGE);
  }

  void _onCancle() => exit(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 120, 20, 120),
        child: Column(
          children: <Widget>[
            Hero(
              tag: 'hero',
              child: CircleAvatar(
                child: Image.asset('asset/logo.png'),
                backgroundColor: Colors.black,
                radius: 58.0,
              ),
            ),
            SizedBox(
              height: 45.0,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              controller: _emailController,
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              controller: _passwordController,
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('log in'),
                  onPressed: () => _onLogin(context),
                ),
                SizedBox(
                  width: 10.0,
                ),
                RaisedButton(
                  child: Text('cancel'),
                  onPressed: () => _onCancle(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
