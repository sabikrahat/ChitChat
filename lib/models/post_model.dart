import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String ownerId;
  final Timestamp timestamp;
  var likes = [];
  final String description;
  final String location;
  final String url;
  final String tag;

  PostModel({
    this.postId,
    this.ownerId,
    this.timestamp,
    this.likes,
    this.description,
    this.location,
    this.url,
    this.tag,
  });

  factory PostModel.fromDocument(DocumentSnapshot doc) {
    return PostModel(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      timestamp: doc['timestamp'],
      likes: doc['likes'],
      description: doc['description'],
      location: doc['location'],
      url: doc['url'],
      tag: doc['tag'],
    );
  }
}
