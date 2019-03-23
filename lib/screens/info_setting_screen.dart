import 'package:bennbuy/helpers/authentication.dart';
import 'package:bennbuy/widgets/bottom_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:bennbuy/helpers/shared_preferences_helper.dart';
import 'package:bennbuy/helpers/validations.dart';
import 'package:bennbuy/methods.dart';
import 'package:bennbuy/models/user.dart';
import 'package:bennbuy/widgets/header/seamless_appbar.dart';
import 'package:flutter/material.dart';

class InfoSettingsScreen extends StatefulWidget {
  @override
  _InfoSettingsScreenState createState() => _InfoSettingsScreenState();
}

class _InfoSettingsScreenState extends State<InfoSettingsScreen> {

  bool _autovalidate = false;
  double left = 15, top = 10, right = 15, bottom = 0;
  bool _visable = false;
  int userId;
  User userInfo;
  bool userLoaded = false;

  Future fetchUserId() async{
    userId = await SharedPreferencesHelper.getUserId();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _firstNamCl = new TextEditingController();
  TextEditingController _lastNameCl = new TextEditingController();
  TextEditingController _displayNameCl = new TextEditingController();
  TextEditingController _emailCl = new TextEditingController();
  TextEditingController _phoneCl = new TextEditingController();

  TextEditingController _currentPasswordCl = new TextEditingController();
  TextEditingController _newPasswordCl = new TextEditingController();
  TextEditingController _confirmPasswordCl = new TextEditingController();

  TextEditingController _billingFirstNameCl = new TextEditingController();
  TextEditingController _billingLastNameCl = new TextEditingController();
  TextEditingController _billingAddressCl = new TextEditingController();
  TextEditingController _billingCityCl = new TextEditingController();
  TextEditingController _billingStateCl = new TextEditingController();
  TextEditingController _billingPostcodeCl = new TextEditingController();
  TextEditingController _billingCountryCl = new TextEditingController();
  TextEditingController _billingPhoneCl = new TextEditingController();
  TextEditingController _billingEmailCl = new TextEditingController();

  TextEditingController _shippingFirstNameCl = new TextEditingController();
  TextEditingController _shippingLastNameCl = new TextEditingController();
  TextEditingController _shippingAddressCl = new TextEditingController();
  TextEditingController _shippingCityCl = new TextEditingController();
  TextEditingController _shippingStateCl = new TextEditingController();
  TextEditingController _shippingPostcodeCl = new TextEditingController();
  TextEditingController _shippingCountryCl = new TextEditingController();
  TextEditingController _shippingPhoneCl = new TextEditingController();
  TextEditingController _shippingEmailCl = new TextEditingController();

  Future fetchUserInfo() async{
    await getUser(Authentication.userCookie).then((user){
      setState(() {
        userInfo = user;
        userLoaded = true;

        _firstNamCl.text = user.firstName;
        _lastNameCl.text = user.lastName;
        _displayNameCl.text = user.displayName;
        _emailCl.text = user.email;
      });
    });
  }

  @override
  void initState() {
    fetchUserId();
    fetchUserInfo();

    super.initState();
  }

  Widget _buildFormItem(String label, TextEditingController controller, Function validator, {bool obscureText, bool autoValidate = false}){
    return TextFormField(
      controller: controller,
      autovalidate: autoValidate ? autoValidate : _autovalidate,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          fillColor: Colors.black,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2)
          )
      ),
      validator: validator,
    );
  }

  Widget _buildHeading(String label){
    return Container(
      padding: EdgeInsets.only(left: left, right: right, top: 15, bottom: 10),
      child: Text(label,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600
        ),
      ),
    );
  }

  String confirmPasswordValidator(String value){
    if ( value.isEmpty ) {
      return null;
    } else if ( value != _newPasswordCl.text ) {
      return 'Password not match.';
    }
    return null;
  }

  void _onSaveChange(BuildContext contexts){
    AlertDialog confirmation = AlertDialog(
      title: Text('Are you sure to save changes?'),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            String url = 'https://bennbuy.com/api/user/update_user_meta_vars/';
            http.post(url, body: {
              'cookie': Authentication.userCookie,
              'first_name': _firstNamCl.text,
              'last_name': _lastNameCl.text,
              'display_name': _displayNameCl.text,
              'email': _emailCl.text
            }).then((response){
              Navigator.pushReplacementNamed(context, '/main-screen/4');
            });
          },
          child: Text('Yes'),
        ),
        FlatButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        )
      ],
    );

    showDialog(context: context, builder: (context) => confirmation);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      appBar: seamlessAppBar( context, orderTitle: 'Info & Settings' ),
      body: userLoaded ?
        Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            addAutomaticKeepAlives: true,
            children: <Widget>[
              _buildHeading('Persional Info'),
              Container(
                padding: EdgeInsets.only(top: 0, bottom: 20, left: 15, right: 15),
                margin: EdgeInsets.only(left: left, right: right),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[400]
                      )
                    ]
                ),
                child: Column(
                  children: <Widget>[
                    _buildFormItem(
                        'First Name',
                        _firstNamCl,
                        requiredValidator,
                    ),
                    _buildFormItem(
                        'Last Name',
                        _lastNameCl,
                        requiredValidator,
                    ),
                    _buildFormItem(
                        'Display Name',
                        _displayNameCl,
                        requiredValidator,
                    ),
                    _buildFormItem(
                        'Email',
                        _emailCl,
                        validateEmail,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15,),

//              Container(
//                alignment: Alignment.centerLeft,
//                margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
//                child: InkWell(
//                  onTap: (){
//                    setState(() {
//                      _visable ? _visable = false : _visable = true;
//                    });
//                  },
//                  child: Text('Change Password?'),
//                ),
//              ),
//              AnimatedCrossFade(
//                  firstChild: Container(),
//                  secondChild: Container(
//                    padding: EdgeInsets.only(top: 0, bottom: 20, left: 15, right: 15),
//                    margin: EdgeInsets.only(left: left, right: right),
//                    decoration: BoxDecoration(
//                        color: Colors.white,
//                        boxShadow: [
//                          BoxShadow(
//                              color: Colors.grey[400]
//                          )
//                        ]
//                    ),
//                    child: Column(
//                      children: <Widget>[
//                        _buildFormItem('Current Password', _currentPasswordCl, requiredValidator, obscureText: true ),
//                        _buildFormItem('New Password', _newPasswordCl, validatePassword, obscureText: true ),
//                        _buildFormItem('Confirm Password', _confirmPasswordCl, confirmPasswordValidator, obscureText: true, autoValidate: true ),
//                      ],
//                    ),
//                  ),
//                  crossFadeState: _visable ? CrossFadeState.showSecond : CrossFadeState.showFirst,
//                  duration: Duration(milliseconds: 300)
//              ),

              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                child: Material(
                  color: Colors.black,
                  child: InkWell(
                    onTap: (){
                      _onSaveChange(context);
                    },
                    splashColor: Colors.grey,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text('Save Change',
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

              Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
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
          ),
        )
        : Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        )
    );

  }
}
