import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/models/user_profile.dart';
import 'package:chitchat/pages/home_page.dart';
import 'package:chitchat/pages/profile_page.dart';
import 'package:chitchat/widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class MessagingScreen extends StatefulWidget {
  final String targetUserUid;

  MessagingScreen({@required this.targetUserUid});

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _messageTextEditingController;
  Stream messageStream;
  String _chatRoomId, _messageId = "";

  getChatRoomIdByUid(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_ChitChat\_$a";
    } else {
      return "$a\_ChitChat\_$b";
    }
  }

  getAndSetOldMessages() async {
    messageStream = await getMessages();
    setState(() {});
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.indigo[400],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
              bottomLeft:
                  sendByMe ? Radius.circular(20.0) : Radius.circular(0.0),
              bottomRight:
                  sendByMe ? Radius.circular(0.0) : Radius.circular(20.0),
            ),
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70.0, top: 15.0),
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMessageTile(
                      ds["message"], currentUser.uid == ds["sender"]);
                },
              )
            : Center(
                child: circularProgress(),
              );
      },
    );
  }

  onStartWork() async {
    _messageTextEditingController = TextEditingController();
    _chatRoomId = getChatRoomIdByUid(widget.targetUserUid, currentUser.uid);
    await getAndSetOldMessages();
  }

  @override
  void initState() {
    super.initState();
    onStartWork();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: usersReference.doc(widget.targetUserUid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: circularProgress(),
          );
        }
        UserProfile tempShowProfile = UserProfile.fromDocument(snapshot.data);
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  child: Text(tempShowProfile.username),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          userUid: tempShowProfile.uid,
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  alignment: Alignment.center,
                  height: 8.0,
                  width: 8.0,
                  decoration: BoxDecoration(
                      color: tempShowProfile.status == "online"
                          ? Colors.greenAccent
                          : Colors.grey[600],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Hero(
                  tag: Key(tempShowProfile.uid),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      tempShowProfile.photoUrl,
                    ),
                  ),
                ),
                iconSize: 45.0,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        userUid: tempShowProfile.uid,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Container(
            child: Stack(
              children: [
                chatMessages(),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              autofocus: false,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 3,
                              controller: _messageTextEditingController,
                              validator: (error) {
                                if (error.isEmpty) {
                                  return "Can't send a blank message";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                addMessage(false);
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  left: 8.0,
                                  top: 5.0,
                                  bottom: 5.0,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.indigo[400]),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                hintText: "Type your message...",
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: IconButton(
                                    icon: Icon(Icons.emoji_emotions_outlined),
                                    onPressed: () {
                                      // sticker choose option open
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: InkWell(
                            onTap: () {
                              _showBottomSheetOptions();
                            },
                            child: Icon(
                              Icons.attach_file,
                              color: Colors.indigo[400],
                              size: 26.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: InkWell(
                            onTap: () {
                              setState(
                                () {
                                  if (_formKey.currentState.validate()) {
                                    addMessage(true);
                                  }
                                },
                              );
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.indigo[400],
                              size: 26.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _showBottomSheetOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {},
                              color: Colors.indigo[400],
                              textColor: Colors.white,
                              child: Icon(
                                Icons.camera_alt,
                                size: 24,
                              ),
                              padding: EdgeInsets.all(16),
                              shape: CircleBorder(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                "Camera",
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {},
                              color: Colors.indigo[400],
                              textColor: Colors.white,
                              child: Icon(
                                Icons.photo,
                                size: 24,
                              ),
                              padding: EdgeInsets.all(16),
                              shape: CircleBorder(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                "Gallery",
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {},
                              color: Colors.indigo[400],
                              textColor: Colors.white,
                              child: Icon(
                                Icons.assignment_rounded,
                                size: 24,
                              ),
                              padding: EdgeInsets.all(16),
                              shape: CircleBorder(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                "Document",
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {},
                              color: Colors.indigo[400],
                              textColor: Colors.white,
                              child: Icon(
                                Icons.mic,
                                size: 24,
                              ),
                              padding: EdgeInsets.all(16),
                              shape: CircleBorder(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                "Voice Message",
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {},
                              color: Colors.indigo[400],
                              textColor: Colors.white,
                              child: Icon(
                                Icons.headset,
                                size: 24,
                              ),
                              padding: EdgeInsets.all(16),
                              shape: CircleBorder(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                "Audio",
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {},
                              color: Colors.indigo[400],
                              textColor: Colors.white,
                              child: Icon(
                                Icons.location_on,
                                size: 24,
                              ),
                              padding: EdgeInsets.all(16),
                              shape: CircleBorder(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                "Current Location",
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> addMessage(bool sendClicked) async {
    if (_messageTextEditingController.text != "") {
      String message = _messageTextEditingController.text;
      var ts = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sender": currentUser.uid,
        "timeStamp": ts,
        "type": "msg",
      };

      // message id
      if (_messageId == "") {
        _messageId = randomAlphaNumeric(12);
      }

      await chatRoomsReference
          .doc(_chatRoomId)
          .collection("chats")
          .doc(_messageId)
          .set(messageInfoMap)
          .then((value) async {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTimeStamp": ts,
          "lastMessageSender": currentUser.uid,
          "lastMessageType": "msg",
        };

        await chatRoomsReference.doc(_chatRoomId).update(lastMessageInfoMap);

        if (sendClicked) {
          //remove the text in the message input Field
          _messageTextEditingController.text = "";
          // make message id blank to get regenerated on next message send
          _messageId = "";
        }
      });
    }
  }

  Future<Stream<QuerySnapshot>> getMessages() async {
    return chatRoomsReference
        .doc(_chatRoomId)
        .collection("chats")
        .orderBy("timeStamp", descending: true)
        .snapshots();
  }
}
