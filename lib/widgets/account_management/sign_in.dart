import 'dart:convert';

import 'package:bennbuy/helpers/authentication.dart';
import 'package:bennbuy/methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bennbuy/helpers/shared_preferences_helper.dart';


class SignIn extends StatefulWidget {
  final bool createOrder;
  SignIn(this.createOrder);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoggedIn;

  TextEditingController _usernameCl = new TextEditingController();
  TextEditingController _passwordCl = new TextEditingController();

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  _setupToLocalStorage({String cookie, int userId, bool isLogin}) async{
    await SharedPreferencesHelper.setCookie(cookie ?? 'nocookie');
    await SharedPreferencesHelper.setUserId(userId ?? 0);
    Authentication.isLogin = isLogin ?? false;
    Authentication.userId = userId ?? 0;
    Authentication.userCookie = cookie ?? 'nocookie';
  }

  void _onSignInSummit( String username, String password ) {

    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    var url = "https://bennbuy.com/api/user/generate_auth_cookie/";

    http.post(url, body: {"username": username, "password": password}).then(( response ) async {

      var decode = json.decode( response.body );

      if ( decode['status'] == 'error' ) {

        _setupToLocalStorage();

        Scaffold.of( context ).showSnackBar( SnackBar( content: Text( decode['error'] ), backgroundColor: Colors.red, ) );

      } else if ( decode['status'] == 'ok' ) {

        _setupToLocalStorage(cookie: decode['cookie'], userId: decode['user']['id'], isLogin: true);
        Navigator.pop(context);

      }

    });

  }

  @override
  Widget build( BuildContext context ) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric( horizontal: 15, vertical: 20 ),
          child: Form(
            key: _formKey,
            autovalidate: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _usernameCl,
                  decoration: InputDecoration(
                      labelText: 'Username or Email',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.black,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2)
                      )
                  ),
                  validator: (String value) {
                    if ( value.isEmpty ) return 'Username or Email is required';
                  },
                ),

                SizedBox(height: 15,),

                TextFormField(
                  controller: _passwordCl,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.black,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2)
                      )
                  ),
                  obscureText: true,
                  validator: (String value) {
                    if (value.isEmpty || value.length < 6) {
                      return 'Password invalid';
                    }
                  },
                ),

                SizedBox(height: 15,),

                InkWell(
                  onTap: (){},
                  child: Text('Forgot password?',
                    style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline
                    ),),
                ),

                SizedBox(height: 25,),

                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Divider(color: Colors.black,),
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        height: 25,
                        width: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(' Or '),
                      ),
                    )
                  ],
                ),

                SizedBox(height: 15,),

                Material(
                  color: Color.fromRGBO(60,90,153, 1),
                  child: InkWell(
                    onTap: () => initiateFacebookLogin(onLoginStatusChanged, context),
                    splashColor: Colors.grey,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text('With Facebook',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15,),

                Text('By signin in to your account, you agree to our Privacy Policy and Terms & Conditions.',
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),

                SizedBox(height: 20,),

                Material(
                  color: Colors.black,
                  child: InkWell(
                    onTap: (){
                      _onSignInSummit(_usernameCl.text, _passwordCl.text);
                    },
                    splashColor: Colors.grey,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text('Sign In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10,),

                InkWell(
                  customBorder: Border.all(),
                  onTap: (){
                    Navigator.pop(context);
                  },
                  splashColor: Colors.grey,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text('Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameCl.dispose();
    _passwordCl.dispose();
    super.dispose();
  }

}
