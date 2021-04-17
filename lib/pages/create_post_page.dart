import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:chitchat/pages/home_page.dart';
import 'package:chitchat/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;
import 'package:uuid/uuid.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File _file;
  TextEditingController descriptionTextEditingController;
  TextEditingController locationTextEditingController;
  TextEditingController tagTextEditingController;
  bool _isLoading = false;
  var _description;
  var _location;
  var postId;
  var _tag;
  List<String> _tagList;

  @override
  void initState() {
    super.initState();
    descriptionTextEditingController = TextEditingController();
    locationTextEditingController = TextEditingController();
    tagTextEditingController = TextEditingController();
    postId = Uuid().v4();
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
                    if (_file == null) {
                      _showSnackbar("You can't post empty content.");
                    } else {
                      if (_tag == null || _tag == "") {
                        _showSnackbar("You can't post without a tag");
                      } else {
                        _saveInfoToFirestore();
                      }
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
                    padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                    child: _file == null
                        ? Center(
                            child: Container(
                              width: size.width * 0.5,
                              // ignore: deprecated_member_use
                              child: OutlineButton(
                                onPressed: _takeImageOption,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        //child: Icon(Icons.photo_library_outlined),
                                        child: Icon(
                                            Icons.add_photo_alternate_outlined),
                                      ),
                                      Text("Add Photo"),
                                    ],
                                  ),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.indigo[400]),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: size.height * 0.4,
                            child: InkWell(
                              splashColor: Colors.indigo[400],
                              onTap: _takeImageOption,
                              child: Image.file(_file),
                            ),
                          ),
                  ),
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
                ],
              ),
            ),
          );
        });
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

  _takeImageOption() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Add a photo",
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 1.8,
              fontFamily: "Signatra",
              fontSize: 27.0,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: SimpleDialogOption(
                child: Text(
                  "Capture Image with Camera",
                ),
                onPressed: _captureImageWithCamera,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: SimpleDialogOption(
                child: Text(
                  "Select Image from Gallery",
                ),
                onPressed: _pickImageFromGallery,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: SimpleDialogOption(
                child: Text(
                  "Cancel",
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
    );
  }

  _captureImageWithCamera() async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    _file = await ImagePicker.pickImage(source: ImageSource.camera);

    //crop image
    if (_file != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: _file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Crop",
          toolbarColor: Colors.indigo[400],
          toolbarWidgetColor: Colors.grey[350],
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      );
      if (croppedFile != null) {
        setState(() {
          _file = File(croppedFile.path);
        });
      }
    } else {
      setState(() {
        this._file = _file;
      });
    }
  }

  _pickImageFromGallery() async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    _file = await ImagePicker.pickImage(source: ImageSource.gallery);

    //crop image
    if (_file != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: _file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Crop",
          toolbarColor: Colors.indigo[400],
          toolbarWidgetColor: Colors.grey[350],
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      );
      if (croppedFile != null) {
        setState(() {
          _file = File(croppedFile.path);
        });
      }
    } else {
      setState(() {
        this._file = _file;
      });
    }
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

  _saveInfoToFirestore() async {
    setState(() {
      _isLoading = true;
    });

    await _compressingPhoto();

    String _downloadUrl = await uploadPhoto(_file);

    tagsReference.doc(_tag).set({
      "tagName": _tag,
    });

    postsReference.doc(postId).set({
      "postId": postId,
      "ownerId": currentUser.uid,
      "timestamp": DateTime.now(),
      "likes": [],
      "description": _description ?? "",
      "location": _location ?? "",
      "url": _downloadUrl,
      "tag": _tag,
    });

    var userTagList = currentUser.tags.toList();
    if (!userTagList.contains(_tag)) {
      userTagList.add(_tag);
    }
    usersReference
        .doc(currentUser.uid)
        .update({
          "totalPost": currentUser.totalPost + 1,
          "totalPoint": currentUser.totalPoint + 5,
          "tags": userTagList,
        })
        .then((value) => print("One Post Updated"))
        .catchError((error) => print("Failed to update post: $error"));

    setState(() {
      _isLoading = false;
    });

    _showSnackbar("Post uploaded successfully");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  _compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(_file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 70));
    setState(() {
      _file = compressedImageFile;
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    var reference =
        postStorageReference.child(currentUser.uid).child("post_$postId.jpg");
    await reference.putFile(mImageFile);
    String downloadUrl = await reference.getDownloadURL();
    return downloadUrl;
  }
}
