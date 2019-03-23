import 'package:bennbuy/methods.dart';
import 'package:bennbuy/widgets/bottom_nav_bar.dart';
import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class OrderReceivedScreen extends StatefulWidget {
  @override
  _OrderReceivedScreenState createState() => _OrderReceivedScreenState();
}

class _OrderReceivedScreenState extends State<OrderReceivedScreen> {

  void _returnToShop(){
    Navigator.popAndPushNamed(context, '/main-screen/0');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clearCart();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      appBar: AppBar(
        title: Text('Order Received'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Thanks', textAlign: TextAlign.center, style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),),
            Text('Thanks a lot for placing an order with us.\n Your order has been received.', textAlign: TextAlign.center, style: TextStyle(
              fontSize: 16
            ),),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 15),
              child: primaryButton('Back to Shop', _returnToShop),
            )
          ],
        ),
      ),
    );
  }
}
