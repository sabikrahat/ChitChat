import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:chitchat/models/post_model.dart';
import 'package:chitchat/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/pages/home_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class EditPost extends StatefulWidget {
  final PostModel postModel;

  const EditPost({Key key, this.postModel}) : super(key: key);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController descriptionTextEditingController =
      TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();
  TextEditingController tagTextEditingController = TextEditingController();
  bool _isLoading = false;
  var _description;
  var _location;
  var _tag;
  List<String> _tagList;

  @override
  void initState() {
    super.initState();

    descriptionTextEditingController.text = widget.postModel.description;
    locationTextEditingController.text = widget.postModel.location;
    tagTextEditingController.text = widget.postModel.tag;

    _description = widget.postModel.description;
    _location = widget.postModel.location;
    _tag = widget.postModel.tag;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: tagsReference.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: circularProgress());
        }
        _tagList = [];
        snapshot.data.docs.forEach((doc) {
          _tagList.add(doc['tagName'].toString());
        });
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Create Post"),
            actions: [
              InkWell(
                splashColor: Colors.white54,
                onTap: () {
                  setState(() {
                    _tag = tagTextEditingController.text
                        .toString()
                        .toLowerCase()
                        .trim();
                  });
                  if (_tag == null || _tag == "") {
                    _showSnackbar("You can't post without a tag");
                  } else {
                    _updateEditedInfoToFirestore();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      "Post",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _isLoading ? linearProgress() : Text(""),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
                  child: AutoCompleteTextField(
                    key: null,
                    controller: tagTextEditingController,
                    clearOnSubmit: false,
                    suggestions: _tagList,
                    decoration: InputDecoration(
                      labelText: "Tag",
                      hintText: "Enter a new tag...",
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 15.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    itemFilter: (item, query) {
                      return item.startsWith(query.toLowerCase());
                    },
                    itemSorter: (a, b) {
                      return a.compareTo(b);
                    },
                    itemSubmitted: (item) {
                      tagTextEditingController.text = item;
                    },
                    itemBuilder: (context, item) {
                      return ListTile(
                        leading: Icon(Icons.arrow_right),
                        title: Text("#" + item),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
                  child: TextField(
                    autofocus: false,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    controller: descriptionTextEditingController,
                    onChanged: (value) {
                      setState(() {
                        _description = value;
                      });
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo[400]),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Description",
                      labelText: "Add a description...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: locationTextEditingController,
                    onChanged: (value) {
                      setState(() {
                        _location = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Location",
                      labelText: "Enter location...",
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 15.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 6.0, bottom: 6.0, left: 10.0, right: 10.0),
                  child: Container(
                    width: size.width * 0.6,
                    height: 50.0,
                    alignment: Alignment.center,
                    // ignore: deprecated_member_use
                    child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                      color: Colors.green,
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Get my current location",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _getCurrentUserLocation,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 42.0,
                    width: double.infinity,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      color: Colors.indigo[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "Delete Post",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      onPressed: () {
                        _showBottomSheetDeleteOptions();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _showBottomSheetDeleteOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    "Do you really want to delete your post",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 1.8,
                      fontFamily: "Signatra",
                      fontSize: 27.0,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.delete_forever),
                  title: Text("Confirm Delete"),
                  onTap: () {
                    _deletePost();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.cancel),
                  title: Text("Cancel"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
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

  _getCurrentUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark mPlaceMark = placeMarks[0];

      // String completeAddress =
      //     "${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, " +
      //         "${mPlaceMark.subLocality}, ${mPlaceMark.locality}, " +
      //         "${mPlaceMark.subAdministrativeArea}, ${mPlaceMark.administrativeArea}, " +
      //         "${mPlaceMark.postalCode}, ${mPlaceMark.country}";

      String completeAddressInfo = "${mPlaceMark.thoroughfare}, " +
          "${mPlaceMark.subLocality}, ${mPlaceMark.locality}";

      // String specificAddress =
      //     "${mPlaceMark.subLocality}, ${mPlaceMark.locality}, ${mPlaceMark.country}";

      locationTextEditingController.text = completeAddressInfo;
      setState(() {
        _location = completeAddressInfo;
      });
    } catch (e) {
      _showSnackbar(e.toString());
    }
  }

  _updateEditedInfoToFirestore() async {
    setState(() {
      _isLoading = true;
    });

    tagsReference.doc(_tag).set({
      "tagName": _tag,
    });

    postsReference.doc(widget.postModel.postId).update({
      "description": _description ?? "",
      "location": _location ?? "",
      "tag": _tag,
    });

    var userTagList = currentUser.tags.toList();

    if (!userTagList.contains(_tag)) {
      userTagList.add(_tag);

      usersReference
          .doc(currentUser.uid)
          .update({
            "tags": userTagList,
          })
          .then((value) => print("One Post Updated"))
          .catchError((error) => print("Failed to update post: $error"));
    }
    setState(() {
      _isLoading = false;
    });

    _showSnackbar("Post edited successfully");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  _deletePost() async {
    setState(() {
      _isLoading = true;
    });

    postsReference
        .doc(widget.postModel.postId)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));

    usersReference
        .doc(currentUser.uid)
        .update({
          "totalPost": currentUser.totalPost - 1,
          "totalPoint": currentUser.totalPoint - 7,
        })
        .then((value) => print("One Post Updated"))
        .catchError((error) => print("Failed to update post: $error"));

    setState(() {
      _isLoading = false;
    });

    _showSnackbar("Post deleted successfully");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }
}
