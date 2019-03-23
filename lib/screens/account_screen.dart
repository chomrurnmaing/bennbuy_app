import 'package:bennbuy/helpers/authentication.dart';
import 'package:bennbuy/helpers/shared_preferences_helper.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key key}) : super(key: key);
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  void _showConfirmation(){
    AlertDialog confirmation = AlertDialog(
      content: Text('Are you sure?'),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text('Stay')
        ),
        FlatButton(
          onPressed: (){
            setState(() {
              SharedPreferencesHelper.setCookie('nocookie');
            });
            Navigator.popAndPushNamed(context, '/');
          },
          child: Text('Sign Out'),
        )
      ],
    );

    showDialog(context: context, builder: (context){
      return confirmation;
    });

  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          height: 130,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[300]))
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.55,
                      padding: EdgeInsets.only(left: 15),
                      child: Text('ORDERS',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),),
                    ),

                    Expanded(child: Image.asset('assets/images/account-orders.png', height: 130, fit: BoxFit.cover,)),
                  ],
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){
                      if ( Authentication.isLogin ) {
                        Navigator.pushNamed(context, '/purchases-list');
                      } else {
                        Navigator.pushNamed(context, '/acc-management/0/false');
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),

        Container(
          height: 130,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey[300]))
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.55,
                      padding: EdgeInsets.only(left: 15),
                      child: Text('RESERVATIONS',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),),
                    ),
                    Expanded(child: Image.asset('assets/images/clothes-hang.png', height: 130, fit: BoxFit.cover,),)
                  ],
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: ()=>Navigator.pushNamed(context, '/coming-soon'),
                  ),
                ),
              )
            ],
          ),
        ),

        _buildAccountItems()

      ],
    );
  }

  Widget _buildAccountItems(){
    if ( Authentication.isLogin ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 10),
            child: Text('YOUR ACCOUNT',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
          Material(
            color: Colors.white,
            shape: Border(top: BorderSide(color: Colors.grey[300]), bottom: BorderSide(color: Colors.grey[300])),
            child: ListTile(
              onTap: (){
                Navigator.pushNamed(context, '/info-settings');
              },
              title: Text('Info & Settings'),
              trailing: Icon(Icons.navigate_next),
            ),
          ),
          SizedBox(height: 25,),
          Material(
            color: Colors.white,
            shape: Border(top: BorderSide(color: Colors.grey[300]), bottom: BorderSide(color: Colors.grey[300])),
            child: ListTile(
              onTap: _showConfirmation,
              title: Text('Sign Out'),
            ),
          ),

      ]);
    } else {
      return Column(
        children: <Widget>[
          SizedBox(height: 30,),
          Material(
            color: Colors.white,
            shape: Border( top: BorderSide( color: Colors.grey[300] ) ),
            child: ListTile(
              onTap: (){
                Navigator.pushNamed(context, '/acc-management/0/false');
              },
              title: Text('Sign In'),
            ),
          ),
          Material(
            color: Colors.white,
            shape: Border(top: BorderSide(color: Colors.grey[300]), bottom: BorderSide(color: Colors.grey[300])),
            child: ListTile(
              onTap: (){
                Navigator.pushNamed(context, '/acc-management/1/false');
              },
              title: Text('Create an Account'),
            ),
          ),
        ]);
    }
  }

}
