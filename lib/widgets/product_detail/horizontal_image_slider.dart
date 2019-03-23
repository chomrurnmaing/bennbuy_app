
import 'package:bennbuy/screens/image_view.dart';
import 'package:flutter/material.dart';

class HorizontalImageSlider extends StatefulWidget {
  final List images;
  final Map variationProduct;
  final Map position;
  HorizontalImageSlider(this.images, this.variationProduct, this.position);
  
  @override
  State<StatefulWidget> createState() => _HorizontalImageSliderState();
}

class _HorizontalImageSliderState extends State<HorizontalImageSlider> {
  PageController _controller;
  List images;
  int selectedImage;
  int oldSelectedImage;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images = widget.images;
    oldSelectedImage = images.length > 1 ? 1 : 0;
    _controller = PageController(
      viewportFraction: 0.8,
      initialPage: images.length > 1 ? 1 : 0,
      keepPage: false,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if ( widget.variationProduct != null ) {
      if ( widget.position[widget.variationProduct['image_id'].toString()] != null && widget.position[widget.variationProduct['image_id'].toString()] != oldSelectedImage ) {
        setState(() {
          selectedImage = widget.position[widget.variationProduct['image_id'].toString()];
        });

        _controller.animateToPage(selectedImage, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
      }
    }

    return PageView.builder(
      controller: _controller,
      itemCount: images.length,
      itemBuilder: (BuildContext context, int i) {
        return Container(
          margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
          decoration: new BoxDecoration(
              color: Colors.white70
          ),
          child: InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context)=>ImageView(images, i)
                  )
              );
            },
            child: Image.network(
              images[i]['src'],
              fit: BoxFit.cover,
              height: 400,
            ),
          ),
        );
      },
    );
  }

}
