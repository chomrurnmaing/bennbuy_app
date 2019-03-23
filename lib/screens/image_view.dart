import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageView extends StatefulWidget {
  final List images;
  final int viewIndex;

  ImageView(this.images, this.viewIndex);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  int i;
  PageController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new PageController(
      initialPage: widget.viewIndex,
    );
    i = widget.viewIndex + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(i, widget.images.length),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: PhotoViewGallery(
          onPageChanged: (index){
            setState(() {
              i = index + 1;
            });
          },
          pageController: controller,
          backgroundDecoration: BoxDecoration(
            color: Colors.white
          ),
          pageOptions: widget.images.map((image){
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(image['src']),
              maxScale: PhotoViewComputedScale.contained * 2,
              minScale: PhotoViewComputedScale.contained,
              initialScale: PhotoViewComputedScale.contained,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAppBar(index, count){
    return AppBar(
      title: Text('$index of $count'),
    );
  }
}
