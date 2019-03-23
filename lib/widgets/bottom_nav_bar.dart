import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  static int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), title: Text('Shop')),
        BottomNavigationBarItem(icon: Icon(Icons.access_time), title: Text('Your Look')),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), title: Text('Bag')),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), title: Text('Wish List')),
        BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Account')),
      ],
      onTap: (int index){
        Navigator.pushReplacementNamed(context, '/main-screen/$index');
      },
      currentIndex: selectedIndex ?? 0,
      fixedColor: Color.fromRGBO(0, 57, 103, 1),
      type: BottomNavigationBarType.fixed,
    );
  }
}
