import 'package:bennbuy/methods.dart';
import 'package:bennbuy/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

Widget buildRegularPrice(post){
  Widget widget;
  if ( post.regularPrice != '' ) {
    widget = Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        '\$${post.regularPrice}',
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w300,
          color: Colors.grey,
          decoration: TextDecoration.lineThrough,
        ),
      ),
    );
  } else {
    widget = Container(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),);
  }

  return widget;
}

Widget buildSalePrice(post){
  Widget widget;
  if ( post.price != null ) {
    widget = Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Text(
        '\$${post.price}',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  } else {
    widget = Container(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),);
  }

  return widget;

}

Widget pageError(String text, {String heading}){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    alignment: Alignment.center,
    child: Column(
      children: <Widget>[
        Icon(Icons.error_outline),
        Text(heading ?? 'Sorry, something went wrong!', textAlign: TextAlign.center, style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600
        ),),
        Text(text, textAlign: TextAlign.center,),
      ],
    ),
  );
}

Widget productGridView( Product product, BuildContext context ){
  HtmlUnescape unescape = new HtmlUnescape();
  
  return Stack(
    children: <Widget>[
      Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[350],
                offset: Offset(0, 0.5),
                blurRadius: 1.5,
                spreadRadius: 0
              )
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                child: CachedNetworkImage(
                  imageUrl: product.images.length > 0 ? getThumbnail(product.images[0]['src'], '300x300') : '',
                  placeholder: Image.asset('assets/images/default-image.png', height: 150, width: double.infinity, fit: BoxFit.cover,),
                  errorWidget: Image.asset('assets/images/default-image.png', height: 150, width: double.infinity, fit: BoxFit.cover,),
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0
                ),
                child: Text(
                  product.title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Text(
                  unescape.convert(product.categories[product.categories.length - 1]['name']),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              (product.price != product.regularPrice && product.regularPrice != null) || product.regularPrice != '' ? Container(
                width: double.infinity,
                child: Text(
                  '\$${product.regularPrice}',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ) : Container(),
              Container(
                width: double.infinity,
                child: Text(
                  '\$${product.price}',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: SmoothStarRating(
                  size: 20,
                  allowHalfRating: true,
                  borderColor: Colors.black,
                  rating: double.parse(product.averageRating),
                  color: Colors.black,
                ),
              ),
              Container(
                width: double.infinity,
                child: Text(
                  product.ratingCount.toString() + ' Reviews',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned.fill(
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/product-detail/${product.id}');
              },
            )),
      )
    ],
  );
}

Widget askToSignIn( BuildContext context ) {
  return Container(
    alignment: Alignment.center,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Please Sign In!',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 15,),
        Material(
          color: Colors.black,
          child: InkWell(
            onTap: (){Navigator.pushNamed(context, '/acc-management/0/false');},
            splashColor: Colors.grey,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 45),
              child: Text('Sign In',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget verticalBorder(double height) {
  return Container(
    height: height,
    width: 1,
    color: Colors.grey[300],
  );
}

Widget bottomBorderHeading(String title){
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.only(top: 10, left: 15, right: 15),
    padding: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey[300]))
    ),
    child: Text(
      title.toUpperCase(),
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget primaryButton(String text, Function onTap, {double fontSize, Color textColor, Color bgColor}){
  return Material(
    color: bgColor ?? Colors.black,
    child: InkWell(
      onTap: onTap,
      splashColor: Colors.grey,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: fontSize ?? 16,
          ),
        ),
      ),
    ),
  );
}

Widget primaryButtonWithLoading(String text, Function onTap, bool loaded, {double fontSize, Color textColor, Color bgColor, @required TickerProvider vsync}){
  return RaisedButton(
    onPressed: loaded ? onTap : null,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0)
    ),
    padding: EdgeInsets.only(top: 15, bottom: 15),
    color: bgColor ?? Colors.black,
    animationDuration: Duration(milliseconds: 200),
    child: AnimatedSize(
      duration: Duration(milliseconds: 150),
      vsync: vsync,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: fontSize ?? 16,
            ),
          ),
          loaded == false ? Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 1.5, valueColor: new AlwaysStoppedAnimation<Color>(bgColor ?? Colors.white),),
          ) : Container()
        ],
      ),
    ),
  );
}

void internetConnectionAlert(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("No internet connection!"),
        content: Text("Please make sure your phone connected to the internet."),
        actions: <Widget>[
          FlatButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text('Yes'))
        ],
      ),
  );
}

void confirmationDialog(BuildContext context, String title, {List<Widget> actions, String content}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content ?? ''),
      actions: actions,
    ),
  );
}

Widget noInternetConnection() {
  return Container(
    alignment: Alignment.center,
    child: Text('No internet connection!'),
  );
}

Widget circularLoading(){
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.all(15),
    child: CircularProgressIndicator(),
  );
}

Widget flatButton(String text, Function function, bool loaded, {Color bgColor, Color txtColor}){
  return InkWell(
    onTap: loaded ? function : null,
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        border: Border.all(color: Colors.grey[300])
      ),
      width: double.infinity,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 8),
      child: Text(text, style: TextStyle(
        color: txtColor ?? Colors.black
      ),),
    ),
  );
}

Widget cartCount(BuildContext context){
  return Container(
    alignment: Alignment.center,
    child: Stack(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: (){
            Navigator.pushNamed(context, '/cart');
          },
        ),
        FutureBuilder(
          future: getCartCount(),
          builder: (context, snap){
            if ( snap.hasData && snap.data['cart_count'] != null ){
              return Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(3.0),
                margin: EdgeInsets.only(left: 26.0),
                child: Text(snap.data['cart_count'].toString(),
                  style: TextStyle(
                      color: Colors.white
                  ),),
              );
            }else{
              return Container();
            }
          },
        ),

      ],
    ),
  );
}

