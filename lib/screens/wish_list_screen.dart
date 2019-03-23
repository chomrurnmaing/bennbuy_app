
import 'package:bennbuy/screens/wish_list.dart';
import 'package:bennbuy/widgets/bottom_nav_bar.dart';
import 'package:bennbuy/widgets/header/seamless_appbar.dart';
import 'package:flutter/material.dart';

class WishListDrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      appBar: seamlessAppBar( context ),
      body: WishListScreen(),
    );
  }
}
