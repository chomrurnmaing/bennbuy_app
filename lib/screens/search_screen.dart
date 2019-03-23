import 'package:bennbuy/methods.dart';
import 'package:bennbuy/models/product_search.dart';
import 'package:bennbuy/widgets/bottom_nav_bar.dart';
import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController _filter = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  String keyword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filter.addListener(onChange);
    _textFocus.addListener(onChange);
  }

  void onChange(){

    setState(() {
      keyword = _filter.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      appBar: AppBar(
        title: TextField(
          controller: _filter,
          focusNode: _textFocus,
          decoration: new InputDecoration(
            hintText: 'Search...',
          ),
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: FutureBuilder<List<ProductSearch>>(
        future: productSearch(keyword),
        builder: (context, snapshot){
          if( snapshot.hasData ) {
            if ( snapshot.data.length > 0 ){
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i){
                  return ListTile(
                    onTap: (){
                      Navigator.pushNamed(context, '/product-detail/${snapshot.data[i].id}');
                    },
                    title: Text(snapshot.data[i].title, maxLines: 1, overflow: TextOverflow.ellipsis,),
                  );
                },
              );  
            } else {
              Container(
                alignment: Alignment.center,
                child: Text('Noting found! Please try another keywords.'),
              );
            }

          } else if(snapshot.connectionState == ConnectionState.waiting){
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          } else if(snapshot.hasError){
            return Container(
              alignment: Alignment.center,
              child: pageError('Something went wrong!'),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
