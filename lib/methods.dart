import 'dart:async';
import 'dart:io' show Platform;

import 'package:bennbuy/helpers/authentication.dart';
import 'package:bennbuy/helpers/shared_preferences_helper.dart';
import 'package:bennbuy/models/billing_details.dart';
import 'package:bennbuy/models/order.dart';
import 'package:bennbuy/models/product_attribute.dart';
import 'package:bennbuy/models/product_attribute_term.dart';
import 'package:bennbuy/models/product_category.dart';
import 'package:bennbuy/models/product_images_model.dart';
import 'package:bennbuy/models/product_review.dart';
import 'package:bennbuy/models/product_search.dart';
import 'package:bennbuy/models/user.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/product.dart';
import 'package:flutter/services.dart';

Future getDeviceUniquId() async{

  DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
  String deviceId;
  if ( Platform.isAndroid ) {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    deviceId = androidDeviceInfo.androidId;
  } else {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;

    deviceId =iosDeviceInfo.identifierForVendor;
  }

  Authentication.deviceId = deviceId;
}

String getThumbnail(String url, String size){
  var urls = url.split('.');
  var ext = '.' + urls[urls.length - 1];

  return url.replaceAll(ext, '-' + size + ext );
}

Future<List> getSlider() async {
  final response = await http.get('https://bennbuy.com/wp-json/wp-custom/v3/posts?types=slick_slider');

  if ( response.statusCode == 200 ) {

    return json.decode(response.body);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

List<String> mapImageThumbnail(List<String> urls, String size) {
  return urls.map((url){
    var urls = url.split('.');
    var ext = '.' + urls[urls.length - 1];

    return url.replaceAll(ext, '-' + size + ext );
  }).toList();
}

Future<List<Product>> getProducts( String url ) async {
  final response =
  await http.get(url);

  if ( response.statusCode == 200 ) {
    // If the call to the server was successful, parse the JSON
    var jsonResponse = json.decode(response.body);
    return (jsonResponse as List).map((post)=>Product.fromJson(post)).toList();
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<Product> fetchSingleProduct( String url ) async {
  final response =
  await http.get(url);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);

//    return jsonResponse;
    return Product.fromJson(jsonResponse);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<List<ProductImagesModel>> getProductImages(Product product) async {

  final List prods = product.images;
  int index = 1;

  return prods.map((prod)=>ProductImagesModel.fromJson(index++, prod)).toList();
}

Future<List<ProductCategory>> getProductCategories( String url ) async {
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    List jsonResponse = json.decode(response.body);
    List<ProductCategory> catsList = jsonResponse.map((category)=>ProductCategory.fromJson(category)).toList();

    return catsList;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<List<ProductAttribute>> getProductAttribute( String url ) async {

  final response = await http.get(url);

  if ( response.statusCode == 200 ) {
    List jsonResponse = json.decode(response.body);

    return jsonResponse.map((data)=>ProductAttribute.fromJson(data)).toList();
  } else {

    throw Exception('Failed to load data');
  }

}

Future<List<ProductAttributeTerm>> getProductAttributeTerm( String url ) async {

  final response = await http.get(url);

  if ( response.statusCode == 200 ) {
    List jsonResponse = json.decode(response.body);

    return jsonResponse.map((data)=>ProductAttributeTerm.fromJson(data)).toList();
  } else {

    throw Exception('Failed to load data');
  }

}

Future<User> getUser( String cookie ) async{
  final response = await http.get('https://bennbuy.com/api/user/get_currentuserinfo/?cookie=$cookie');

  if (response.statusCode == 200){
    var jsonDecode = json.decode(response.body);
    return User.fromJson(jsonDecode['user']);
  } else {
    throw Exception('Failed to load data');
  }
}

Future<BillingDetails> getBillingDetails(String cookie) async{
  final response = await http.get('https://bennbuy.com/api/user/get_user_meta/?cookie=$cookie');
  if (response.statusCode == 200){
    var jsonDecode = json.decode(response.body);

    return BillingDetails.fromJson(jsonDecode);
  } else {
    throw Exception('Failed to load data');
  }
}

Future<ConnectivityResult> checkConnectivity() async {
  ConnectivityResult connectionResult;
  Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    connectionResult = await _connectivity.checkConnectivity();
  } on PlatformException catch (e) {
    throw 'error';
  }

  return connectionResult;
}

Future<List<ProductReview>> getProductReviews(int productId, {int perPage}) async{
  final response = await http.get('https://bennbuy.com/wp-json/wc/v3/products/reviews?product=$productId&per_page=${perPage ?? 5}&consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2');

  if ( response.statusCode == 200 ) {
    List jsonResponse = json.decode(response.body);

    return jsonResponse.map((data)=>ProductReview.fromJson(data)).toList();
  } else {

    throw Exception('Failed to load data');
  }
}

Future<List<Order>> getPurchasedOrders( int customerId ) async{
  final response = await http.get('https://bennbuy.com/wp-json/wc/v3/orders?customer=$customerId&consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2&per_page=100');

  if ( response.statusCode == 200 ) {
    List jsonResponse = json.decode(response.body);

    return jsonResponse.map((data)=>Order.fromJson(data)).toList();
  } else {

    throw Exception('Failed to load data');
  }
}

String dateConverter(String date){
  DateTime dt = DateTime.parse(date);

  return dt.day.toString() + '/' + dt.month.toString() + '/' + dt.year.toString();
}

Future<List<ProductSearch>> productSearch(String keyword) async{
  String url = 'https://bennbuy.com/wp-json/wc/v3/products?search=$keyword&per_page=50&consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2';
  var response;

  response = await http.get(url);

  if ( response.statusCode == 200 ){
    List data = json.decode(response.body);

    return data.map((product)=>ProductSearch.fromJson(product)).toList();
  }else{
    throw 'Failed to load post.';
  }


}

Future deleteItem( String url ) async{
  var response = await http.delete(url);

  if ( response.statusCode == 200 ) {
    return response;
  } else {
    throw null;
  }

}

Future addToWishList(int productId) async{
  String url = 'https://bennbuy.com/wp-json/wishlist/v3/create/$productId/author/${Authentication.userId}';

  var response = await http.post(url);

  return json.decode(response.body);
}

Future removeFromWishList(int wishListItemId) async {
  String url = 'https://bennbuy.com/wp-json/wishlist/v3/$wishListItemId';

  var response = await http.delete(url);

  return json.decode(response.body);
}

Future getWishList() async{
  var response = await http.get('https://bennbuy.com/wp-json/wishlist/v3/${Authentication.userId}');
  if( response.statusCode == 200 ) {
    return json.decode(response.body);
  }
  return response.statusCode as List;
}

Future getYourLook() async{
  var response = await http.get('https://bennbuy.com/wp-json/yourlook/v3/${Authentication.userId}');

  return json.decode(response.body);
}

Future createYourLookItem(int productId) async{
  var response = await http.post('https://bennbuy.com/wp-json/yourlook/v3/${Authentication.userId}/product/$productId');

  return json.decode(response.body);
}

Future clearCart() async{
  var response = await http.delete('https://bennbuy.com/wp-json/cart/v3/clear?device_id=${Authentication.deviceId}');

  return response.statusCode;
}

Future getProductThumbnails( List<int> ids ) async{
  String productIds = ids.join(',');
  var response = await http.get('https://bennbuy.com/wp-json/thumbnails/v3/get?product_ids=$productIds');

  return json.decode(response.body);
}

Future getProductByAttrs(int parent, Map attrs) async{
  String attributes = json.encode(attrs);
  var response = await http.get('https://bennbuy.com/wp-json/wc-custom/v3/product/$parent/variation?attributes=$attributes');

  return json.decode(response.body);
}

String toSentenceCase( String s ){

  String firstString = s.substring(0, 1);

  return s.replaceAll(firstString, firstString.toUpperCase());
}

String getNameAttributeKey( var attribute ){

  List<String> key = attribute.keys.toString().split('_');
  String attri = key[key.length - 1].replaceAll(')', '');

  return toSentenceCase(attri);
}

String getAttributeKey( var attribute ){
  String s = attribute.keys.toString();
  return s.replaceAll('(', '').replaceAll(')', '');
}

Future getCartCount() async{
  var response = await http.get('https://bennbuy.com/wp-json/cart/v3/count?device_id=${Authentication.deviceId}');
  if ( response.statusCode == 200 ){
    return json.decode(response.body);
  } else {
    throw 'Something went wrong!';
  }
}

void initiateFacebookLogin(Function onLoginStatusChanged, BuildContext context) async {
  var facebookLogin = FacebookLogin();
  var facebookLoginResult =
  await facebookLogin.logInWithReadPermissions(['email']);
  switch (facebookLoginResult.status) {
    case FacebookLoginStatus.error:
      setupToLocalStorage();
      onLoginStatusChanged(false);
      break;
    case FacebookLoginStatus.cancelledByUser:
      setupToLocalStorage();
      onLoginStatusChanged(false);
      break;
    case FacebookLoginStatus.loggedIn:
      print(facebookLoginResult.accessToken.token);
      http.post('https://bennbuy.com/api/user/fb_connect/', body: {
        'access_token': facebookLoginResult.accessToken.token
      }).then((response){
        var data = json.decode(response.body);
        if(data['status'] == 'ok'){
          setupToLocalStorage(cookie: data['cookie'], userId: data['wp_user_id'], isLogin: true);
          Navigator.pop(context);
        }
      });
      onLoginStatusChanged(true);
      break;
  }
}

setupToLocalStorage({String cookie, int userId, bool isLogin}) async{
  await SharedPreferencesHelper.setCookie(cookie ?? 'nocookie');
  await SharedPreferencesHelper.setUserId(userId ?? 0);
  Authentication.isLogin = isLogin ?? false;
  Authentication.userId = userId ?? 0;
  Authentication.userCookie = cookie ?? 'nocookie';
}


Color getColorNamed(String color){
  color = color.toLowerCase();
  switch(color){
    case 'black':
      return Colors.black;
      break;
    case 'white':
      return Colors.white;
      break;

    case 'grey':
      return Colors.grey;
      break;

    case 'gray':
      return Colors.grey;
      break;

    case 'red':
      return Colors.red;
      break;
    case 'blue':
      return Colors.blue;
      break;
    case 'teal':
      return Colors.teal;
      break;
    case 'brown':
      return Colors.brown;
      break;
    case 'amber':
      return Colors.amber;
      break;
    case 'amber-accent':
      return Colors.amberAccent;
      break;
    case 'blue-accent':
      return Colors.blueAccent;
      break;
    case 'cyan':
      return Colors.cyan;
      break;
    case 'cyan-accent':
      return Colors.cyanAccent;
      break;
    case 'deep-orange':
      return Colors.deepOrange;
      break;
    case 'orange':
      return Colors.orange;
      break;
    case 'yellow':
      return Colors.yellow;
      break;
    case 'pink':
      return Colors.pink;
      break;
    case 'pink-accent':
      return Colors.pinkAccent;
      break;
    case 'green':
      return Colors.green;
      break;
    case 'indigo':
      return Colors.indigo;
      break;
    case 'purple':
      return Colors.purple;
      break;
    case 'silver':
      return Colors.grey[400];
      break;
    case 'gold':
      return Colors.yellow[800];
      break;
    default:
      return Colors.white;
      break;
  }
}

