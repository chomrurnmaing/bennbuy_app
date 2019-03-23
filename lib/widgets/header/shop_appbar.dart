import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

Widget shopAppBar( context ){
  return AppBar(
    elevation: 2.0,
    centerTitle: true,
    leading: IconButton(
        icon: Icon(Icons.search),
        onPressed: (){
          Navigator.pushNamed(context, '/search');
        }),
    title: Text('BENNBUY',
      style: TextStyle(
          fontFamily: 'Muli',
          fontWeight: FontWeight.w300
      ),),
    actions: <Widget>[
      cartCount(context)
    ],
    bottom: TabBar(
      indicatorColor: Colors.black,
      tabs: <Widget>[
        Tab(
          child: Text('Top Picks', style: TextStyle(fontWeight: FontWeight.w400),),
        ),
        Tab(
          child: Text('Departments', style: TextStyle(fontWeight: FontWeight.w400),),
        )
      ],
    ),
  );
}
