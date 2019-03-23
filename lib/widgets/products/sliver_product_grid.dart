import 'package:bennbuy/methods.dart';
import 'package:bennbuy/models/product.dart';
import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:bennbuy/widgets/header/archive_appbar.dart';
import 'package:flutter/material.dart';

class SliverProductGrid extends StatefulWidget {
  final int categoryId;
  SliverProductGrid( this.categoryId );
  @override
  State<StatefulWidget> createState() => _SliverProductGridState();
}

class _SliverProductGridState extends State<SliverProductGrid>{

  String url;
  String oldOrderBy = 'orderby=date&order=desc';

  @override
  void initState() {
    super.initState();
    url = 'https://bennbuy.com/wp-json/wc/v3/products?category=${widget.categoryId}&$oldOrderBy&per_page=100&consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2';
  }

  void orderProduct( String orderBy, {String order} ){
    String replacement = 'orderby=$orderBy&order=${order ?? 'desc'}';

    setState(() {
      url = url.replaceAll(oldOrderBy, replacement);
      oldOrderBy = replacement;
    });
  }

  @override
  Widget build( BuildContext context ) {
    return FutureBuilder<List<Product>>(
      future: getProducts( url ),
      builder: ( context, snapshot ){
        if( snapshot.hasData ){
          return CustomScrollView(
            slivers: <Widget>[
              ArchiveAppBar( orderProduct ),

              SliverPadding(
                padding: EdgeInsets.all(10),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.55,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        ( BuildContext context, int index ) {
                      return productGridView( snapshot.data[index], context );
                    },
                    childCount: snapshot.data.length,
                  ),
                ),
              )
            ],
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
