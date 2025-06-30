import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PetImageViewer extends StatelessWidget {
  final String imageUrl;
  const PetImageViewer({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
