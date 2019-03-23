import 'package:bennbuy/helpers/authentication.dart';
import 'package:bennbuy/methods.dart';
import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

class YourLookScreen extends StatefulWidget {
  final Function backToShop;
  YourLookScreen(this.backToShop);
  @override
  _YourLookScreenState createState() => _YourLookScreenState();
}

class _YourLookScreenState extends State<YourLookScreen> with AutomaticKeepAliveClientMixin<YourLookScreen> {
  HtmlUnescape unescape = new HtmlUnescape();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if ( Authentication.isLogin ) {
      return FutureBuilder(
        future: getYourLook(),
        builder: (context, snap){
          if ( snap.hasData ){
            if ( snap.data is !List && snap.data['status'] == 404 ){
              return Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(snap.data['message']),
                    Container(
                      width: 160,
                      margin: EdgeInsets.only(top: 15),
                      child: primaryButton('Go to shop', widget.backToShop, fontSize: 14),
                    )
                  ],
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snap.data.length,
                  itemBuilder: (context, index) {
                    return _buildItem(snap.data[index], index);
                  }
              );
            }

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
      margin: EdgeInsets.only(top: 10, left: 10, right: 10 ),
      decoration: BoxDecoration(
          color: Colors.white,
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
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
                  SizedBox( height: 10,),
                  product['categories'] is List ? Text(
                    unescape.convert(product['categories'][product['categories'].length - 1]['name']),
                  ) : Container(),
                  SizedBox( height: 4,),
                  product['product']['regular_price'] != '' ? Text(
                    '\$${product['product']['regular_price']}',
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough
                    ),
                  ) : Container(),
                  SizedBox( height: 4,),
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
