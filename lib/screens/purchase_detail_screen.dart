import 'package:bennbuy/methods.dart';
import 'package:bennbuy/models/order.dart';
import 'package:bennbuy/widgets/bottom_nav_bar.dart';
import 'package:bennbuy/widgets/header/seamless_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PurchaseDetailScreen extends StatefulWidget {
  final Order order;
  PurchaseDetailScreen(this.order);

  @override
  _PurchaseDetailScreenState createState() => _PurchaseDetailScreenState();
}

class _PurchaseDetailScreenState extends State<PurchaseDetailScreen> {
  List _products = new List();
  List<int> _productsId = new List();
  Map thumbnails;

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _products = widget.order.lineItems;

    for ( var product in _products ){
      if ( product['variation_id'] != 0 ) {
        _productsId.add(product['variation_id']);
      } else {
        _productsId.add(product['product_id']);
      }

    }

    getProductThumbnails(_productsId).then((response){
      setState(() {
        thumbnails = response;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    String itemCount = widget.order.lineItems.length.toString() + ( widget.order.lineItems.length > 1 ? ' items' : ' item' );
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      appBar: seamlessAppBar( context, orderTitle: '#${widget.order.number}' ),
      body: ListView(
        children: <Widget>[

          _buildHeading( 'ORDER DETAILS - ${dateConverter(widget.order.dateCreated)}' ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[200]),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Subtotal ($itemCount)',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text('\$' + widget.order.total,
                        style: TextStyle(
                            fontSize: 16
                        ),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Shipping',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text('\$' + widget.order.shippingTotal,
                        style: TextStyle(
                            fontSize: 16
                        ),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Total',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text('\$' + widget.order.total,
                        style: TextStyle(
                          fontSize: 16
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          _buildHeading( 'Products'.toUpperCase() ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[200]),
            ),

            child: thumbnails != null ? Column(
              children: _products.map((product){
                String id = product['product_id'].toString();

                if ( product['variation_id'] != 0 ) id = product['variation_id'].toString();

                return Container(
                  height: 130,
                  margin: EdgeInsets.only(bottom: 5, top: 5),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 120,
                              height: 130,
                              child: CachedNetworkImage(
                                imageUrl: thumbnails[id] ?? '',
                                placeholder: Image.asset('assets/images/default-image.png', height: 150, width: double.infinity, fit: BoxFit.cover,),
                                errorWidget: Image.asset('assets/images/default-image.png', height: 150, width: double.infinity, fit: BoxFit.cover,),
                                fit: BoxFit.cover,
                              ),
                            ),

                            Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(product['name'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 80,
                                            child: Text('Price:',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey
                                              ),
                                            ),
                                          ),
                                          Text('\$${product['price']}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 80,
                                            child: Text('Quantity:',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey
                                              ),
                                            ),
                                          ),
                                          Text(product['quantity'].toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 80,
                                            child: Text('Total:',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey
                                              ),
                                            ),
                                          ),
                                          Text('\$${product['total']}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            ),

                            Container(
                              alignment: Alignment.topRight,
                              width: 30,
                              child: Icon(Icons.navigate_next, size: 26,),
                            )
                          ],
                        ),
                      ),

                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: (){},
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ) : Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(25),
              width: 120,
              height: 120,
              child: CircularProgressIndicator(strokeWidth: 2,),
            ),
          ),

          _buildHeading( 'Zipping Details'.toUpperCase() ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[200]),
            ),

            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 120,
                      child: Text('Status', style: TextStyle(fontSize: 16),),
                    ),
                    Text(widget.order.status, style: TextStyle(fontSize: 16),)
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 120,
                      child: Text('Zip to', style: TextStyle(fontSize: 16),),
                    ),
                    Expanded(child: Text(widget.order.shippingAddress1, style: TextStyle(fontSize: 16),))
                  ],
                )
              ],
            ),
          ),

          _buildHeading( 'Payment Method'.toUpperCase() ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[200]),
            ),

            child: Text(widget.order.paymentMethodTitle, style: TextStyle(fontSize: 16)),
          )
        ],
      ),
    );
  }

  Widget _buildHeading( String heading ){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(heading,
        style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14
        ),
      ),
    );
  }

}
