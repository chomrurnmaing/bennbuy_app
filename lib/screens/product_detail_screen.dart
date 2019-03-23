import 'package:bennbuy/helpers/authentication.dart';
import 'package:bennbuy/methods.dart';
import 'package:bennbuy/widgets/bottom_nav_bar.dart';
import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:bennbuy/widgets/product_detail/create_review_form.dart';
import 'package:bennbuy/widgets/product_detail/entry_summary.dart';
import 'package:bennbuy/widgets/product_detail/product_content.dart';
import 'package:bennbuy/widgets/product_detail/product_reviews.dart';
import 'package:bennbuy/widgets/product_detail/related_products.dart';
import 'package:bennbuy/widgets/product_detail/slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../widgets/header/main_appbar.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  final int variationId;

  ProductDetailScreen({this.productId, this.variationId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Dio dio = new Dio();
  String url;
  Connectivity _connectivity = Connectivity();
  String selectedColor;
  Map attributes = {};
  Map variationProduct;
  bool reloadVariation = false;

  void onReloadVariation(bool status){
    setState(() {
      reloadVariation = status;
    });
  }

  Future<Product> _getProduct() async{
    final response = await dio.get(url);

    if ( response.statusCode == 200 ) {
      return Product.fromJson(response.data);
    } else {
      throw 'Something went wrong.';
    }

  }

  void setAttributeValue(String key, String value) {
    setState(() {
      attributes[key] = value;
      reloadVariation = true;
    });

    getProductByAttrs(widget.productId, attributes).then((response){
      setState(() {
        reloadVariation = false;
        variationProduct = response;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if ( widget.variationId != 0 ) {
      url = 'https://bennbuy.com/wp-json/wc/v3/products/${widget.variationId}?consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2';
    } else{
      url = 'https://bennbuy.com/wp-json/wc/v3/products/${widget.productId}?consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2';
    }
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result){
      if( result == ConnectivityResult.none ){
        internetConnectionAlert(context);
      }
    });

    if ( Authentication.isLogin ) {
      createYourLookItem(widget.productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(),
        body: SafeArea(
          child: FutureBuilder<Product>(
              future: _getProduct(),
              builder: (context, snapshot) {
                if ( snapshot.hasData ) {
                  Product product = snapshot.data;
                  return Column(
                    children: <Widget>[
                      AnimatedCrossFade(
                          firstChild: SizedBox(
                            height: 2,
                            child: LinearProgressIndicator( valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),  ),
                          ),
                          secondChild: SizedBox(
                            height: 0,
                          ),
                          crossFadeState: reloadVariation ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          duration: Duration(milliseconds: 250)),
                      Expanded(
                        child: CustomScrollView(
                          slivers: <Widget>[
                            MainAppBar(),
                            SliverList(
                                delegate: SliverChildListDelegate([
                                  DetailSlider( product, variationProduct ),
                                  _buildColorFilter(product.attributes),
                                  EntrySummary( product, setAttributeValue, variationProduct, onReloadVariation, widget.variationId ),
                                  ProductContent( product.description ),
                                  CreateReviewForm(rating: double.parse(product.averageRating), ratingCount: product.ratingCount, productId: product.id),
                                  product.ratingCount != 0 ? ProductReviews(product.id, product.ratingCount) : Container(),
                                  RelatedProducts( product.relatedIds ),
                                ])),
                          ],
                        ),
                      )
                    ],
                  );

                } else if(snapshot.hasError) {

                  return Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Oops, something went wrong.'),
                        Text('Please scroll down to refresh that page.')
                      ],
                    ),
                  );

                }else {

                  return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );

                }
              }),
        ),
      ),
    );
  }

  Widget _buildColorFilter(List attributes){
    if( attributes.isNotEmpty && widget.variationId == 0 ){
      for (var attr in attributes){
        if( attr['name'].toLowerCase() == 'color' ) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ListView.builder(
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemCount: attr['options'].length,
              itemBuilder: (context, i){
                return Container(
                  width: 50,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: selectedColor == attr['options'][i] ? getColorNamed(attr['options'][i]) : Colors.grey[300], width: 3),
                    borderRadius: BorderRadius.circular(25)
                  ),
                  child: RaisedButton(
                    padding: EdgeInsets.all(0),
                    color: getColorNamed(attr['options'][i]),
                    disabledColor: getColorNamed(attr['options'][i]),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
                    onPressed: selectedColor != attr['options'][i] ? (){
                      setState(() {
                        selectedColor = attr['options'][i];
                      });
                      setAttributeValue('color', attr['options'][i].toLowerCase());
                    } : null,
                  ),
                );
              },
            ),
          );
        }
      }
      return Container();
    } else {
      return Container();
    }
  }
}
