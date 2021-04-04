import 'package:chitchat/pages/login_page.dart';
import 'package:chitchat/pages/register_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/icon.png",
                    width: 55.0,
                    height: 55.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, top: 5.0),
                    child: Text(
                      "ChitChat",
                      style: TextStyle(
                        fontSize: 42.0,
                        fontFamily: "Signatra",
                        color: Colors.indigo[400],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.05),
              Text(
                "Welcome To ChitChat",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              SizedBox(
                height: 42.0,
                width: double.infinity,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.indigo[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: size.height * 0.015),
              SizedBox(
                height: 42.0,
                width: double.infinity,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.indigo[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.indigo[500],
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: size.height * 0.015),
            ],
          ),
        ),
      ),
    );
  }
}
