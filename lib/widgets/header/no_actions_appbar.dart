import 'package:flutter/material.dart';

Widget noActionAppBar( {String orderTitle} ){
  return AppBar(
    centerTitle: true,
    title: Text(orderTitle != null ? orderTitle : 'BENNBUY',
      style: TextStyle(
          fontFamily: 'Muli',
          fontWeight: FontWeight.w300
      ),),
  );
}