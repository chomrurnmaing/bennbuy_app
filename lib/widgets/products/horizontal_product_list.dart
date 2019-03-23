import 'package:bennbuy/models/product.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../widgets/custom_widgets.dart';
import '../../methods.dart';

class HorizontalProductList extends StatefulWidget {

  final String url;

  HorizontalProductList(this.url);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HorizontalProductListState();
  }
}

class _HorizontalProductListState extends State<HorizontalProductList>
    with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
        future: getProducts(widget.url),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = snapshot.data;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index){
                  return Container(
                      margin: EdgeInsets.only(
                        left: index == 0 ? 10.0 : 0,
                        right: index == products.length - 1 ? 10.0 : 0
                      ),
                      width: 180.0,
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Card(
                              elevation: 0.5,
                              semanticContainer: true,
                              shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: CachedNetworkImage(
                                      imageUrl: products[index].images.isNotEmpty ? getThumbnail(products[index].images[0]['src'], '300x300') : 'https://bennbuy.com/wp-content/uploads/2019/02/default-image.png',
                                      placeholder: Image.asset('assets/images/default-image.png', fit: BoxFit.cover, width: 180, height: 200,),
                                      errorWidget: new Icon(Icons.error),
                                      height: 200.0,
                                      width: 180.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    height: 25.0,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    child: Text(
                                      products[index].title,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      buildRegularPrice(products[index]),
                                      buildSalePrice(products[index])
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Material(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/product-detail/${products[index].id}');
                                    },
                                  ),
                                )),
                          ),
                        ],
                      ));
                });
          } else if (snapshot.hasError) {
            return new Container(
              alignment: Alignment.center,
              child: Text('Sorry, something went wrong!'),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: SizedBox(
                child: CircularProgressIndicator(strokeWidth: 2,),
              ),
            );
          }
        },
      );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
