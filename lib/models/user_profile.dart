import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String profileName;
  final String username;
  final String photoUrl;
  final String email;
  final String intro;
  final String location;
  final Timestamp timeStamp;
  final String type;
  final String status;
  final String tokenId;
  final int totalPost;
  final int totalStar;
  final int totalPoint;
  var tags = [];

  UserProfile({
    this.uid,
    this.profileName,
    this.username,
    this.photoUrl,
    this.email,
    this.intro,
    this.timeStamp,
    this.location,
    this.type,
    this.status,
    this.tokenId,
    this.totalPost,
    this.totalStar,
    this.totalPoint,
    this.tags,
  });

  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
      uid: doc['uid'],
      profileName: doc['profileName'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
      email: doc['email'],
      intro: doc['intro'],
      location: doc['location'],
      timeStamp: doc['timeStamp'],
      type: doc['type'],
      status: doc['status'],
      tokenId: doc['tokenId'],
      totalPost: doc['totalPost'],
      totalStar: doc['totalStar'],
      totalPoint: doc['totalPoint'],
      tags: doc['tags'],
    );
  }
}
