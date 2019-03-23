import 'package:bennbuy/methods.dart';
import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import '../widgets/products/horizontal_product_list.dart';
import '../widgets/category/main_categories.dart';

class ShopScreen extends StatefulWidget {

  ShopScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShopScreenState();
  }
}

class _ShopScreenState extends State<ShopScreen> with TickerProviderStateMixin<ShopScreen>{

  String url1 = 'https://bennbuy.com/wp-json/wc/v3/products?consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2';
  String url2 = 'https://bennbuy.com/wp-json/wc/v3/products?page=2&consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2';
  String url3 = 'https://bennbuy.com/wp-json/wc/v3/products?page=3&consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2';
  String url4 = 'https://bennbuy.com/wp-json/wc/v3/products?page=6&consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2';

  Connectivity connectivity = new Connectivity();
  bool internetStatus = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    connectivity.onConnectivityChanged.listen((ConnectivityResult result){
      setState(() {
        if ( result == ConnectivityResult.none ){
          internetStatus = false;
        } else {
          internetStatus = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return TabBarView(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: ()=>_onRefresh(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: _columnItems(),
          ),
        ),
        MainCategories()
      ],
    );

  }

  Future<Null> _onRefresh() async{
    await Future.delayed(Duration(seconds: 2));

    return null;
  }

  Widget _columnItems() {
    return Column(
      children: <Widget>[
        Container(
          height: 300.0,
          margin: EdgeInsets.only(top: 10),
          child: FutureBuilder(
            future: getSlider(),
            builder: (context, snap){
              if ( snap.hasData ) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snap.data.length,
                  itemBuilder: (context, index){
                    return Container(
                        width: 280.0,
                        margin: EdgeInsets.only(right: 5.0),
                        child: FadeInImage(
                          placeholder: AssetImage('assets/images/default-image.png'),
                          image: NetworkImage(snap.data[index]['thumbnail']),
                          fit: BoxFit.cover,
                        )
                    );
                  });
              } else {
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              }

            },
          ),
        ),

        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Text(
              'Trending now',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20.0
              )),
        ),
        Container(
            height: 300.0,
            child: internetStatus ? HorizontalProductList(url1) : noInternetConnection(),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Text(
              'Crowd pleasers',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20.0
              )),
        ),
        Container(
            height: 300.0,
            child: internetStatus ?  HorizontalProductList(url2) : noInternetConnection(),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Text(
              'Everybody love ...',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20.0
              )),
        ),
        Container(
            height: 300.0,
            child: internetStatus ? HorizontalProductList(url3) : noInternetConnection()
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Text(
              'Popular with others',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20.0
              )),
        ),
        Container(
            height: 300.0,
            child: internetStatus ? HorizontalProductList(url4) : noInternetConnection()
        )
      ],
    );
  }
}
