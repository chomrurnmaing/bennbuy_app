import 'package:bennbuy/methods.dart';
import 'package:bennbuy/models/product_category.dart';
import 'package:flutter/material.dart';

class SubCategoriesScreen extends StatefulWidget {
  final int parentId;
  final String parentName;
  SubCategoriesScreen(this.parentId, this.parentName);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SubCategoriesScreenState();
  }
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  String apiUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiUrl = 'https://bennbuy.com/wp-json/wc/v3/products/categories?parent=${widget.parentId}&per_page=100&consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2';
  }

  @override
  Widget build(BuildContext context) {
    List<ProductCategory> categories = getProductCategories(apiUrl) as List;

    return SliverList(
      delegate: SliverChildListDelegate(
        categories.map((category) {
          return Container(
            child: ListTile(
              onTap: () {
                //Testing for archive page
                Navigator.pushNamed(context, '/archive/${category.id}');
              },
              title: Text(category.name),
            ),
          );
        }).toList(),
      ),
    );
  }
}
