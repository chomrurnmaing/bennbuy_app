import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatefulWidget {
  @override
  MainAppBarState createState() {
    return new MainAppBarState();
  }
}

class MainAppBarState extends State<MainAppBar> {

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      forceElevated: true,
      elevation: 2.0,
      floating: true,
      pinned: false,
      centerTitle: true,
      title: Text('BENNBUY',
        style: TextStyle(
            fontFamily: 'Muli',
            fontWeight: FontWeight.w300
        ),),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              Navigator.pushNamed(context, '/search');
            }),
        cartCount(context)
      ],
    );
  }
}
