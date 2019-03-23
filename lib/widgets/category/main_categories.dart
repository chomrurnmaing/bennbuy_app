import 'dart:async';

import 'package:bennbuy/methods.dart';
import 'package:bennbuy/models/product_category.dart';
import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';


class MainCategories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainCategoriesState();
  }
}

class _MainCategoriesState extends State<MainCategories> with AutomaticKeepAliveClientMixin<MainCategories> {
  final String apiUrl = 'https://bennbuy.com/wp-json/wc-custom/v3/product/categories?per_page=-1';
  HtmlUnescape unescape = new HtmlUnescape();
  StreamSubscription<ConnectivityResult> _subscription;
  Connectivity _connectivity = new Connectivity();
  bool internetConnectionStatus = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result){
      setState(() {
        if (result == ConnectivityResult.none){
          internetConnectionStatus = false;
        } else {
          internetConnectionStatus = true;
        }
      });
    });
  }

  @override
  Widget build( BuildContext context ) {
    if ( internetConnectionStatus ) {
      return FutureBuilder<List<ProductCategory>>(
        future: getProductCategories(apiUrl),
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  return Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: Colors.grey[300]))
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  unescape.convert(snapshot.data[index].name),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),),
                              ),),
                              snapshot.data[index].thumbnail != null ? Image.network(snapshot.data[index].thumbnail['url'], height: 100, width: 210, fit: BoxFit.cover,) : Container(),
                            ],
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (){
                                Navigator.pushNamed(context,
                                    '/archive/${snapshot.data[index].id}/${snapshot.data[index].name}/false/${snapshot.data[index].hasChildren}');
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return pageError('Please check your internet connection or refresh this page.');
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

    } else {
      return noInternetConnection();
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _subscription.cancel();
  }
}
