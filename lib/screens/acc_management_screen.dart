import 'package:bennbuy/widgets/account_management/create_account.dart';
import 'package:bennbuy/widgets/account_management/sign_in.dart';
import 'package:flutter/material.dart';

class AccMngScreen extends StatefulWidget {
  final int initialIndex;
  final bool createOrder;
  AccMngScreen(this.initialIndex, this.createOrder);

  @override
  _AccMngScreenState createState() => _AccMngScreenState();
}

class _AccMngScreenState extends State<AccMngScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex != null ? widget.initialIndex : 0,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('BENNBUY',
            style: TextStyle(
              fontFamily: 'Muli',
              fontWeight: FontWeight.w300
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.black,
            tabs: <Widget>[
              Tab(
                text: 'Sign In',
              ),
              Tab(
                text: 'Create Account',
              )
            ]
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SignIn(widget.createOrder),
            CreateAccount(),
          ]
        ),
      ),
    );
  }
}
