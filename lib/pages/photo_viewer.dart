import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewer extends StatelessWidget {
  final String photoUrl;

  const ImagePreviewer({
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Hero(
        tag: photoUrl,
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(photoUrl),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
          enableRotation: false,
          backgroundDecoration: BoxDecoration(
            color: Colors.grey[900],
          ),
          loadingBuilder: (context, event) => Center(child: circularProgress()),
        ),
      ),
    );
  }
}
