import 'package:chitchat/models/post_model.dart';
import 'package:chitchat/models/user_profile.dart';
import 'package:chitchat/pages/create_room_page.dart';
import 'package:chitchat/pages/edit_post.dart';
import 'package:chitchat/pages/notifications_page.dart';
import 'package:chitchat/pages/photo_viewer.dart';
import 'package:chitchat/pages/profile_page.dart';
import 'package:chitchat/pages/reset_password_page.dart';
import 'package:chitchat/pages/settings.dart';
import 'package:chitchat/pages/show_full_post.dart';
import 'package:chitchat/pages/show_tag_posts.dart';
import 'package:chitchat/pages/tic_tac_toe/tic_tac_toe.dart';
import 'package:chitchat/utils/sharedpref_helper.dart';
import 'package:chitchat/utils/theme.dart';
import 'package:chitchat/widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'contact_me_page.dart';
import 'create_post_page.dart';
import 'messaging/message_log.dart';
import 'welcome_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_launcher/email_launcher.dart';

final usersReference = FirebaseFirestore.instance.collection("users");
final postsReference = FirebaseFirestore.instance.collection("posts");
final tagsReference = FirebaseFirestore.instance.collection("tags");
final chatRoomsReference = FirebaseFirestore.instance.collection("chatrooms");
final storageReference = FirebaseStorage.instance.ref("Profile_Pictures");
final postStorageReference = FirebaseStorage.instance.ref("Posts");
UserProfile currentUser;
List<UserProfile> usersProfileList;
List<PostModel> postModelList;
var userTags;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Stream getPosts;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // set status to online here in firestore
      usersReference
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
            "status": "online",
          })
          .then((value) => print("User Online Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else {
      // set status to offline here in firestore
      usersReference
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
            "status": "offline",
          })
          .then((value) => print("User Offline Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: usersReference.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "ChitChat",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 4.0,
                  fontFamily: "Signatra",
                  fontSize: 35.0,
                ),
              ),
              centerTitle: true,
            ),
            body: Center(
              child: circularProgress(),
            ),
          );
        }
        usersProfileList = [];
        dataSnapshot.data.docs.forEach((doc) {
          usersProfileList.add(UserProfile.fromDocument(doc));
        });
        return StreamBuilder(
          stream: usersReference
              .doc(FirebaseAuth.instance.currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "ChitChat",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 4.0,
                      fontFamily: "Signatra",
                      fontSize: 35.0,
                    ),
                  ),
                  centerTitle: true,
                ),
                body: Center(
                  child: circularProgress(),
                ),
              );
            }
            userTags = [];
            currentUser = UserProfile.fromDocument(snapshot.data);
            userTags = (currentUser.tags).toList();
            SharedPreferenceHelper().saveUserAllInfo(currentUser);
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "ChitChat",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: 4.0,
                    fontFamily: "Signatra",
                    fontSize: 35.0,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(context: context, delegate: SearchUsers());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.qr_code_scanner_sharp),
                    onPressed: () {
                      scanQrCode();
                    },
                  ),
                ],
              ),
              drawer: Drawer(
                child: ListView(
                  padding: const EdgeInsets.all(0),
                  children: <Widget>[
                    Consumer<ThemeNotifier>(
                        builder: (context, notifier, child) {
                      return UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          color: notifier.darkTheme
                              ? Colors.black12
                              : Colors.indigo[400],
                        ),
                        accountName: Text(currentUser.username,
                            style: TextStyle(fontSize: 15.0)),
                        accountEmail: Text(currentUser.profileName,
                            style: TextStyle(fontSize: 14.0)),
                        currentAccountPicture: Hero(
                          tag: Key(currentUser.uid),
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                currentUser.photoUrl),
                          ),
                        ),
                      );
                    }),
                    Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) {
                        return SwitchListTile(
                          activeColor: Colors.indigo[400],
                          title: Text(
                            "Dark Mode",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onChanged: (val) {
                            notifier.toggleTheme();
                          },
                          value: notifier.darkTheme,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0, top: 0.0),
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
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "ChitChat",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
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
                    ListTile(
                      leading: Icon(Icons.post_add_sharp),
                      title: Text("Create Post"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreatePostPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.message),
                      title: Text("Chats"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessageLogPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.video_call_sharp),
                      title: Text("Create Room"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateRoomPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications_on_outlined),
                      title: Text("Notifications"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationsPage(),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Profile",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
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
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Profile"),
                      subtitle: Text(currentUser.email),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              userUid: currentUser.uid,
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.security_sharp),
                      title: Text("Reset Password"),
                      subtitle: Text("You'll automatically logged out."),
                      onTap: () {
                        if (currentUser.type == "firebaseLogin") {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPasswordPage(),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                          _showSnackbar("Invalid for google sign-in user");
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.reply),
                      title: Text("Log Out"),
                      onTap: () {
                        _signOut();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0, top: 0.0),
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
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Offline Games",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
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
                    ListTile(
                      leading: Icon(Icons.games),
                      title: Text("Tic Tac Toe"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TicTacToe(),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0, top: 0.0),
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
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Customization",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
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
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("Settings"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Communication",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
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
                    ListTile(
                      leading: Icon(Icons.contact_support),
                      title: Text("Contact Me"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactMePage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.feedback),
                      title: Text("Feedback"),
                      onTap: () async {
                        Navigator.pop(context);
                        Email email = Email(
                            to: ['sabikrahat72428@gmail.com'],
                            subject: 'ChitChat Application Feedback',
                            body:
                                'Name: ${currentUser.profileName}\nUsername: ${currentUser.username}\n\nYour Comment: ');
                        await EmailLauncher.launch(email);
                      },
                    ),
                    SizedBox(height: size.height * 0.02)
                  ],
                ),
              ),
              body: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Hey " + currentUser.username + ", " + greeting(),
                        style: TextStyle(
                          letterSpacing: 2.0,
                          fontFamily: "Signatra",
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                    showPosts(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String greeting() {
    var timeNow = DateTime.now().hour;
    if (timeNow > 3 && timeNow <= 12) {
      return 'Good Morning!';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon!';
    } else if ((timeNow > 16) && (timeNow <= 20)) {
      return 'Good Evening!';
    } else {
      return 'Good Night!';
    }
  }

  Widget showPosts() {
    return StreamBuilder(
      stream: postsReference
          .where('tag', whereIn: userTags)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return Center(child: circularProgress());
        }
        postModelList = [];
        dataSnapshot.data.docs.forEach((doc) {
          postModelList.add(PostModel.fromDocument(doc));
        });
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: postModelList.length,
          itemBuilder: (context, index) {
            var tempShowPostList = usersProfileList
                .where((user) => user.uid == postModelList[index].ownerId)
                .toList();
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                splashColor: Colors.indigo[400],
                onTap: () {
                  _showBottomSheetOptions(postModelList[index]);
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
                          leading: InkWell(
                            splashColor: Colors.indigo[400],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                      userUid: tempShowPostList[0].uid),
                                ),
                              );
                            },
                            child: Hero(
                              tag: tempShowPostList[0].uid,
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    tempShowPostList[0].photoUrl),
                              ),
                            ),
                          ),
                          title: InkWell(
                            splashColor: Colors.indigo[400],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                      userUid: tempShowPostList[0].uid),
                                ),
                              );
                            },
                            child: Text(
                              tempShowPostList[0].username,
                              style: TextStyle(
                                fontSize: 22.0,
                                fontFamily: "Signatra",
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            postModelList[index].location,
                            style: TextStyle(fontSize: 11.0),
                          ),
                          trailing: tempShowPostList[0].uid != currentUser.uid
                              ? null
                              : InkWell(
                                  child: Icon(Icons.edit),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditPost(
                                          postModel: postModelList[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Hero(
                          tag: postModelList[index].url,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: CachedNetworkImage(
                              imageUrl: postModelList[index].url,
                              placeholder: (context, url) => circularProgress(),
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
                                var likeList = postModelList[index].likes;
                                int starts = tempShowPostList[0].totalStar;
                                if (postModelList[index]
                                    .likes
                                    .contains(currentUser.uid)) {
                                  likeList.remove(currentUser.uid);
                                  starts -= 1;
                                } else {
                                  likeList.add(currentUser.uid);
                                  starts += 1;
                                }
                                postsReference
                                    .doc(postModelList[index].postId)
                                    .update({
                                  "likes": likeList,
                                });
                                usersReference
                                    .doc(postModelList[index].ownerId)
                                    .update({
                                  "totalStar": starts,
                                });
                              });
                            },
                            child: postModelList[index]
                                    .likes
                                    .contains(currentUser.uid)
                                ? Icon(Icons.star_outlined,
                                    color: Colors.indigo[400], size: 30.0)
                                : Icon(Icons.star_outline_sharp, size: 30.0),
                          ),
                          title: postModelList[index].likes.length > 0
                              ? Transform.translate(
                                  offset: Offset(-16, 0),
                                  child: Text(
                                    "This post has gained " +
                                        postModelList[index]
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowTagPosts(
                                    tag: postModelList[index].tag,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "#" + postModelList[index].tag,
                              style: TextStyle(fontSize: 13.0),
                            ),
                            borderSide: BorderSide(color: Colors.indigo[400]),
                            shape: StadiumBorder(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0, left: 8.0, bottom: 8.0),
                          child: postModelList[index].description == ""
                              ? null
                              : Text(
                                  postModelList[index].description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
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

  Future<void> scanQrCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      if (!mounted) return;

      usersReference
          .doc(qrCode)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                userUid: qrCode,
              ),
            ),
          );
        } else {
          _showToast("No user found with QR Scanner credential");
        }
      });
    } catch (e) {
      _showToast("No user found with QR Scanner credential");
    }
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
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut().then((_) {
        print("Sign Out Success");
        _showSnackbar("Sign out");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomePage(),
          ),
          ModalRoute.withName('/'),
        );
      });
    } catch (e) {
      print(e.toString());
      _showSnackbar(e.toString);
    }
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

  _showToast(message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[900],
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}

