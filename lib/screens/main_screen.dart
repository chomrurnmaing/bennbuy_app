import 'dart:async';
import 'dart:convert';
import 'package:bennbuy/helpers/authentication.dart';
import 'package:bennbuy/helpers/general_helper.dart';
import 'package:bennbuy/methods.dart';
import 'package:bennbuy/screens/account_screen.dart';
import 'package:bennbuy/screens/cart_screen.dart';
import 'package:bennbuy/screens/purchases_screen.dart';
import 'package:bennbuy/screens/shop_screen.dart';
import 'package:bennbuy/screens/wish_list.dart';
import 'package:bennbuy/screens/your_look_screen.dart';
import 'package:bennbuy/widgets/bottom_nav_bar.dart';
import 'package:bennbuy/widgets/header/seamless_main_app_bar.dart';
import 'package:bennbuy/widgets/header/shop_appbar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  int selectedIndex;

  MainScreen({this.selectedIndex});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin<MainScreen>, AutomaticKeepAliveClientMixin<MainScreen> {

  TabController _controller;
  List<Widget> _bodyView;
  PageController pageController;
  Connectivity _connectivity = Connectivity();

  List _appBar(BuildContext context){
   return [
     shopAppBar( context ),
     seamlessMainAppBar( context ),
     seamlessMainAppBar( context ),
     seamlessMainAppBar( context ),
     seamlessMainAppBar( context ),
   ];
  }

  Future _getCookie() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if ( prefs.getString('cookie') == 'nocookie' || prefs.getString('cookie') == null ) {
        Authentication.isLogin = false;
        Authentication.userId = 0;
        Authentication.userCookie = 'nocookie';
      } else {
        Authentication.isLogin = true;
        Authentication.userId = prefs.getInt('userId');
        Authentication.userCookie = prefs.getString('cookie');
      }
    });
  }

  _checkAuth() async{
    final response = await http.post('https://bennbuy.com/api/user/validate_auth_cookie/', body: {
      'cookie': Authentication.userCookie
    });

    final responseDecode = json.decode(response.body);

    if ( responseDecode['status'] == 'ok' && responseDecode['valid'] == false ) {
      setState(() {
        Authentication.isLogin = false;
        Authentication.userId = 0;
        Authentication.userCookie = 'nocookie';
      });
    }
  }

  void backToShop(){
    setState(() {
      widget.selectedIndex = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    getDeviceUniquId();
    _controller = new TabController(length: 3, vsync: this);
    pageController = PageController(
        initialPage: widget.selectedIndex
    );

    _getCookie().then((covariant){
      _checkAuth();
    });

    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        if ( result == ConnectivityResult.none ){
          GeneralHelper.internetConnectionHelper = false;
        } else {
          GeneralHelper.internetConnectionHelper = true;
        }
      });
    });

    _bodyView = [
      ShopScreen(),
      YourLookScreen(backToShop),
      CartScreen(),
      WishListScreen(),
      AccountScreen(),
      PurchasesScreen(),
    ];
  }

  Widget build(BuildContext context) {
    
    return DefaultTabController(
      length: _controller.length,
      child: Scaffold(
        appBar: _appBar(context).elementAt(widget.selectedIndex),
        body: _bodyView.elementAt(widget.selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), title: Text('Shop')),
            BottomNavigationBarItem(icon: Icon(Icons.access_time), title: Text('Your Look')),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), title: Text('Bag')),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), title: Text('Wish List')),
            BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Account')),
          ],
          currentIndex: widget.selectedIndex,
          onTap: _onItemTapped,
          fixedColor: Color.fromRGBO(0, 57, 103, 1),
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  void _onItemTapped( int index ) {
    BottomNavBar.selectedIndex = index;
    setState(() {
      widget.selectedIndex = index;
      getCartCount();
    });

    if( index == 1 || index == 3 ){
      if ( Authentication.isLogin ) {
        return;
      }
      Navigator.pushNamed(context, '/acc-management/0/false');
    }

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}