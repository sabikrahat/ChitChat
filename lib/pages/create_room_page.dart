import 'package:chitchat/models/user_profile.dart';
import 'package:chitchat/utils/sharedpref_helper.dart';
import 'package:flutter/material.dart';

class CreateRoomPage extends StatefulWidget {
  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  var uid,
      profileName,
      username,
      photoUrl,
      email,
      intro,
      location,
      type,
      status,
      tokenId,
      totalPost,
      totalStar,
      totalPoint;

  UserProfile tempShowUserProfile;


  getUserInfoFromSharedPreferences() async {
    uid = await SharedPreferenceHelper().getUserUid();
    profileName = await SharedPreferenceHelper().getUserProfileName();
    username = await SharedPreferenceHelper().getUserUsername();
    photoUrl = await SharedPreferenceHelper().getUserPhotoUrl();
    email = await SharedPreferenceHelper().getUserEmail();
    intro = await SharedPreferenceHelper().getUserIntro();
    location = await SharedPreferenceHelper().getUserLocation();
    type = await SharedPreferenceHelper().getUserType();
    status = await SharedPreferenceHelper().getUserStatus();
    tokenId = await SharedPreferenceHelper().getUserTokenId();
    totalPost = await SharedPreferenceHelper().getUserTotalPost();
    totalStar = await SharedPreferenceHelper().getUserTotalStar();
    totalPoint = await SharedPreferenceHelper().getUserTotalPoint();

    tempShowUserProfile = await SharedPreferenceHelper().getUserAllInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Room"),
      ),
      body: FutureBuilder(
        future: getUserInfoFromSharedPreferences(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Card(
                elevation: 20.0,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "SharedPreference Helper",
                          textAlign: TextAlign.center,
                          textScaleFactor: 2.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Uid: $uid"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Profile Name: $profileName"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Username: $username"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Photo Url : $photoUrl"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Email: $email"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Intro: $intro"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Location: $location"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Type: $type"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Status: $status"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("TokenId: $tokenId"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("TotalPost: $totalPost"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("TotalStar: $totalStar"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("TotalPoint: $totalPoint"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("All Info: $tempShowUserProfile"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
