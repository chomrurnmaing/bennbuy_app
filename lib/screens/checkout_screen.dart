import 'package:bennbuy/helpers/authentication.dart';
import 'package:bennbuy/methods.dart';
import 'package:bennbuy/models/billing_details.dart';
import 'package:bennbuy/screens/order_received_screen.dart';
import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:bennbuy/widgets/header/no_actions_appbar.dart';
import 'package:bennbuy/helpers/validations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

class CheckoutScreen extends StatefulWidget {
  final bool loggedIn;
  final Map cart;
  CheckoutScreen({this.loggedIn, @required this.cart});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> with TickerProviderStateMixin<CheckoutScreen> {
  int _radioValue = 0;
  bool _agreement = false;
  bool _autovalidate;
  BillingDetails billingDetails;
  bool userLoaded = false;
  bool btnLoaded = true;

  List items;

  Dio dio = new Dio();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _firstNamCl = new TextEditingController();
  TextEditingController _lastNameCl = new TextEditingController();
  TextEditingController _addressCl = new TextEditingController();
  TextEditingController _countryCl = new TextEditingController();
  TextEditingController _townCityCl = new TextEditingController();
  TextEditingController _phoneCl = new TextEditingController();
  TextEditingController _emailCl = new TextEditingController();
  TextEditingController _postCodeCl = new TextEditingController();

  @override
  void initState() {
    _autovalidate = false;
    super.initState();
    fetchUserInfo();
    items = new List();

    for ( var item in widget.cart['items'] ) {
      items.add({
        'product_id': item['product_id'],
        'variation_id': item['variation_id'],
        'quantity': item['qty']
      });
    }
  }

  void _handlePaymentChange(int value){
    setState(() {
      _radioValue = value;
    });
  }

  fetchUserInfo(){
    if ( Authentication.isLogin ) {
      getBillingDetails(Authentication.userCookie).then((BillingDetails userDetail){
        setState(() {
          if ( userDetail.status == 'ok' ) {
            userLoaded = true;
            _firstNamCl.text = userDetail.firstName;
            _lastNameCl.text = userDetail.lastName;
            _addressCl.text = userDetail.address1;
            _emailCl.text = userDetail.email;
            _phoneCl.text = userDetail.phone;
            _townCityCl.text = userDetail.city;
            _postCodeCl.text = '12000';
            _countryCl.text = 'Cambodia';
          } else {
            userLoaded = false;
          }
        });

      });
    } else {
      setState(() {
        userLoaded = true;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: noActionAppBar(),
      body: userLoaded ? _buildBody() : Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );

  }

  Widget _buildBody(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            autovalidate: _autovalidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    'Billing details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.black,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2)
                      )
                  ),
                  controller: _firstNamCl,
                  validator: ( String value ) {
                    if ( value.isEmpty ) {
                      return 'First name is required.';
                    }
                  },
                ),
                TextFormField(
                  controller: _lastNameCl,
                  decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.black,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2)
                      )
                  ),
                  validator: ( String value ) {
                    if ( value.isEmpty ) {
                      return 'Last name is required.';
                    }
                  },
                ),
                TextFormField(
                  controller: _addressCl,
                  decoration: InputDecoration(
                      labelText: 'Address',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.black,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2)
                      )
                  ),
                  validator: ( String value ) {
                    if ( value.isEmpty ) {
                      return 'Address is required.';
                    }
                  },
                ),

                TextFormField(
                  controller: _townCityCl,
                  decoration: InputDecoration(
                      labelText: 'Town/City',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.black,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2)
                      )
                  ),
                  validator: ( String value ) {
                    if ( value.isEmpty ) {
                      return 'Town/city is required.';
                    }
                  },
                ),

                TextFormField(
                  controller: _countryCl,
                  decoration: InputDecoration(
                      labelText: 'Country',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.black,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2)
                      )
                  ),
                  validator: ( String value ) {
                    if ( value.isEmpty ) {
                      return 'Country is required.';
                    }
                  },
                ),

                TextFormField(
                  controller: _postCodeCl,
                  decoration: InputDecoration(
                      labelText: 'Post Code',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.black,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2)
                      )
                  ),
                  validator: ( String value ) {
                    if ( value.isEmpty ) {
                      return 'Post Code is required.';
                    }
                  },
                ),
                TextFormField(
                  controller: _phoneCl,
                  decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.black,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2)
                      )
                  ),
                  keyboardType: TextInputType.phone,
                  validator: ( String value ) {
                    if ( value.isEmpty ) {
                      return 'Phone is required.';
                    }
                  },
                ),
                TextFormField(
                  controller: _emailCl,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.black,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2)
                      )
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String value) => validateEmail(value),
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only( top: 20, bottom: 10 ),
                  child: Text(
                    'Order Detail',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200])
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Subtotal', style: TextStyle(fontSize: 14),),
                          ),
                          Expanded(
                            child: Text('\$${widget.cart['subtotal']}', style: TextStyle(fontSize: 14)),
                          )
                        ],
                      ),

                      Divider(),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Shipping', style: TextStyle(fontSize: 14)),
                          ),
                          Expanded(
                            child: Text('Local pickup: \$2.00', style: TextStyle(fontSize: 14)),
                          )
                        ],
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Total', style: TextStyle(fontSize: 14)),
                          ),
                          Expanded(
                            child: Text('\$${widget.cart['total']}', style: TextStyle(fontSize: 14)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[200],
                            blurRadius: 1
                        ),
                      ]
                  ),
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Radio(
                              value: 0,
                              groupValue: _radioValue,
                              onChanged: _handlePaymentChange
                          ),
                          InkWell(
                            onTap: ()=>_handlePaymentChange(0),
                            child: Text('Direct bank transfer', style: TextStyle(fontSize: 14)),
                          )
                        ],
                      ),

                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: MediaQuery.of(context).size.width,
                        height: _radioValue == 0 ? 110 : 0,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        padding: EdgeInsets.all(10),
                        color: Colors.grey[300],
                        child: AnimatedOpacity(
                          opacity: _radioValue == 0 ? 1 : 0,
                          duration: Duration(milliseconds: 500),
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.grey[700]),
                                text: 'Please transfer your payment to 012 39 32 72 by WING, TRUE MONEY, eMONEY, etc… or transfer to ABC account number 000125821 and account name Siden Ung then capture invoice and send to our facebook page.'
                            ),
                          ),
                        ),
                      ),

                      Row(
                        children: <Widget>[
                          Radio(
                              value: 1,
                              groupValue: _radioValue,
                              onChanged: _handlePaymentChange
                          ),
                          InkWell(
                            onTap: ()=>_handlePaymentChange(1),
                            child: Text('Cash on delivery', style: TextStyle(fontSize: 14)),
                          )
                        ],
                      ),

                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: MediaQuery.of(context).size.width,
                        height: _radioValue == 1 ? 40 : 0,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        padding: EdgeInsets.all(10),
                        color: Colors.grey[300],
                        child: AnimatedOpacity(
                          opacity: _radioValue == 1 ? 1 : 0,
                          duration: Duration(milliseconds: 500),
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.grey[700]),
                                text: 'Pay with cash upon delivery.'
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        padding: EdgeInsets.all(10),
                        color: Colors.grey[300],
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(color: Colors.grey[700]),
                              text: 'Your personal data will be used to process your order, support your experience throughout this website, and for other purposes described in our ',
                              children: [
                                TextSpan(
                                    text: 'privacy policy',
                                    style: TextStyle(color: Colors.blue[200]),
                                    recognizer: TapGestureRecognizer()..onTap = _launchURL
                                )
                              ]
                          ),

                        ),
                      ),

                      SizedBox(height: 10,),

                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: _agreement,
                            onChanged: ( status ){
                              setState(() {
                                _agreement = !_agreement;
                              });
                            },
                          ),
                          Expanded(
                              child: Padding(
                                padding: EdgeInsets.only( right: 10 ),
                                child: Text('I have read and agree to the website privacy policy terms and conditions *'),
                              )
                          )
                        ],
                      ),

                      SizedBox(height: 10,),

                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: primaryButtonWithLoading('Place Order', _agreement ? _onPlaceOrder : null, btnLoaded, vsync: this),

                      )
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  _onPlaceOrder() {

    if (!_formKey.currentState.validate()) {
      setState(() {
        _autovalidate=true;
      });
      return;
    }
    setState(() {
      _autovalidate=false;
      btnLoaded = false;
    });

    _formKey.currentState.save();

    dio.post('https://bennbuy.com/wp-json/wc/v3/orders?consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2',
      data: {
        'payment_method': _radioValue == 0 ? 'bacs' : 'cod',
        'payment_method_title': _radioValue == 0 ? 'Direct bank transfer' : 'Cash on delivery',
        'customer_id': Authentication.userId,
        'billing': {
          'first_name': _firstNamCl.text,
          'last_name': _lastNameCl.text,
          'address_1': _addressCl.text,
          'city': _townCityCl.text,
          'postcode': _postCodeCl.text,
          'country': _countryCl.text,
          'email': _emailCl.text,
          'phone': _phoneCl.text
        },
        'shipping': {
          'first_name': _firstNamCl.text,
          'last_name': _lastNameCl.text,
          'address_1': _addressCl.text,
          'city': _townCityCl.text,
          'postcode': _postCodeCl.text,
          'country': _countryCl.text,
          'email': _emailCl.text,
          'phone': _phoneCl.text
        },
        'line_items': items,
        'shipping_lines': [
          {
            'method_id': 'local_pickup',
            'method_title': widget.cart['shipping_title'],
            'total': widget.cart['shipping']
          }
        ]
      }
    ).then((response){

      setState(() {
        btnLoaded = true;
      });

      if ( response.data['id'] != null ) {

        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (BuildContext context){
              return OrderReceivedScreen();
            }
        ));
      }
    });
  }

  _launchURL() async {
    const url = 'https://bennbuy.com/privacy-policy';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
