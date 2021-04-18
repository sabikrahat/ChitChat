import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/models/post_model.dart';
import 'package:chitchat/pages/edit_post.dart';
import 'package:chitchat/pages/photo_viewer.dart';
import 'package:chitchat/pages/profile_page.dart';
import 'package:chitchat/pages/show_full_post.dart';
import 'package:chitchat/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class ShowTagPosts extends StatefulWidget {
  final String tag;

  const ShowTagPosts({Key key, this.tag}) : super(key: key);

  @override
  _ShowTagPostsState createState() => _ShowTagPostsState();
}

class _ShowTagPostsState extends State<ShowTagPosts> {
  List<PostModel> postModelList;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: postsReference
          .where('tag', isEqualTo: widget.tag)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Posts of #" + widget.tag + " Tag"),
            ),
            body: Center(child: circularProgress()),
          );
        }
        postModelList = [];
        snapshot.data.docs.forEach((doc) {
          postModelList.add(PostModel.fromDocument(doc));
        });
        return Scaffold(
          appBar: AppBar(
            title: Text("Posts of #" + widget.tag + " Tag"),
          ),
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: postModelList.length,
            itemBuilder: (context, index) {
              var tempShowPostList = usersProfileList
                  .where((user) => user.uid == postModelList[index].ownerId)
                  .toList();
              return Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
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
                              onPressed: null,
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
                                right: 8.0, left: 8.0, bottom: 5.0),
                            child: postModelList[index].description == ""
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
                                        postModelList[index].description,
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
}
