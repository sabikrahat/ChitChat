import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String ownerId;
  final String likerId;
  final String leadingUrl;
  final String data;
  final Timestamp timestamp;
  final String postId;
  final String trailingUrl;

  NotificationModel({
    this.ownerId,
    this.likerId,
    this.leadingUrl,
    this.data,
    this.timestamp,
    this.postId,
    this.trailingUrl,
  });

  factory NotificationModel.fromDocument(DocumentSnapshot doc) {
    return NotificationModel(
      ownerId: doc['ownerId'],
      likerId: doc['likerId'],
      leadingUrl: doc['leadingUrl'],
      data: doc['data'],
      timestamp: doc['timestamp'],
      postId: doc['postId'],
      trailingUrl: doc['trailingUrl'],
    );
  }
}
