import 'package:flutter/material.dart';

Widget accMngAppBar(int cartCount, BuildContext context){
  return AppBar(
    elevation: 2.0,
    title: Text('BENNBUY',
      style: TextStyle(
          fontFamily: 'Muli',
          fontWeight: FontWeight.w300
      ),),
    centerTitle: true,
    bottom: TabBar(
      indicatorColor: Colors.black,
      tabs: <Widget>[
        Tab(
          child: Text('Sign In', style: TextStyle(fontWeight: FontWeight.w400),),
        ),
        Tab(
          child: Text('Create Account', style: TextStyle(fontWeight: FontWeight.w400),),
        )
      ],
    ),
  );
}