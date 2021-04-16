import 'package:barcode_widget/barcode_widget.dart';
import 'package:chitchat/models/user_profile.dart';
import 'package:chitchat/pages/edit_profile.dart';
import 'package:chitchat/pages/messaging/messaging_screen.dart';
import 'package:chitchat/pages/photo_viewer.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/pages/home_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  final String userUid;

  ProfilePage({@required this.userUid});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<UserProfile> _showProfileList;
  bool _ownProfile = false;

  @override
  void initState() {
    super.initState();
    _showProfileList =
        usersProfileList.where((user) => user.uid == widget.userUid).toList();

    if (currentUser.uid == widget.userUid) {
      _ownProfile = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 28.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.indigo[400],
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 28.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.qr_code_rounded,
                      color: Colors.indigo[400],
                    ),
                    onPressed: () {
                      createQrCode();
                    },
                  ),
                ),
              ],
            ),
            Center(
              child: Hero(
                tag: Key(_showProfileList[0].photoUrl),
                child: InkWell(
                  splashColor: Colors.indigo[400],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImagePreviewer(
                          photoUrl: _showProfileList[0].photoUrl,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: size.width * 0.4,
                    height: size.width * 0.4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            _showProfileList[0].photoUrl),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _showProfileList[0].username,
                style: TextStyle(
                  fontSize: 28.0,
                  fontFamily: "Signatra",
                  letterSpacing: 2.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                _showProfileList[0].profileName,
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 10.0, left: 8.0, right: 8.0),
              child: Text(
                _showProfileList[0].intro.isEmpty
                    ? "\" No intro given yet \""
                    : "\" " + _showProfileList[0].intro + " \"",
                maxLines: 5,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.85),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(
                      color: Colors.green,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(35))),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      Text(
                        _showProfileList[0].location.isEmpty
                            ? "No location set yet"
                            : _showProfileList[0].location,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.indigo[400])),
              padding: EdgeInsets.only(
                  top: 6.0, bottom: 10.0, left: 10.0, right: 15.0),
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Posts"),
                        Text("✔️  " + _showProfileList[0].totalPost.toString()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Stars"),
                        Text("🌟  " + _showProfileList[0].totalStar.toString()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Points"),
                        Text(
                            "💰  " + _showProfileList[0].totalPoint.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 8.0),
              // ignore: deprecated_member_use
              child: OutlineButton(
                splashColor: Colors.indigo[400],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                highlightElevation: 0,
                borderSide: BorderSide(color: Colors.indigo[400]),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 50.0, right: 50.0),
                  child: Text(
                    _ownProfile ? "✒️ Edit Profile" : "💬 Message",
                  ),
                ),
                onPressed: () {
                  _ownProfile
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfile(),
                          ),
                        )
                      : sendMessageOptionClicked();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  createQrCode() {
    AlertDialog alertDialog = AlertDialog(
      title: Center(
        child: Text(
          _showProfileList[0].username,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BarcodeWidget(
            height: 200.0,
            width: 200.0,
            barcode: Barcode.qrCode(),
            color: Colors.indigo[400],
            data: widget.userUid,
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, bottom: 10.0, left: 8.0, right: 8.0),
            // ignore: deprecated_member_use
            child: OutlineButton(
              splashColor: Colors.indigo[400],
              onPressed: () {
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              highlightElevation: 0,
              borderSide: BorderSide(color: Colors.indigo[400]),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  "      Cancel      ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }

  getChatRoomIdByUid(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_ChitChat\_$a";
    } else {
      return "$a\_ChitChat\_$b";
    }
  }

  sendMessageOptionClicked() async {
    var chatRoomId = getChatRoomIdByUid(widget.userUid, currentUser.uid);

    Map<String, dynamic> chatRoomInfo = {
      "usersUid": [widget.userUid, currentUser.uid],
    };

    final snapshot = await chatRoomsReference.doc(chatRoomId).get();

    if (!snapshot.exists) {
      chatRoomsReference.doc(chatRoomId).set(chatRoomInfo);
      usersReference
          .doc(currentUser.uid)
          .update({
            "totalPoint": currentUser.totalPoint + 10,
          })
          .then((value) => print("Point +10 Updated"))
          .catchError((error) => print("Failed to update point: $error"));
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagingScreen(
          targetUserUid: _showProfileList[0].uid,
        ),
      ),
    );
  }
}
