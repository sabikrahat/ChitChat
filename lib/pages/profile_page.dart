import 'package:barcode_widget/barcode_widget.dart';
import 'package:chitchat/models/post_model.dart';
import 'package:chitchat/models/user_profile.dart';
import 'package:chitchat/pages/edit_post.dart';
import 'package:chitchat/pages/edit_profile.dart';
import 'package:chitchat/pages/messaging/messaging_screen.dart';
import 'package:chitchat/pages/photo_viewer.dart';
import 'package:chitchat/pages/show_full_post.dart';
import 'package:chitchat/widgets/ProgressWidget.dart';
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
  List<PostModel> _showProfilePostsList;
  bool _ownProfile = false;
  String postOrientation = 'grid';

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
        physics: ScrollPhysics(),
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
            Divider(
              color: Colors.indigo[400],
              height: 1.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(Icons.grid_on),
                  color: postOrientation == 'grid'
                      ? Colors.indigo[400]
                      : Colors.grey,
                  onPressed: () {
                    setState(() {
                      postOrientation = 'grid';
                    });
                  },
                ),
                IconButton(
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(Icons.menu_sharp),
                  color: postOrientation == 'list'
                      ? Colors.indigo[400]
                      : Colors.grey,
                  onPressed: () {
                    setState(() {
                      postOrientation = 'list';
                    });
                  },
                ),
              ],
            ),
            Divider(
              color: Colors.indigo[400],
              height: 1.0,
            ),
            _displayProfilePosts(),
          ],
        ),
      ),
    );
  }

  Widget _displayProfilePosts() {
    return StreamBuilder(
      stream: postsReference
          .where('ownerId', isEqualTo: widget.userUid)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        _showProfilePostsList = [];
        snapshot.data.docs.forEach((doc) {
          _showProfilePostsList.add(PostModel.fromDocument(doc));
        });
        if (_showProfilePostsList.isEmpty) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 20.0),
                  child:
                      Icon(Icons.photo_library, color: Colors.grey, size: 80.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "No Posts",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (postOrientation == 'grid') {
          return GridView.count(
            padding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 8.0, bottom: 4.0),
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(
              _showProfilePostsList.length,
              (index) {
                return GestureDetector(
                  onLongPress: () {
                    _showBottomSheetOptions(_showProfilePostsList[index]);
                  },
                  child: InkWell(
                    splashColor: Colors.indigo[400],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowFullPost(
                            postModel: _showProfilePostsList[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7.0),
                        child: CachedNetworkImage(
                          imageUrl: _showProfilePostsList[index].url,
                          placeholder: (context, url) => circularProgress(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(
                          color: Colors.indigo[400],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (postOrientation == 'list') {
          return ListView.builder(
            padding: const EdgeInsets.all(0.0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _showProfilePostsList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                child: InkWell(
                  splashColor: Colors.indigo[400],
                  onTap: () {
                    _showBottomSheetOptions(_showProfilePostsList[index]);
                  },
                  child: Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  _showProfileList[0].photoUrl),
                            ),
                            title: Text(
                              _showProfileList[0].username,
                              style: TextStyle(
                                fontSize: 22.0,
                                fontFamily: "Signatra",
                                letterSpacing: 1.2,
                              ),
                            ),
                            subtitle: Text(
                              _showProfilePostsList[index].location,
                              style: TextStyle(fontSize: 11.0),
                            ),
                            trailing: _showProfileList[0].uid != currentUser.uid
                                ? null
                                : InkWell(
                                    child: Icon(Icons.edit),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditPost(
                                            postModel:
                                                _showProfilePostsList[index],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          Hero(
                            tag: _showProfilePostsList[index].url,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: CachedNetworkImage(
                                imageUrl: _showProfilePostsList[index].url,
                                placeholder: (context, url) =>
                                    circularProgress(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            contentPadding:
                                EdgeInsets.only(left: 0.0, right: 0.0),
                            leading: InkWell(
                              splashColor: Colors.indigo[400],
                              onTap: () {
                                setState(() {
                                  var likeList =
                                      _showProfilePostsList[index].likes;
                                  int starts = _showProfileList[0].totalStar;
                                  if (_showProfilePostsList[index]
                                      .likes
                                      .contains(currentUser.uid)) {
                                    likeList.remove(currentUser.uid);
                                    starts -= 1;
                                  } else {
                                    likeList.add(currentUser.uid);
                                    starts += 1;
                                  }
                                  postsReference
                                      .doc(_showProfilePostsList[index].postId)
                                      .update({
                                    "likes": likeList,
                                  });
                                  usersReference
                                      .doc(_showProfilePostsList[index].ownerId)
                                      .update({
                                    "totalStar": starts,
                                  });
                                });
                              },
                              child: _showProfilePostsList[index]
                                      .likes
                                      .contains(currentUser.uid)
                                  ? Icon(Icons.star_outlined,
                                      color: Colors.indigo[400], size: 30.0)
                                  : Icon(Icons.star_outline_sharp, size: 30.0),
                            ),
                            title: _showProfilePostsList[index].likes.length > 0
                                ? Transform.translate(
                                    offset: Offset(-16, 0),
                                    child: Text(
                                      "This post has gained " +
                                          _showProfilePostsList[index]
                                              .likes
                                              .length
                                              .toString() +
                                          " stars.",
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                  )
                                : Transform.translate(
                                    offset: Offset(-16, 0),
                                    child: Text(
                                      "Be the first contributer. Hit the star button.",
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                  ),
                            // ignore: deprecated_member_use
                            trailing: OutlineButton(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -2),
                              splashColor: Colors.indigo[400],
                              onPressed: null,
                              child: Text(
                                "#" + _showProfilePostsList[index].tag,
                                style: TextStyle(fontSize: 13.0),
                              ),
                              borderSide: BorderSide(color: Colors.indigo[400]),
                              shape: StadiumBorder(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, left: 8.0, bottom: 5.0),
                            child: _showProfilePostsList[index].description ==
                                    ""
                                ? null
                                : ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Divider(
                                                color: Colors.indigo[400],
                                                height: 1.5,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: Text(
                                                "Caption",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.indigo[400],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Divider(
                                                color: Colors.indigo[400],
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        _showProfilePostsList[index]
                                            .description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
          child: Text(
            "An error occurred.",
            style: TextStyle(fontSize: 17.0),
          ),
        );
      },
    );
  }

  _showBottomSheetOptions(PostModel postModel) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "View As",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: 1.8,
                    fontFamily: "Signatra",
                    fontSize: 27.0,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.post_add_rounded),
                  title: Text("View Full Post"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowFullPost(
                          postModel: postModel,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.remove_red_eye_outlined),
                  title: Text("View Post's Photo"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImagePreviewer(
                          photoUrl: postModel.url,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
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
