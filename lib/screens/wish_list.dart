import 'package:bennbuy/helpers/authentication.dart';
import 'package:bennbuy/methods.dart';
import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';


class WishListScreen extends StatefulWidget {

  WishListScreen({Key key}) : super(key: key);

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> with AutomaticKeepAliveClientMixin<WishListScreen> {
  HtmlUnescape unescape = new HtmlUnescape();
  
  bool btnLoaded;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    btnLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    if ( Authentication.isLogin ) {
      return FutureBuilder(
        future: getWishList(),
        builder: (context, snapshot){
          if ( snapshot.hasData ){
            if ( snapshot.data == 404 && snapshot.data is !List ) {
              return Container(
                alignment: Alignment.center,
                child: Text('Your wish list is empty.'),
              );
            } else {
              List product = snapshot.data;
              return ListView.builder(
                  itemCount: product.length,
                  itemBuilder: (context, index) {
                    return _buildItem(product[index], index);
                  }
              );
            }
          } else if(snapshot.hasError) {
            return Container();
          } else {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    } else {
      return askToSignIn( context );
    }
  }

  Widget _buildItem( Map product, int index ){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      margin: EdgeInsets.only(top: 10, right: 15, left: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FadeInImage(
                  placeholder: AssetImage('assets/images/default-image.png'),
                  image: NetworkImage(product['feature_src'],),
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 5,),
                FlatButton(
                  onPressed: (){
                    setState(() {
                      btnLoaded = false;
                    });
                    removeFromWishList(product['wish_list_item_id']).then((response){
                      setState(() {
                        btnLoaded = true;
                      });

                      var snackbar = new SnackBar(content: Text('Item removed.'));
                      Scaffold.of(context).showSnackBar(snackbar);
                    });
                  },
                  shape: Border.all(),
                  child: Container(
                    width: 140,
                    height: 40,
                    alignment: Alignment.center,
                    child: btnLoaded ? Text('Remove') : CircularProgressIndicator(),
                  ),
                ),
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
                      onTap:(){
                        Navigator.pushNamed(context, '/product-detail/${product['product']['id']}');
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(child: Text(
                            product['product']['name'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),),

                          Container(
                            width: 30,
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.navigate_next),
                          )
                        ],
                      ),
                    ),
                  ),
                  product['categories'] is List && product['categories'].length > 0 ? Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      '${unescape.convert(product['categories'][product['categories'].length - 1]['name'])}',
                    ),
                  ) : Container(),
                  SizedBox(height: 10,),
                  product['product']['regular_price'] != '' ? Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      '\$${product['product']['regular_price']}',
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough
                      ),
                    ),
                  ) : Container(),
                  Text(
                    '\$${product['product']['price']}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

