import 'package:bennbuy/methods.dart';
import 'package:bennbuy/models/product_attribute_term.dart';
import 'package:flutter/material.dart';

class ProdAttributeTerms extends StatefulWidget {
  final int termId;
  final String name;

  ProdAttributeTerms(this.termId, this.name);

  @override
  _ProdAttributeTermsState createState() => _ProdAttributeTermsState();
}

class _ProdAttributeTermsState extends State<ProdAttributeTerms> {
  String url;
  List<bool> selectedItems;
  bool loaded = false;
  List<ProductAttributeTerm> terms = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    url = 'https://bennbuy.com/wp-json/wc/v3/products/attributes/${widget.termId}/terms?consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2';

    getProductAttributeTerm(url).then((List<ProductAttributeTerm> attrTerms){
      setState(() {
        if ( attrTerms.length > 0 ){
          terms = attrTerms;
          selectedItems = new List.filled(attrTerms.length, false);
          loaded = true;
        } else {
          loaded = false;
        }
      });
    });
  }

  Widget _itemsList() {
    return Container(
      alignment: Alignment.center,
      child: ListView.builder(
        itemCount: terms.length,
        itemBuilder: (BuildContext context, int i){
          return InkWell(
            onTap: (){
              setState(() {
                selectedItems[i] = !selectedItems[i];
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: selectedItems[i],
                    onChanged: (bool value){
                      setState(() {
                        selectedItems[i] = value;
                      });
                    },
                  ),
                  SizedBox(width: 10,),
                  Text(terms[i].name, style: TextStyle(fontSize: 16),)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _loadingWidget() {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              setState(() {
                selectedItems = List.filled(terms.length, false);
              });
            },
            child: Text('CLEAR ALL'),
          )
        ],
      ),
      body: loaded ? _itemsList() : _loadingWidget()
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
