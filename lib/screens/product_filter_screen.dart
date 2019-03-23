import 'package:bennbuy/methods.dart';
import 'package:bennbuy/models/product_attribute.dart';
import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:bennbuy/widgets/product_attribute/prod_attribute_terms.dart';
import 'package:flutter/material.dart';

class ProductFilterScreen extends StatefulWidget {
  @override
  _ProductFilterScreenState createState() => _ProductFilterScreenState();
}

class _ProductFilterScreenState extends State<ProductFilterScreen> {
  String url = 'https://bennbuy.com/wp-json/wc/v3/products/attributes?consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filter'),),
      body: FutureBuilder<List<ProductAttribute>>(
        future: getProductAttribute( url ),
        builder: (BuildContext context, attributes) {
          if ( attributes.hasData ) {
            var attrs = attributes.data;
            return ListView.builder(
              itemCount: attrs.length,
              itemBuilder: (BuildContext context, int i){
                return ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProdAttributeTerms(attrs[i].id, attrs[i].name)));
                  },
                  title: Text(attrs[i].name),
                  trailing: Icon(Icons.navigate_next),
                );
              },
            );

          } else if ( attributes.hasError ) {
            return Container();
          } else {
            return circularLoading();
          }
        }
      ),
    );
  }
}
