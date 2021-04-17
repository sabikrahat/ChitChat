import 'package:chitchat/pages/home_page.dart';
import 'package:chitchat/pages/welcome_page.dart';
import 'package:chitchat/widgets/ProgressWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();

  var _email;
  bool _isLoading = false;

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 4.0, left: 7.0, right: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.blueAccent,
                  style: TextStyle(color: Colors.black),
                  controller: emailController,
                  validator: (error) {
                    if (error.isEmpty) {
                      return "Please enter email address";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[600]),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.indigo[400]),
                    hintText: "Enter email address",
                    hintStyle: TextStyle(color: Colors.grey[700]),
                    icon: Icon(
                      Icons.email_outlined,
                      color: Colors.indigo[400],
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 15.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 42.0,
                  width: double.infinity,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    color: Colors.indigo[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      "Send Verification Mail",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    onPressed: () {
                      setState(
                        () {
                          if (_formKey.currentState.validate()) {
                            _isLoading = true;
                            _resetPassword();
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              _isLoading ? linearProgress() : Text(""),
            ],
          ),
        ),
      ),
    );
  }

  _showSnackbar(message) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {
          // ignore: deprecated_member_use
          _scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
    );
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<void> _signOut() async {
    usersReference
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
          "status": "offline",
        })
        .then((value) => print("User Offline Updated"))
        .catchError((error) => print("Failed to update user: $error"));
    try {
      await FirebaseAuth.instance.signOut().then((_) {
        print("Sign Out Success");
        _showSnackbar("Sign out");
      });
    } catch (e) {
      print(e.toString());
      _showSnackbar(e.toString);
    }
  }

  Future<void> _resetPassword() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _email).then((_) {
      print("Check your Email to reset password");
      _showSnackbar("Check your Email to reset password");

      if (FirebaseAuth.instance.currentUser != null) {
        _signOut();
      }
      setState(() {
        _isLoading = true;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePage(),
        ),
        ModalRoute.withName('/'),
      );
    });
  }
}
