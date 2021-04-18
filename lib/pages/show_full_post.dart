import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/models/post_model.dart';
import 'package:chitchat/pages/edit_post.dart';
import 'package:chitchat/pages/photo_viewer.dart';
import 'package:chitchat/pages/profile_page.dart';
import 'package:chitchat/pages/show_tag_posts.dart';
import 'package:chitchat/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class ShowFullPost extends StatefulWidget {
  final PostModel postModel;

  const ShowFullPost({Key key, this.postModel}) : super(key: key);

  @override
  _ShowFullPostState createState() => _ShowFullPostState();
}

class _ShowFullPostState extends State<ShowFullPost> {
  var tempShowPostList;

  @override
  void initState() {
    super.initState();
    tempShowPostList = usersProfileList
        .where((user) => user.uid == widget.postModel.ownerId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
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
                          builder: (context) =>
                              ProfilePage(userUid: tempShowPostList[0].uid),
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
                          builder: (context) =>
                              ProfilePage(userUid: tempShowPostList[0].uid),
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
                    widget.postModel.location,
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
                                  postModel: widget.postModel,
                                ),
                              ),
                            );
                          },
                        ),
                ),
                InkWell(
                  splashColor: Colors.indigo[400],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImagePreviewer(
                          photoUrl: widget.postModel.url,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: widget.postModel.url,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: CachedNetworkImage(
                        imageUrl: widget.postModel.url,
                        placeholder: (context, url) => circularProgress(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          timeago.format(
                            DateTime.fromMicrosecondsSinceEpoch(
                              widget.postModel.timestamp.microsecondsSinceEpoch,
                            ),
                          ),
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
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                  leading: InkWell(
                    splashColor: Colors.indigo[400],
                    onTap: () {
                      setState(() {
                        var likeList = widget.postModel.likes;
                        int starts = tempShowPostList[0].totalStar;
                        if (widget.postModel.likes.contains(currentUser.uid)) {
                          likeList.remove(currentUser.uid);
                          starts -= 1;
                        } else {
                          likeList.add(currentUser.uid);
                          starts += 1;

                          notificationsReference
                              .doc(widget.postModel.ownerId +
                                  "_chitchat_notifications_" +
                                  widget.postModel.postId)
                              .set({
                            "ownerId": widget.postModel..ownerId,
                            "likerId": currentUser.uid,
                            "leadingUrl": currentUser.photoUrl,
                            "data": widget.postModel.ownerId == currentUser.uid
                                ? "You have gave yourself a star."
                                : currentUser.username + " gave you a star.",
                            "timestamp": DateTime.now(),
                            "postId": widget.postModel.postId,
                            "trailingUrl": widget.postModel.url,
                          });
                        }
                        postsReference.doc(widget.postModel.postId).update({
                          "likes": likeList,
                        });
                        usersReference.doc(widget.postModel.ownerId).update({
                          "totalStar": starts,
                        });
                      });
                    },
                    child: widget.postModel.likes.contains(currentUser.uid)
                        ? Icon(Icons.star_outlined,
                            color: Colors.indigo[400], size: 30.0)
                        : Icon(Icons.star_outline_sharp, size: 30.0),
                  ),
                  title: widget.postModel.likes.length > 0
                      ? Transform.translate(
                          offset: Offset(-16, 0),
                          child: Text(
                            "This post has gained " +
                                widget.postModel.likes.length.toString() +
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
                    visualDensity: VisualDensity(horizontal: -4, vertical: -2),
                    splashColor: Colors.indigo[400],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowTagPosts(
                            tag: widget.postModel.tag,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "#" + widget.postModel.tag,
                      style: TextStyle(fontSize: 13.0),
                    ),
                    borderSide: BorderSide(color: Colors.indigo[400]),
                    shape: StadiumBorder(),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 5.0),
                  child: widget.postModel.description == ""
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
                                    padding: const EdgeInsets.symmetric(
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
                              widget.postModel.description,
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
  }
}
