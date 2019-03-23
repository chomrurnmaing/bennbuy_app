
import 'package:bennbuy/methods.dart';
import 'package:bennbuy/models/product_category.dart';
import 'package:bennbuy/widgets/header/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

class SubCategories extends StatefulWidget {

  final int parentId;
  final String parentName;
  SubCategories( this.parentId, this.parentName );

  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  
  HtmlUnescape unescape = new HtmlUnescape();
  ProductCategory allOfParent;
  bool catLoaded;
  String url;
  List<ProductCategory> categories = new List();

  @override
  void initState() {
    allOfParent = new ProductCategory(
      id: widget.parentId,
      name: 'All ${widget.parentName}'
    );
    url = 'https://bennbuy.com/wp-json/wc-custom/v3/product/categories?per_page=-1&parent=${widget.parentId}';
    catLoaded = false;
    getProductCategories(url).then((response){
      setState(() {
        catLoaded = true;
        categories = response;
        categories.insert(0, allOfParent);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return CustomScrollView(
      slivers: <Widget>[
        MainAppBar(),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i){
              return ListTile(
                onTap: (){
                  if ( categories[i].id==widget.parentId ) {
                    Navigator.pushNamed(context, '/archive/${categories[i].id}/${categories[i].name}/true/false');
                  } else {
                    Navigator.pushNamed( context, '/archive/${categories[i].id}/${categories[i].name}/false/${categories[i].hasChildren}' );
                  }
                },
                title: Text( unescape.convert(categories[i].name) ),
              );

              },
            childCount: categories.length
          ),
        )
      ],
    );
  }
}

