import 'package:bennbuy/models/product.dart';
import 'package:bennbuy/widgets/product_detail/horizontal_image_slider.dart';
import 'package:flutter/material.dart';

class DetailSlider extends StatefulWidget {

  final Product product;
  final Map variationProduct;
  DetailSlider(this.product, this.variationProduct);

  @override
  _DetailSliderState createState() => _DetailSliderState();
}

class _DetailSliderState extends State<DetailSlider> with TickerProviderStateMixin<DetailSlider> {
  List images;
  Map imagePosition = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images = widget.product.images;
    int i = 0;
    for( Map image in images ){
      imagePosition[image['id'].toString()] = i;
      i++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          height: 400.0,
          child: HorizontalImageSlider(images, widget.variationProduct, imagePosition)
      )
    );
  }

}
