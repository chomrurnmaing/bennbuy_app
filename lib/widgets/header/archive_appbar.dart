import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';


class ArchiveAppBar extends StatefulWidget {
  final Function orderProduct;

  ArchiveAppBar(this.orderProduct);

  @override
  _ArchiveAppBarState createState() => _ArchiveAppBarState();
}

class _ArchiveAppBarState extends State<ArchiveAppBar> {
  List<Map> _orderBy = [{
    'slug': 'popularity',
    'name': 'Popularity'
  },
  {
    'slug': 'average-rating',
    'name': 'Average Rating'
  },
  {
    'slug': 'latest',
    'name': 'Latest'
  },
  {
    'slug': 'price-low-to-high',
    'name': 'Price: low to high'
  },
  {
    'slug': 'price-high-to-low',
    'name': 'Price: high to low'
  }];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String selectedItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dropDownMenuItems = getDropDownMenuItems();
    selectedItem = _orderBy[0]['slug'];
  }

  void changedDropDownItem(String orderBy) {
    String by;
    String order;

    switch(orderBy){
      case 'popularity':
        by = 'popularity';
        break;
      case 'average-rating':
        by = 'rating';
        break;
      case 'latest':
        by = 'date';
        break;
      case 'price-low-to-high':
        by = 'price';
        order = 'asc';
        break;
      case 'price-high-to-low':
        by = 'price';
        order = 'desc';
        break;

    }
    setState(() {
      widget.orderProduct(by, order: order ?? 'desc');
      selectedItem = orderBy;
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (Map order in _orderBy) {
      items.add(DropdownMenuItem(
        value: order['slug'],
        child: Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(order['name'], overflow: TextOverflow.fade,),
        )
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      forceElevated: true,
      elevation: 2.0,
      floating: true,
      pinned: false,
      centerTitle: true,
      title: Text('BENNBUY',
        style: TextStyle(
            fontFamily: 'Muli',
            fontWeight: FontWeight.w300
        ),),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              Navigator.pushNamed(context, '/search');
            }),
        cartCount(context)
      ],
      bottom: PreferredSize(
        child: Container(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 1,
                decoration: BoxDecoration(
                    color: Colors.grey[200]
                ),
              ),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        padding: EdgeInsets.all(0),
                        child: DropdownButton(
                          value: selectedItem,
                          items: _dropDownMenuItems,
                          onChanged: changedDropDownItem,
                        ),
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
        preferredSize: Size(double.infinity, 60)),
    );
  }
}
