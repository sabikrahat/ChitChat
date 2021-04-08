import 'package:chitchat/pages/home_page.dart';
import 'package:chitchat/pages/register_page.dart';
import 'package:chitchat/widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isLoading = false;
  var _email;
  var _password;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                "Welcome Back!",
                style: TextStyle(
                  wordSpacing: 1.2,
                  letterSpacing: 1.0,
                  fontSize: 43.0,
                  fontFamily: "Signatra",
                  color: Colors.indigo[400],
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                "I'm so excited to see you again!",
                style: TextStyle(
                  fontFamily: "Signatra",
                  fontSize: 16.0,
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
                            "Login yourself to Stay Connected",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, bottom: 4.0, left: 5.0, right: 10.0),
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
                                top: 4.0, bottom: 5.0, left: 5.0, right: 10.0),
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
                          Container(
                            padding: EdgeInsets.only(right: 6.0),
                            alignment: Alignment.topRight,
                            child: InkWell(
                              splashColor: Colors.indigo[400],
                              onTap: () {},
                              child: Text(
                                "Forget Password ?",
                                style: TextStyle(
                                  color: Colors.indigo[400],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.015),
                          SizedBox(
                            height: 42.0,
                            width: double.infinity,
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                "Login",
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
                                      _signInWithEmailAndPassword();
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
                                "Don't have an Account ? ",
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
                                      builder: (context) => RegisterPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Register Now",
                                  style: TextStyle(
                                    color: Colors.indigo[400],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: size.height * 0.01),
                            width: size.width * 0.8,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Divider(
                                    color: Colors.indigo[900],
                                    height: 1.5,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    "OR",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.indigo[400],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.indigo[900],
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // ignore: deprecated_member_use
                          OutlineButton(
                            splashColor: Colors.indigo[400],
                            onPressed: () {
                              setState(
                                () {
                                  _isLoading = true;
                                  _signInWithGoogle();
                                },
                              );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            highlightElevation: 0,
                            borderSide: BorderSide(color: Colors.indigo[400]),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/images/google-logo.png",
                                    height: 18.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                        color: Colors.indigo[400],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
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

  Future<void> _signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      print("Sign In Success");
      setState(() {
        _isLoading = false;
        emailController.text = "";
        passwordController.text = "";
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
        ModalRoute.withName('/'),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _isLoading = false;
          emailController.text = "";
          passwordController.text = "";
        });
        print('No user found for that email.');
        _showSnackbar("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        setState(() {
          _isLoading = false;
          passwordController.text = "";
        });
        print('Wrong password provided for that user.');
        _showSnackbar("Wrong password provided for that user.");
      } else {
        setState(() {
          _isLoading = false;
          emailController.text = "";
          passwordController.text = "";
        });
        print(e.code.toString());
        _showSnackbar(e.code.toString());
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final acc = await googleSignIn.signIn();
      final auth = await acc.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: auth.idToken, accessToken: auth.accessToken);

      final res = await _auth.signInWithCredential(credential);

      User user = res.user;

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (!documentSnapshot.exists) {
        user.updateProfile(displayName: user.displayName);
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "profileName": user.displayName,
          "username": user.email.split('@')[0],
          "photoUrl": user.photoURL,
          "email": user.email,
          "intro": "",
          "location": "",
          "timeStamp": DateTime.now(),
          "type": "googleLogin",
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
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
        ModalRoute.withName('/'),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackbar(e.toString);
    }
  }
}
