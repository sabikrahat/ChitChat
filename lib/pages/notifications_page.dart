import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/models/notification_model.dart';
import 'package:chitchat/models/post_model.dart';
import 'package:chitchat/pages/show_full_post.dart';
import 'package:chitchat/widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<NotificationModel> notificationsModelList;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: notificationsReference
          .where('ownerId', isEqualTo: currentUser.uid)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Notifications"),
            ),
            body: Center(
              child: circularProgress(),
            ),
          );
        }
        notificationsModelList = [];
        snapshot.data.docs.forEach((doc) {
          notificationsModelList.add(NotificationModel.fromDocument(doc));
        });
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Notifications"),
          ),
          body: notificationsModelList.length < 1
              ? Center(child: Text("No notification to show."))
              : ListView.builder(
                  itemCount: notificationsModelList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 6.0),
                        onTap: () {
                          _notificationListTileTapped(
                              notificationsModelList[index].postId);
                        },
                        leading: Hero(
                          tag: notificationsModelList[index].likerId,
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                notificationsModelList[index].leadingUrl),
                          ),
                        ),
                        title: Transform.translate(
                          offset: Offset(-6, 0),
                          child: Text(
                            notificationsModelList[index].data,
                            style: TextStyle(fontSize: 13.0),
                          ),
                        ),
                        subtitle: Transform.translate(
                          offset: Offset(-6, 0),
                          child: Text(
                            timeago.format(
                              DateTime.fromMicrosecondsSinceEpoch(
                                notificationsModelList[index]
                                    .timestamp
                                    .microsecondsSinceEpoch,
                              ),
                            ),
                            style: TextStyle(fontSize: 11.0),
                          ),
                        ),
                        trailing: ClipRRect(
                          borderRadius: BorderRadius.circular(7.0),
                          child: CachedNetworkImage(
                            imageUrl: notificationsModelList[index].trailingUrl,
                            placeholder: (context, url) => circularProgress(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  _notificationListTileTapped(String postId) {
    PostModel _postModel;

    postsReference.doc(postId).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (!documentSnapshot.exists) {
          _showSnackbar("Post has been deleted.");
        } else {
          _postModel = PostModel.fromDocument(documentSnapshot);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowFullPost(
                postModel: _postModel,
              ),
            ),
          );
        }
      },
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
}
