import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/models/post_model.dart';
import 'package:chitchat/pages/photo_viewer.dart';
import 'package:chitchat/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

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
                  subtitle: Text(tempShowPostList[0].location),
                  trailing: tempShowPostList[0].uid != currentUser.uid
                      ? null
                      : InkWell(
                          child: Icon(Icons.edit),
                          onTap: () {},
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
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
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
                    onPressed: () {},
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
                      const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
                  child: widget.postModel.description == ""
                      ? null
                      : Text(
                          widget.postModel.description,
                          style: TextStyle(fontSize: 15.0),
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
