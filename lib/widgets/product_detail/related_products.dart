import 'dart:convert';

import 'package:bennbuy/widgets/products/horizontal_product_list.dart';
import 'package:flutter/material.dart';

class RelatedProducts extends StatefulWidget {
  final List relatedIds;

  RelatedProducts(this.relatedIds);

  @override
  State<StatefulWidget> createState() => _RelatedProductsState();
}

class _RelatedProductsState extends State<RelatedProducts>{
  String url;
  String ids = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if ( widget.relatedIds.length > 0 ){
      url = 'https://bennbuy.com/wp-json/wc/v3/products?include=${json.encode(widget.relatedIds)},&consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2';
    }

    if(!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.relatedIds.length > 0) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text('RELATED PRODUCTS',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
            child: Divider(),
          ),

          Container(
              height: 300.0,
              child: HorizontalProductList(url)
          )
        ],
      );
    } else {
      return Container();
    }


  }
}