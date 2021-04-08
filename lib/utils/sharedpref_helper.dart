import 'package:chitchat/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userUidKey = "USER_UID_KEY";
  static String userProfileNameKey = "USER_PROFILE_NAME_KEY";
  static String userUsernameKey = "USERNAME_KEY";
  static String userPhotoUrlKey = "USER_PHOTO_URL_KEY";
  static String userEmailKey = "USER_EMAIL_KEY";
  static String userIntroKey = "USER_INTRO_KEY";
  static String userLocationKey = "USER_LOCATION_KEY";
  static String userTimeStampKey = "USER_TIME_STAMP_KEY";
  static String userTypeKey = "USER_TYPE_KEY";
  static String userStatusKey = "USER_STATUS_KEY";
  static String userTokenIdKey = "USER_TOKEN_ID_KEY";
  static String userTotalPostKey = "USER_TOTAL_POST_KEY";
  static String userTotalStarKey = "USER_TOTAL_STAR_KEY";
  static String userTotalPointKey = "USER_TOTAL_POINT_KEY";

  //save data
  Future<bool> saveUserUid(String userUid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userUidKey, userUid);
  }

  Future<bool> saveUserProfileName(String profileName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfileNameKey, profileName);
  }

  Future<bool> saveUserUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userUsernameKey, username);
  }

  Future<bool> saveUserPhotoUrl(String photoUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPhotoUrlKey, photoUrl);
  }

  Future<bool> saveUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, email);
  }

  Future<bool> saveUserIntro(String intro) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIntroKey, intro);
  }

  Future<bool> saveUserLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userLocationKey, location);
  }

  Future<bool> saveUserType(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userTypeKey, type);
  }

  Future<bool> saveUserStatus(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userStatusKey, status);
  }

  Future<bool> saveUserTokenId(String tokenId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userTokenIdKey, tokenId);
  }

  Future<bool> saveUserTotalPost(int totalPost) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(userTotalPostKey, totalPost);
  }

  Future<bool> saveUserTotalStar(int totalStar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(userTotalStarKey, totalStar);
  }

  Future<bool> saveUserTotalPoint(int totalPoint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(userTotalPointKey, totalPoint);
  }

  Future<bool> saveUserAllInfo(UserProfile userProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool temp;

    temp = await prefs.setString(userUidKey, userProfile.uid);
    if (!temp) {
      return false;
    }

    temp = await prefs.setString(userProfileNameKey, userProfile.profileName);
    if (!temp) {
      return false;
    }

    temp = await prefs.setString(userUsernameKey, userProfile.username);
    if (!temp) {
      return false;
    }

    temp = await prefs.setString(userPhotoUrlKey, userProfile.photoUrl);
    if (!temp) {
      return false;
    }

    temp = await prefs.setString(userEmailKey, userProfile.email);
    if (!temp) {
      return false;
    }

    temp = await prefs.setString(userIntroKey, userProfile.intro);
    if (!temp) {
      return false;
    }

    temp = await prefs.setString(userLocationKey, userProfile.location);
    if (!temp) {
      return false;
    }

    temp = await prefs.setString(userTypeKey, userProfile.type);
    if (!temp) {
      return false;
    }

    temp = await prefs.setString(userStatusKey, userProfile.status);
    if (!temp) {
      return false;
    }

    temp = await prefs.setString(userTokenIdKey, userProfile.tokenId);
    if (!temp) {
      return false;
    }

    temp = await prefs.setInt(userTotalPostKey, userProfile.totalPost);
    if (!temp) {
      return false;
    }

    temp = await prefs.setInt(userTotalStarKey, userProfile.totalStar);
    if (!temp) {
      return false;
    }

    temp = await prefs.setInt(userTotalPointKey, userProfile.totalPoint);
    if (!temp) {
      return false;
    }

    return temp;
  }

  //get data
  Future<String> getUserUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userUidKey);
  }

  Future<String> getUserProfileName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfileNameKey);
  }

  Future<String> getUserUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userUsernameKey);
  }

  Future<String> getUserPhotoUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPhotoUrlKey);
  }

  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String> getUserIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIntroKey);
  }

  Future<String> getUserLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userLocationKey);
  }

  Future<String> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userTypeKey);
  }

  Future<String> getUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userStatusKey);
  }

  Future<String> getUserTokenId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userTokenIdKey);
  }

  Future<int> getUserTotalPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userTotalPostKey);
  }

  Future<int> getUserTotalStar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userTotalStarKey);
  }

  Future<int> getUserTotalPoint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userTotalPointKey);
  }

  Future<UserProfile> getUserAllInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return UserProfile(
      uid: prefs.getString(userUidKey),
      profileName: prefs.getString(userProfileNameKey),
      username: prefs.getString(userUsernameKey),
      photoUrl: prefs.getString(userPhotoUrlKey),
      email: prefs.getString(userEmailKey),
      intro: prefs.getString(userIntroKey),
      location: prefs.getString(userLocationKey),
      timeStamp: null,
      type: prefs.getString(userTypeKey),
      status: prefs.getString(userStatusKey),
      tokenId: prefs.getString(userTokenIdKey),
      totalPost: prefs.getInt(userTotalPostKey),
      totalStar: prefs.getInt(userTotalStarKey),
      totalPoint: prefs.getInt(userTotalPointKey),
      tags: null,
    );
  }

  //clear data
  Future<void> clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
