import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

Widget seamlessAppBar( BuildContext context, {String orderTitle} ){
  return AppBar(
    centerTitle: true,
    title: Text(orderTitle != null ? orderTitle : 'BENNBUY',
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