import 'dart:io';
import 'package:chitchat/widgets/ProgressWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:chitchat/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image/image.dart' as ImD;
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  File _file;
  String postId = currentUser.uid;
  TextEditingController usernameTextEditingController;
  TextEditingController profileNameTextEditingController;
  TextEditingController introTextEditingController;
  TextEditingController locationTextEditingController;
  bool _isLoading = false;
  var _username;
  var _profileName;
  var _intro;
  var _location;

  @override
  void initState() {
    super.initState();
    usernameTextEditingController = TextEditingController();
    profileNameTextEditingController = TextEditingController();
    introTextEditingController = TextEditingController();
    locationTextEditingController = TextEditingController();

    usernameTextEditingController.text = currentUser.username;
    profileNameTextEditingController.text = currentUser.profileName;
    introTextEditingController.text = currentUser.intro;
    locationTextEditingController.text = currentUser.location;

    _username = currentUser.username;
    _profileName = currentUser.profileName;
    _intro = currentUser.intro;
    _location = currentUser.location;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: [
          InkWell(
            splashColor: Colors.white54,
            onTap: () {
              setState(
                () {
                  if (_formKey.currentState.validate()) {
                    _saveEditedInfoToFirestore();
                  }
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  "Save",
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: InkWell(
                  splashColor: Colors.indigo[400],
                  onTap: _takeImageOption,
                  child: Hero(
                    tag: Key(currentUser.uid),
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 8.0),
                      width: size.width * 0.4,
                      height: size.width * 0.4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _file == null
                              ? CachedNetworkImageProvider(currentUser.photoUrl)
                              : FileImage(_file),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 6.0, left: 10.0, right: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: usernameTextEditingController,
                  // ignore: deprecated_member_use
                  autovalidate: true,
                  validator: (error) {
                    if (error.isEmpty) {
                      return "Please enter your username";
                    } else if (error.trim().length < 3) {
                      return "username is very short";
                    } else if (error.trim().length > 15) {
                      return "username is very long";
                    } else if (error.contains(" ")) {
                      return "username can't contain any space";
                    } else if (error.toLowerCase() != error) {
                      return "username can't contain any capital letter";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _username = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Username",
                    hintText: "Enter your username...",
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
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: profileNameTextEditingController,
                  validator: (error) {
                    if (error.isEmpty) {
                      return "Please enter your full name";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _profileName = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Enter your full name...",
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
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: introTextEditingController,
                  validator: (error) {
                    if (error.length > 250) {
                      return "Too long...";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _intro = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Intro",
                    hintText: "Give a short intro about you...",
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
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: locationTextEditingController,
                  validator: (error) {
                    if (error.isEmpty) {
                      return "Please enter your location or type anything";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _location = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Location",
                    hintText: "Enter your lication...",
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
                    onPressed: getCurrentUserLocation,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                child: _isLoading ? linearProgress() : Text(""),
              )
            ],
          ),
        ),
      ),
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

  _takeImageOption() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Change Phofile Image",
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

  getCurrentUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark mPlaceMark = placeMarks[0];

      // String completeAddressInfo =
      //     "${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, " +
      //         "${mPlaceMark.subLocality}, ${mPlaceMark.locality}, " +
      //         "${mPlaceMark.subAdministrativeArea}, ${mPlaceMark.administrativeArea}, " +
      //         "${mPlaceMark.postalCode}, ${mPlaceMark.country}, ";

      String specificAddress =
          "${mPlaceMark.subLocality}, ${mPlaceMark.locality}, ${mPlaceMark.country}";

      locationTextEditingController.text = specificAddress;
      setState(() {
        _location = specificAddress;
      });
    } catch (e) {
      _showSnackbar(e.toString());
    }
  }

  _saveEditedInfoToFirestore() async {
    setState(() {
      _isLoading = true;
    });

    if (_file != null) {
      await _compressingPhoto();

      String _downloadUrl = await uploadPhoto(_file);

      usersReference.doc(currentUser.uid).update({
        "username": _username,
        "profileName": _profileName,
        "photoUrl": _downloadUrl,
        "intro": _intro ?? "",
        "location": _location ?? "No location selected yet",
      });
    } else {
      usersReference.doc(currentUser.uid).update({
        "username": _username,
        "profileName": _profileName,
        "intro": _intro ?? "",
        "location": _location ?? "No location selected yet",
      });
    }

    setState(() {
      _isLoading = false;
    });

    _showSnackbar("Profile updated successfully");
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
    var reference = storageReference.child("post_$postId.jpg");
    await reference.putFile(mImageFile);
    String downloadUrl = await reference.getDownloadURL();
    return downloadUrl;
  }
}
