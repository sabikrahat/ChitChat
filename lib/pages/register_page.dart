import 'package:chitchat/pages/login_page.dart';
import 'package:chitchat/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isLoading = false;
  var _name;
  var _email;
  var _password;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        backgroundColor: Colors.indigo[50],
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.indigo[400]),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Register",
                style: TextStyle(
                  wordSpacing: 1.2,
                  letterSpacing: 1.0,
                  fontSize: 43.0,
                  fontFamily: "Signatra",
                  color: Colors.indigo[400],
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Card(
                  elevation: 12.0,
                  color: Colors.indigo[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.02),
                          Text(
                            "Register yourself First",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: size.height * 0.04),
                          Container(
                            padding: EdgeInsets.only(left: 6.0),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "What Should Everyone Call You?",
                              style: TextStyle(
                                color: Colors.indigo[400],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 3.0, bottom: 4.0, left: 5.0, right: 10.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.blueAccent,
                              style: TextStyle(color: Colors.black),
                              controller: nameController,
                              validator: (error) {
                                if (error.isEmpty) {
                                  return "Please enter your full name";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _name = value;
                                });
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[600]),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: "Name",
                                labelStyle:
                                    TextStyle(color: Colors.indigo[400]),
                                hintText: "Enter your full name...",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                                icon: Icon(
                                  Icons.person,
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
                          SizedBox(height: size.height * 0.02),
                          Container(
                            padding: EdgeInsets.only(left: 6.0),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Account Information",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.indigo[400],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 3.0, bottom: 4.0, left: 5.0, right: 10.0),
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
                                  borderSide:
                                      BorderSide(color: Colors.grey[600]),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: "Email",
                                labelStyle:
                                    TextStyle(color: Colors.indigo[400]),
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
                            padding: const EdgeInsets.only(
                                top: 4.0, bottom: 4.0, left: 5.0, right: 10.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.blueAccent,
                              style: TextStyle(color: Colors.black),
                              obscureText: _isObscure,
                              controller: passwordController,
                              validator: (error) {
                                if (error.isEmpty) {
                                  return "Please enter password";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _password = value;
                                });
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[600]),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: "Password",
                                labelStyle:
                                    TextStyle(color: Colors.indigo[400]),
                                hintText: "Enter password",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                                icon: Icon(
                                  Icons.lock,
                                  color: Colors.indigo[400],
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      _isObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey[600]),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
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
                          SizedBox(height: size.height * 0.02),
                          SizedBox(
                            height: 42.0,
                            width: double.infinity,
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.indigo[400],
                              onPressed: () {
                                setState(
                                  () {
                                    if (_formKey.currentState.validate()) {
                                      _isLoading = true;
                                      _signUpWithEmailAndPassword();
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Already have an Account ? ",
                                style: TextStyle(
                                  color: Colors.indigo[400],
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.indigo[400],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Log in",
                                  style: TextStyle(
                                    color: Colors.indigo[400],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.03),
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: _isLoading ? linearProgress() : Text(""),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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

  Future<void> _signUpWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      print("Sign Up Success");
      await _saveUserInfoToFirebaseFirestore().then((_) async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
          ModalRoute.withName('/'),
        );
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        _showSnackbar("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        _showSnackbar("The account already exists for that email.");
      }
    } catch (e) {
      print(e.toString());
      _showSnackbar(e.toString);
    }
  }

  Future<void> _saveUserInfoToFirebaseFirestore() async {
    User user = FirebaseAuth.instance.currentUser;
    user.updateProfile(displayName: _name);

    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "uid": user.uid,
      "profileName": _name,
      "username": user.email.split('@')[0],
      "photoUrl":
          "https://firebasestorage.googleapis.com/v0/b/chitchat-flutter-sabikrahat.appspot.com/o/default_user_image.png?alt=media&token=47ffceb6-fc79-415b-b65a-8b07a7fa8739",
      "email": user.email,
      "intro": "",
      "location": "",
      "timeStamp": DateTime.now(),
      "type": "firebaseLogin",
      "status": "offline",
      "tokenId": "",
      "totalPost": 0,
      "totalStar": 0,
      "totalPoint": 0,
      "tags": ['welcome'],
    });
    setState(() {
      _isLoading = false;
    });
    _showSnackbar("Registration Completed. Log in now.");
    await FirebaseAuth.instance.signOut();
  }
}
