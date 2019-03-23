import 'package:bennbuy/helpers/authentication.dart';
import 'package:bennbuy/helpers/cart_helper.dart';
import 'package:bennbuy/methods.dart';
import 'package:bennbuy/models/product.dart';
import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:share/share.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;

class EntrySummary extends StatefulWidget {

  final Product product;
  final Function changeAttr;
  final Map variationProduct;
  final Function reloadVariation;
  final int variationId;

  EntrySummary(this.product, this.changeAttr, this.variationProduct, this.reloadVariation, this.variationId);

  @override
  _EntrySummaryState createState() => _EntrySummaryState();
}

class _EntrySummaryState extends State<EntrySummary> with TickerProviderStateMixin {
  HtmlUnescape unescape = new HtmlUnescape();
  int count;
  bool showViewCart = false;
  bool btnLoaded = true;
  List<String> _value;
  List attributes;
  bool addedToWishList;
  bool reloadVariation = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addedToWishList = false;
    attributes = widget.product.attributes;
    count=1;
    _value = new List(attributes.length);

    if ( !mounted ) return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildTitle(),
                        _buildCategory(),
                        Row(
                          children: <Widget>[
                            SmoothStarRating(
                              size: 20,
                              allowHalfRating: true,
                              borderColor: Colors.black,
                              rating: double.parse(widget.product.averageRating) ?? 0.0,
                              color: Colors.black,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('${widget.product.ratingCount} Reviews',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey
                                  )),
                            ),
                            widget.product.stockStatus == 'outofstock' ? Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.warning, color: Colors.red, size: 12,),
                                    SizedBox(width: 5,),
                                    Text('Out of stock', style: TextStyle(
                                        color: Colors.red
                                    ),)
                                  ],
                                ),
                              ),
                            ) : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, top: 10),
                  width: 84,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      _buildCountingButton(count),
                      SizedBox(height: 5,),
                      _buildReqularPrice(),
                      _buildSalePrice(),
                    ],),
                )
              ],
            ),
          ),

          widget.variationId == 0 ? _attributesFilter() : Container(),

          SizedBox(height: 10,),
          primaryButtonWithLoading('Add to cart', count > 0 && widget.product.stockStatus == 'instock' ? _onAddToCart : null, btnLoaded, vsync: this),
          showViewCart ? SizedBox(height: 10,) : Container(),
          _buildViewCartButton(),
          _buildMetaItems( widget.product.id )
        ],
      ),
    );
  }


  void _onAddToCart() {
    setState(() {
      btnLoaded = false;
    });

    http.post('https://bennbuy.com/wp-json/cart/v3/create', body: {
      'device_id': Authentication.deviceId,
      'product_id': widget.product.id.toString(),
      'variation_id': widget.variationProduct != null ? widget.variationProduct['id'].toString() : '0',
      'qty': this.count.toString()
    }).then((response){

      getCartCount().then((data){
        setState(() {
          if ( data['cart_count'] != null ) {
            CartHelper.cartCount = int.parse( data['cart_count'] );
          } else {
            CartHelper.cartCount = 0;
          }
        });
      });

      setState(() {
        btnLoaded = true;
      });
      if( response.statusCode == 200 ){
        final snackBar = SnackBar(content: Row(
          children: <Widget>[
            Text('This product has been added to your cart.'),
            SizedBox(width: 5,),
            Icon(Icons.check_circle, size: 14,)
          ],
        ));
        Scaffold.of(context).showSnackBar(snackBar);
        setState(() {
          showViewCart = true;
        });
      } else {
        final snackBar = SnackBar(content: Text('Sorry, something was wrong, please try to add this product again.'), duration: Duration(seconds: 4), backgroundColor: Colors.red,);
        Scaffold.of(context).showSnackBar(snackBar);

        setState(() {
          showViewCart = false;
        });
      }

    });
  }

  List<Widget> _getDropdownMenuItems(){
    List<Widget> menuItems = new List();

    for(int i = 0; i < attributes.length; i++){

      if ( attributes[i]['name'] != 'Color') {
        List<DropdownMenuItem<String>> items = new List();

        for(String item in attributes[i]['options']){
          items.add(DropdownMenuItem(
              value: item,
              child: new Text(item)
          ));
        }
        menuItems.add(Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300])
          ),
          padding: EdgeInsets.only( left: 5, right: 5 ),
          margin: EdgeInsets.only(bottom: 10),
          width: MediaQuery.of(context).size.width-30,
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                onChanged: (val){
                  widget.changeAttr(attributes[i]['name'].toLowerCase(), val.toLowerCase());
                  setState(() {
                    _value[i] = val;
                  });
                },
                value: _value[i] ?? attributes[i]['options'][0],
                items: items,
              )),
        ));
      }
    }

    return menuItems;
  }

  _attributesFilter(){
    if ( attributes.length != 0  ){
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _getDropdownMenuItems()
      );
    } else {
      return Container();
    }

  }
  
  void _incrementCount(){
    setState(() {
      this.count += 1;
    });
  }

  void _decrementCount(){
    setState(() {
      this.count -= 1;
    });
  }

  Widget _buildCategory() {
    var categories = widget.product.categories;
    if ( categories.length > 0 ) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Text(
          unescape.convert(categories[categories.length - 1]['name']),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 16
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        widget.product.title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildReqularPrice(){

    if( widget.product.regularPrice != null && widget.product.regularPrice != '' && widget.variationProduct == null  ) {
      return Text(
        '\$' + widget.product.regularPrice,
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16,
            color: Colors.grey,
            decoration: TextDecoration.lineThrough
        ),
      );
    } else if ( widget.variationProduct != null && widget.variationProduct['regular_price'] != '' ) {
      return Text(
        '\$' + widget.variationProduct['regular_price'],
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16,
            color: Colors.grey,
            decoration: TextDecoration.lineThrough
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildSalePrice(){
    if( widget.product.price != '' && widget.variationProduct == null ) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Text(
          '\$' + widget.product.price,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
      );
    } else if ( widget.variationProduct != null ) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Text(
          '\$' + widget.variationProduct['price'],
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
  Widget _buildCountingButton(int count){
    return Row(
      children: <Widget>[
        InkWell(
          onTap: count > 0 ? _decrementCount : null,
          child: Container(
            width: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: count > 0 ? Colors.black : Colors.grey
              ),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.remove, size: 18,),
          ),
        ),
        Container(
          width: 40,
          alignment: Alignment.center,
          child: Text(count.toString(),
            style: TextStyle(
              fontSize: 18.0,
            ),),
        ),
        InkWell(
          onTap: _incrementCount,
          child: Container(
            width: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.black
              ),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.add, size: 18,),
          ),
        )
      ],
    );
  }

  Widget _buildViewCartButton(){
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, '/cart');
      },
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: showViewCart ? 1.0 : 0.0,
        child: showViewCart
          ? Container(
            width: double.infinity,
            height: 50.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all()
            ),
            child: Text('View Cart',
              style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 1
              ),
            )
        )
        : Container(),
      ),
    );

  }

  Widget _buildMetaItems(int productId){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.share),
                  SizedBox(width: 8,),
                  Text('Share'),
                ],
              ),
            ),
            onTap: (){
              Share.share(widget.product.permalink);
              Share.share(widget.product.permalink);
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: <Widget>[
                  addedToWishList ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                  SizedBox(width: 8,),
                  addedToWishList ? Text('View Wish List') : Text('Add to Wish List'),
                ],
              ),
            ),
            onTap: addedToWishList ? (){
              Navigator.pushNamed(context, '/main-screen/3');
            } : (){
              addToWishList(productId).then((response){
                setState(() {
                  addedToWishList = true;
                });
              });
            },
          )
        ],
      ),
    );
  }

}
