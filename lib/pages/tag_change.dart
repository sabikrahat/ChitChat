import 'package:chitchat/models/user_profile.dart';
import 'package:chitchat/pages/home_page.dart';
import 'package:chitchat/widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

List<String> allTagsList;

class TagChange extends StatefulWidget {
  @override
  _TagChangeState createState() => _TagChangeState();
}

class _TagChangeState extends State<TagChange> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _tagList;

  @override
  void initState() {
    super.initState();
    _tagList = [];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: usersReference.doc(currentUser.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            key: _scaffoldKey,
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
        _tagList = (UserProfile.fromDocument(snapshot.data)).tags.toList();
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
                  allTagsList = [];
                  tagsReference.get().then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      allTagsList.add((doc["tagName"]).toString());
                    });
                  }).then((_) {
                    print(allTagsList.length.toString());
                    showSearch(context: context, delegate: TagAddSearch());
                  });
                },
              ),
            ],
          ),
          body: _tagList.length == 0
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Welcome to chitchat.\nGo and search for your interested tag to see related post.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _tagList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5.0,
                      child: ListTile(
                        leading: Icon(Icons.tag),
                        title: Text(_tagList[index]),
                        trailing: InkWell(
                          onTap: () {
                            if (_tagList.length > 1) {
                              setState(() {
                                _tagList.removeAt(index);
                                usersReference.doc(currentUser.uid).update({
                                  "tags": _tagList,
                                });
                              });
                            } else {
                              _showSnackbar("You can't delete all the tags.");
                            }
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
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

class TagAddSearch extends SearchDelegate {
  TagAddSearch({
    String hintText = "Search Tag",
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
    var finalTagList = [];

    var searchList = allTagsList
        .where((element) => element.toLowerCase().startsWith(query))
        .toList();

    query.isEmpty ? finalTagList = allTagsList : finalTagList = searchList;

    return finalTagList.isEmpty
        ? displayNoTagsFoundScreen()
        : ListView.builder(
            itemCount: finalTagList.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                _tagAdd(finalTagList[index]);
              },
              leading: Icon(Icons.arrow_right),
              title: Text("#" + finalTagList[index]),
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var finalTagList = [];

    var searchList = allTagsList
        .where((element) => element.toLowerCase().startsWith(query))
        .toList();

    query.isEmpty ? finalTagList = allTagsList : finalTagList = searchList;

    return finalTagList.isEmpty
        ? displayNoTagsFoundScreen()
        : ListView.builder(
            itemCount: finalTagList.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                _tagAdd(finalTagList[index]);
              },
              leading: Icon(Icons.arrow_right),
              title: Text("#" + finalTagList[index]),
            ),
          );
  }

  _tagAdd(String newTag) {
    var tempTagList = currentUser.tags;

    if (!tempTagList.contains(newTag)) {
      tempTagList.add(newTag);
      usersReference.doc(currentUser.uid).update({
        "tags": tempTagList,
      }).then((_) {
        _showToast(newTag + " added!");
      });
    } else {
      _showToast("Already added!");
    }
  }

  Container displayNoTagsFoundScreen() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(Icons.tag, color: Colors.grey, size: 80.0),
            Text(
              "No Tag Found",
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