class SearchUsers extends SearchDelegate {
  SearchUsers({
    String hintText = "Search User",
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        tooltip: "Clear",
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<UserProfile> searchList = usersProfileList
        .where((user) => (user.username.toLowerCase().startsWith(query) &&
            user.uid != currentUser.uid))
        .toList();

    return query.isEmpty
        ? displayNoQuerySearchScreen()
        : searchList.isEmpty
            ? displayNoUsersFoundScreen()
            : ListView.builder(
                itemCount: searchList.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          userUid: searchList[index].uid,
                        ),
                      ),
                    );
                  },
                  leading: Hero(
                    tag: Key(searchList[index].uid),
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          searchList[index].photoUrl),
                    ),
                  ),
                  title: Text(searchList[index].username),
                  subtitle: Text(searchList[index].profileName),
                ),
              );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<UserProfile> searchList = usersProfileList
        .where((user) => (user.username.toLowerCase().startsWith(query) &&
            user.uid != currentUser.uid))
        .toList();

    return query.isEmpty
        ? displayNoQuerySearchScreen()
        : searchList.isEmpty
            ? displayNoUsersFoundScreen()
            : ListView.builder(
                itemCount: searchList.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          userUid: searchList[index].uid,
                        ),
                      ),
                    );
                  },
                  leading: Hero(
                    tag: Key(searchList[index].uid),
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          searchList[index].photoUrl),
                    ),
                  ),
                  title: Text(searchList[index].username),
                  subtitle: Text(searchList[index].profileName),
                ),
              );
  }

  Container displayNoQuerySearchScreen() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(Icons.group, color: Colors.grey, size: 80.0),
            Text(
              "Search User by Username",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container displayNoUsersFoundScreen() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(Icons.engineering_sharp, color: Colors.grey, size: 80.0),
            Text(
              "No User Found",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
