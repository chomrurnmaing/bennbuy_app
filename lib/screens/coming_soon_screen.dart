import 'package:bennbuy/widgets/bottom_nav_bar.dart';
import 'package:bennbuy/widgets/header/seamless_appbar.dart';
import 'package:flutter/material.dart';

class ComingSoonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: seamlessAppBar(context, orderTitle: 'Coming Soon'),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Under\nconstruction'.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600
              ),),
            Text('- Coming Soon -', textAlign: TextAlign.center,)
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
