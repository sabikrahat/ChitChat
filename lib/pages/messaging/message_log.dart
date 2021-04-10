import 'package:chitchat/models/user_profile.dart';
import 'package:chitchat/pages/messaging/messaging_screen.dart';
import 'package:chitchat/widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/pages/home_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

List<UserProfile> messageLogUserProfileList;

class MessageLogPage extends StatefulWidget {
  @override
  _MessageLogPageState createState() => _MessageLogPageState();
}

class _MessageLogPageState extends State<MessageLogPage> {
  Stream chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return Center(child: circularProgress());
        } else if (dataSnapshot.data.docs.length == 0) {
          messageLogUserProfileList = [];
          return Center(child: Text("You haven't chat with someone yet."));
        } else {
          messageLogUserProfileList = [];
          return ListView.builder(
            itemCount: dataSnapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = dataSnapshot.data.docs[index];
              return ChatRoomListTile(
                targetUid: ds.id
                    .replaceAll(currentUser.uid, "")
                    .replaceAll("_ChitChat_", ""),
                lastMessage: ds["lastMessage"],
                lastMessageSender: ds["lastMessageSender"],
              );
            },
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getChatAllUsersRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              showSearch(context: context, delegate: MessageLogSearchUsers());
            },
          ),
        ],
      ),
      body: chatRoomList(),
    );
  }

  getChatAllUsersRoom() async {
    chatRoomsStream = await getChatRooms();
    setState(() {});
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    return chatRoomsReference
        .orderBy("lastMessageSendTimeStamp", descending: true)
        .where("usersUid", arrayContains: currentUser.uid)
        .snapshots();
  }
}

class ChatRoomListTile extends StatefulWidget {
  final targetUid, lastMessage, lastMessageSender;

  const ChatRoomListTile({
    this.targetUid,
    this.lastMessage,
    this.lastMessageSender,
  });

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  Stream gettingInfoStream;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: gettingInfoStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Card(
            margin:
                EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
            elevation: 20.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: 25.0, bottom: 25.0, left: 20.0, right: 10.0),
              child: linearProgress(),
            ),
          );
        }
        UserProfile tempProfile = UserProfile.fromDocument(snapshot.data);
        messageLogUserProfileList.add(tempProfile);
        return Card(
          margin: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
          elevation: 20.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagingScreen(
                    targetUserUid: tempProfile.uid,
                  ),
                ),
              );
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Hero(
                tag: tempProfile.uid,
                child: Image.network(
                  tempProfile.photoUrl,
                  height: 45,
                  width: 45,
                ),
              ),
            ),
            title: Text(tempProfile.username),
            subtitle: currentUser.uid == widget.lastMessageSender
                ? Text("You: " + widget.lastMessage,
                    overflow: TextOverflow.ellipsis)
                : Text(
                    widget.lastMessage,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
            trailing: Container(
              height: 8.0,
              width: 8.0,
              decoration: BoxDecoration(
                color: tempProfile.status == "online"
                    ? Colors.greenAccent
                    : Colors.grey[600],
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  getInfo() async {
    gettingInfoStream = await getTargetUidInfo();
    setState(() {});
  }

  getTargetUidInfo() async {
    return usersReference.doc(widget.targetUid).snapshots();
  }
}

class MessageLogSearchUsers extends SearchDelegate {
  MessageLogSearchUsers({
    String hintText = "Search by username",
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

    var finalList;

    query.isEmpty
        ? finalList = messageLogUserProfileList
        : finalList = searchList;

    return finalList.isEmpty
        ? displayNoUsersFoundScreen()
        : ListView.builder(
            itemCount: finalList.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                messageLogListTileTapped(finalList[index]).then((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagingScreen(
                        targetUserUid: finalList[index].uid,
                      ),
                    ),
                  );
                });
              },
              leading: Hero(
                tag: Key(finalList[index].uid),
                child: CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(finalList[index].photoUrl),
                ),
              ),
              title: Text(finalList[index].username),
              subtitle: Text(finalList[index].profileName),
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<UserProfile> searchList = usersProfileList
        .where((user) => (user.username.toLowerCase().startsWith(query) &&
            user.uid != currentUser.uid))
        .toList();

    var finalList;

    query.isEmpty
        ? finalList = messageLogUserProfileList
        : finalList = searchList;

    return finalList.isEmpty
        ? messageLogUserProfileList.isEmpty && query.isEmpty
            ? displayNoQuerySearchScreen()
            : displayNoUsersFoundScreen()
        : ListView.builder(
            itemCount: finalList.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                messageLogListTileTapped(finalList[index]).then((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagingScreen(
                        targetUserUid: finalList[index].uid,
                      ),
                    ),
                  );
                });
              },
              leading: Hero(
                tag: Key(finalList[index].uid),
                child: CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(finalList[index].photoUrl),
                ),
              ),
              title: Text(finalList[index].username),
              subtitle: Text(finalList[index].profileName),
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

  getChatRoomIdByUid(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_ChitChat\_$a";
    } else {
      return "$a\_ChitChat\_$b";
    }
  }

  messageLogListTileTapped(UserProfile userProfile) async {
    var chatRoomId = getChatRoomIdByUid(userProfile.uid, currentUser.uid);

    Map<String, dynamic> chatRoomInfo = {
      "usersUid": [userProfile.uid, currentUser.uid],
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
  }
}
