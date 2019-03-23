
import 'package:bennbuy/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/shop_screen.dart';

void main(){
  runApp(new MainApp());
}

class MainApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainAppState();
  }
}

class _MainAppState extends State<MainApp>{




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(250, 250, 250, 1.0),
        fontFamily: 'Muli',
        backgroundColor: Colors.white,
        primaryColorLight: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      title: 'BENNBUY',
      routes: routes(),

      onGenerateRoute: (RouteSettings settings) => generateRoutes(settings),

      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => ShopScreen()
        );
      },
    );
  }

}
