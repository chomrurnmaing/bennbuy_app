import 'package:bennbuy/screens/acc_management_screen.dart';
import 'package:bennbuy/screens/account_screen.dart';
import 'package:bennbuy/screens/archive_screen.dart';
import 'package:bennbuy/screens/coming_soon_screen.dart';
import 'package:bennbuy/screens/drawer_cart_screen.dart';
import 'package:bennbuy/screens/info_setting_screen.dart';
import 'package:bennbuy/screens/main_screen.dart';
import 'package:bennbuy/screens/product_filter_screen.dart';
import 'package:bennbuy/screens/purchases_screen.dart';
import 'package:bennbuy/screens/search_screen.dart';
import 'package:bennbuy/screens/subcategories_screen.dart';
import 'package:bennbuy/screens/wish_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:bennbuy/screens/product_detail_screen.dart';

Map<String, WidgetBuilder> routes(){

  Map<String, WidgetBuilder> routes = {
    '/': (BuildContext context) => MainScreen(selectedIndex: 0,),
    '/search': (BuildContext context) => SearchScreen(),
    '/cart': (BuildContext context) => DrawerCartScreen(),
    '/wish-list': (BuildContext context) => WishListDrawerScreen(),
    '/my-account': (BuildContext context) => AccountScreen(),
    '/info-settings': (BuildContext context)=>InfoSettingsScreen(),
    '/product-filter': (BuildContext context) => ProductFilterScreen(),
    '/coming-soon'  : (BuildContext context) => ComingSoonScreen()
  };

  return routes;
}

Route generateRoutes(RouteSettings settings){
  final List<String> namePath = settings.name.split('/');

  if (namePath[0] != '') {
    return null;
  }

  if( namePath[1] == 'main-screen' ) {
    final int selectedIndex = int.parse(namePath[2]);

    return MaterialPageRoute(
        builder: ( BuildContext context ) {
          return MainScreen(selectedIndex: selectedIndex);
        }
    );
  }

  if ( namePath[1] == 'product-detail' ) {
    final int productId = int.parse(namePath[2]);
    int variationId = 0;
    if (namePath.length > 3) {
      variationId = int.parse(namePath[3]);
    }

    return MaterialPageRoute(
        builder: ( BuildContext context ) {
          return ProductDetailScreen(productId: productId, variationId: variationId,);
        }
    );
  }

  if( namePath[1] == 'sub-category' ) {
    final int parentCategoryId = int.parse(namePath[2]);
    final String parentName = namePath[3];

    return MaterialPageRoute(
      builder: ( BuildContext context ) {
        return SubCategoriesScreen(parentCategoryId, parentName);
      }
    );
  }

  if( namePath[1] == 'archive' ){
    final int categoryId = int.parse(namePath[2]);
    final String categoryName = namePath[3];
    bool showAll = namePath[4] == 'true';
    bool hasChildren = namePath[5] == 'true';

    return MaterialPageRoute(
      builder: ( BuildContext context ){
        return ArchiveScreen( categoryId, categoryName, showAll, hasChildren );
      }
    );
  }

  if( namePath[1] == 'acc-management' ) {
    final int initialIndex = int.parse( namePath[2] );
    final bool createOrder = namePath[3].toLowerCase() == 'true';

    return MaterialPageRoute(
        builder: ( BuildContext context ) => AccMngScreen(initialIndex, createOrder)
    );
  }

  if( namePath[1] == 'purchases-list' ){

    return MaterialPageRoute(
        builder: (context)=>PurchasesScreen()
    );

  }

  return null;
}