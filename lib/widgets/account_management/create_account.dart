import 'package:bennbuy/helpers/authentication.dart';
import 'package:bennbuy/helpers/shared_preferences_helper.dart';
import 'package:bennbuy/methods.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bennbuy/helpers/validations.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  bool _autovalidate = false;
  bool _repeatPasswordAutoValidate = false;
  String _apiNonce;
  bool isLoggedIn;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = GlobalKey<FormFieldState<String>>();
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _dNameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _repeatPasswordController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    String url = 'https://bennbuy.com/api/get_nonce/?json=get_nonce&controller=user&method=register';

    http.post(url, body: {
      'json': 'get_nonce',
      'controller': 'user',
      'method': 'register'
    }).then(( response ){
      var decode = json.decode( response.body );
      if ( decode['status'] == 'ok' ) _apiNonce = decode['nonce'];
    });

    _repeatPasswordController.addListener((){
      _repeatPasswordAutoValidate = true;
    });
  }

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  void _onSignUpSummit(){
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
    } else {
      _autovalidate = false;
    }

    if ( !_formKey.currentState.validate() ) {
      return;
    }

    _formKey.currentState.save();

    var url = "https://bennbuy.com/api/user/register/";

    http.post(url, body: {
      'username': _usernameController.text,
      'email': _emailController.text,
      'nonce': _apiNonce,
      'display_name': _dNameController.text
    }).then(( response ) async {

      var decode = json.decode( response.body );

      if ( decode['status'] == 'error' ) {

        await SharedPreferencesHelper.setCookie('nocookie');
        Authentication.isLogin = false;
        Authentication.userId = 0;
        Authentication.userCookie = 'nocookie';
        Scaffold.of( context ).showSnackBar( SnackBar( content: Text( decode['error'] ), backgroundColor: Colors.red, ) );

      } else if ( decode['status'] == 'ok' ) {

        await SharedPreferencesHelper.setCookie( decode['cookie'] );
        Authentication.isLogin = true;
        Authentication.userId = decode['user']['id'];
        Authentication.userCookie = decode['cookie'];
        Navigator.pop(context);
      }

    });
  }

  String _validateReTypePassword(String value) {
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please enter a password.';
    if (passwordField.value != value)
      return 'The passwords don\'t match';
    return null;
  }


  @override
  Widget build(BuildContext context) {

    double left = 10, top = 10, right = 10, bottom = 0;

    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(left, top, right, bottom),
            child: TextFormField(
              controller: _usernameController,
              autovalidate: _autovalidate,
              decoration: InputDecoration(
                  labelText: 'Username*',
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.black,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)
                  )
              ),
              validator: (value){
                if( value.isEmpty ) {
                  return 'Username must not be empty.';
                }
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(left, top, right, bottom),
            child: TextFormField(
              controller: _emailController,
              autovalidate: _autovalidate,
              decoration: InputDecoration(
                  labelText: 'Email*',
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.black,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)
                  )
              ),
              validator: (value)=>validateEmail(value),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(left, top, right, bottom),
            child: TextFormField(
              controller: _dNameController,
              autovalidate: _autovalidate,
              decoration: InputDecoration(
                  labelText: 'Display Name*',
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.black,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)
                  )
              ),
              validator: (value){
                if ( value.isEmpty ) return 'Display Name is required.';
              },
            )
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(left, top, right, bottom),
            child: TextFormField(
              controller: _passwordController,
              key: _passwordFieldKey,
              autovalidate: _autovalidate,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Password*',
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.black,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)
                  )
              ),
              validator: (value){
                if ( value.isEmpty ){
                  return 'Password must not be empty';
                } else if (value.length < 6) {
                  return 'Password must be at lease 6 Characters';
                }
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(left, top, right, bottom),
            child: TextFormField(
              controller: _repeatPasswordController,
              autovalidate: _repeatPasswordAutoValidate,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Repeat Password*',
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.black,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)
                  )
              ),
              validator: (value)=>_validateReTypePassword(value),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(left, 15, right, 15),
            child: Stack(
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
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(left, 0, right, bottom),
            child: Material(
              color: Color.fromRGBO(60,90,153, 1),
              child: InkWell(
                onTap: ()=>initiateFacebookLogin(onLoginStatusChanged, context),
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
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(left, 15, right, bottom),
            child: Text('By signin in to your account, you agree to our Privacy Policy and Terms & Conditions.',
              style: TextStyle(
                  fontSize: 16
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(left, 15, right, bottom),
            child: Material(
              color: Colors.black,
              child: InkWell(
                onTap: ()=>_onSignUpSummit(),
                splashColor: Colors.grey,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text('Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(left, top, right, 10),
            child: InkWell(
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
          ),
        ],
      )
    );
  }

  @override
  void dispose() {
    _dNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
