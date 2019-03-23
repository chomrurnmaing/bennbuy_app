import 'package:flutter/material.dart';

class DetailScreenFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: <Widget>[
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: (){},
                  child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: Text('Help Center', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: (){},
                  child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: Text('Privacy Policy', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: (){},
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    child: Text('Terms and Conditions', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
