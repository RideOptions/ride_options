import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../Component/theme/app_theme.dart';

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  FullScreenImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Full Image View"),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl), // Provide your network image URL here
      ),
    );
  }
}
