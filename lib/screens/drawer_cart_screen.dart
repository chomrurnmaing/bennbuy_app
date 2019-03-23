import 'package:bennbuy/screens/cart_screen.dart';
import 'package:bennbuy/widgets/header/seamless_appbar.dart';
import 'package:flutter/material.dart';

class DrawerCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: seamlessAppBar( context ),
      body: CartScreen(),
    );
  }
}
