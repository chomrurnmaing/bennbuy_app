import 'package:bennbuy/widgets/bottom_nav_bar.dart';
import 'package:bennbuy/widgets/category/sub_categories.dart';
import 'package:bennbuy/widgets/products/sliver_product_grid.dart';
import 'package:flutter/material.dart';

class ArchiveScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final bool showAll;
  final bool hasChildren;
  ArchiveScreen(this.categoryId, this.categoryName, this.showAll, this.hasChildren);
  
  @override
  _ArchiveScreenState createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: SafeArea(
        child: widget.hasChildren
            ? SubCategories( widget.categoryId, widget.categoryName )
            : SliverProductGrid( widget.categoryId )
      ),
    );
  }

}
