import 'package:bennbuy/helpers/authentication.dart';
import 'package:bennbuy/methods.dart';
import 'package:bennbuy/screens/checkout_screen.dart';
import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with AutomaticKeepAliveClientMixin<CartScreen> {

  bool addToWishLoaded;
  bool removeLoaded;
  bool wishListAdded = false;
  bool gotCartTotal;

  Map cartTotal = new Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gotCartTotal = false;
    getCartTotal();

    if(!mounted) return;
  }

  void getCartTotal(){
    getCarts().then((response){
      double sumup = 0;
      List carts = List();
      if ( response.length > 0 ) {
        for(var cart in response['cart_list']){
          sumup += double.parse(cart['cart']['qty']) * double.parse(cart['product']['price']);
          carts.add(cart['cart']);
        }

        if ( response.length > 0 ) {
          setState(() {
            gotCartTotal = true;
          });
        }

        setState(() {
          cartTotal['subtotal'] = sumup;
          cartTotal['shipping_title'] = response['shipping']['title'];
          cartTotal['shipping'] = double.parse(response['shipping']['cost']);
          cartTotal['total'] = sumup + double.parse(response['shipping']['cost']);
          cartTotal['items'] = carts;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Container(
        alignment: Alignment.center,
        child: FutureBuilder(
          future: getCarts(),
          builder: (context, snap){
            if ( snap.hasData ) {
              if ( snap.data == 404 ) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Your cart is empty.', style: TextStyle(fontWeight: FontWeight.w600),),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                      width: 140,
                      child: primaryButton('Return to Shop', (){Navigator.pushNamed(context, '/main-screen/0');}, fontSize: 14),
                    )
                  ],
                );
              } else {
                List carts = snap.data['cart_list'];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: carts.length,
                          itemBuilder: (context, index) {
                            // return Container();
                            return _buildCartItem(carts[index]);
                          }
                      ),
                    ),
                    _buildCartTotals()
                  ],
                );
              }
            } else if (snap.hasError){
              return Container();
            } else {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future getCarts() async{
    String url = 'https://bennbuy.com/wp-json/cart/v3/get?device_id=${Authentication.deviceId}';

    var response = await http.get(url);

    if ( response.statusCode == 200 ) {
      return json.decode(response.body);
    } else if ( response.statusCode == 404 ) {
      return response.statusCode;
    } else {
      throw 'Error';
    }

  }

  Future<Null> _onRefresh() async{
    setState(() {
      getCarts();
    });
    await Future.delayed(Duration(seconds: 2));

    return null;
  }

  void _onProceedCheckout(){

    if(Authentication.isLogin) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(cart: cartTotal)));
      return;
    }

    showModalBottomSheet<void>(
      context: context, builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 140,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 15),
                child: Text('Sign in to check out.',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(child: RaisedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/acc-management/0/true');
                    },
                    color: Colors.black,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Text( 'Returning Customer' ),
                  )),
                  SizedBox(width: 10,),
                  Expanded(child: RaisedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/acc-management/1/true');
                    },
                    color: Colors.white,
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(0)),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Text( 'New Customer' ),
                  )),
                ],
              )
            ],
          ),
        );
    });
  }

  Widget _buildCartTotals(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      child: RaisedButton(
        onPressed: gotCartTotal ? _onProceedCheckout : null,
        child: Text('Proceed to Checkout',
          style: TextStyle(
              fontSize: 18,
              letterSpacing: 1
          ),
        ),
        color: Colors.black,
        textColor: Colors.white,
        elevation: 0,
      ),
    );
  }

  Widget _buildCartItem( Map cart ){
    Map attrs = new Map();
    List items = new List();

    if ( cart['attributes'] is Map) {
      attrs = cart['attributes'];
    }

    if ( attrs.isNotEmpty ) {
      attrs.forEach((k, v){
        items.add({k: v});
      });
    }

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
            )
          ]
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 140,
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: <Widget>[
                  FadeInImage(
                    placeholder: AssetImage('assets/images/default-image.png'),
                    image: NetworkImage(cart['feature_src'],),
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 5,),
                  wishListAdded ? flatButton('View wish list', _viewWishList, true, bgColor: Colors.black, txtColor: Colors.white) : flatButton('Add to wish list', (){_addToWishList(cart['product']['id']); }, addToWishLoaded ?? true, bgColor: Colors.black, txtColor: Colors.white),
                  flatButton('Remove', (){_removeCartItem(int.parse(cart['cart']['id']));}, removeLoaded ?? true),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 5, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, '/product-detail/${cart['product']['id']}/${cart['cart']['variation_id']}');
                        },
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                cart['product']['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),

                            Container(
                              alignment: Alignment.centerRight,
                              width: 30,
                              child: Icon(Icons.navigate_next),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox( height: 8,),
                    Table(
                      columnWidths: {1: FractionColumnWidth(.58)},
                      children: [
                        TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Text('Unit Price: '),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Text('\$${cart['product']['price']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  )
                                ),
                              )
                            ]
                        ),
                      ],
                    ),
                    Table(
                      columnWidths: {1: FractionColumnWidth(.58)},
                      children: [
                        TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Text('Quantity: '),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Text(cart['cart']['qty'].toString()),
                              )
                            ]
                        ),
                      TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Text('Total: '),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Text('\$${double.parse(cart['cart']['qty']) * double.parse(cart['product']['price'])}'),
                            )
                          ]
                      ),
                      ],
                    ),
                    Divider(),
                    items.length > 0 ? Table(
                      columnWidths: {1: FractionColumnWidth(.58)},
                      children: items.map((attribute){
                        return TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Text('${getNameAttributeKey(attribute)}: '),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Text(attribute[getAttributeKey(attribute)]),
                              )
                            ]
                        );
                      }).toList(),
                    ) : Container(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _removeCartItem(int cartId){
    confirmationDialog(context, 'Are you sure?', actions: [
      FlatButton(onPressed: (){Navigator.pop(context);}, child: Text('No')),
      FlatButton(onPressed: (){
          Navigator.pop(context);
          setState(() {
            gotCartTotal = false;
          });
          http.delete('https://bennbuy.com/wp-json/cart/v3/$cartId').then((response){

            getCartTotal();
            var snackbar = new SnackBar(content: Text('Item removed.'));
            if ( response.statusCode != 200 ) {
              snackbar = new SnackBar(content: Text('Ops, Something went wrong!'), backgroundColor: Colors.red,);
            }

            Scaffold.of(context).showSnackBar(snackbar);

          });
        },
        child: Text('Yes'),
      )
    ]);

  }

  _addToWishList( int productId ){
    setState(() {
      addToWishLoaded = false;
    });
    addToWishList( productId ).then((response){
      setState(() {
        addToWishLoaded = true;
      });

      if (response['status'] == 404){
        setState(() {
          wishListAdded = false;
        });
      } else if( response['status'] == 200 ) {
        setState(() {
          wishListAdded = true;
        });
      }
    });
  }

  _viewWishList(){
    Navigator.popAndPushNamed(context, '/main-screen/3');
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
