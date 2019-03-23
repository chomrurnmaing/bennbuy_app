import 'package:bennbuy/helpers/authentication.dart';
import 'package:bennbuy/models/user.dart';
import 'package:bennbuy/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:bennbuy/helpers/validations.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateReviewForm extends StatefulWidget {
  final double rating;
  final int ratingCount;
  final productId;

  CreateReviewForm({
    @required this.ratingCount,
    @required this.rating,
    @required this.productId
  });

  @override
  _CreateReviewFormState createState() => _CreateReviewFormState();
}

class _CreateReviewFormState extends State<CreateReviewForm> with TickerProviderStateMixin {
  bool isUserCommenting;
  bool btnLoaded;
  double customerRatings;
  bool _autoValidate;
  String customerRatingsText;


  User userInfo = new User();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController commentController = new TextEditingController();

  _getUserInfo(){
    if ( Authentication.isLogin ) {
      http.get('https://bennbuy.com/api/user/get_user_meta/?cookie=${Authentication.userCookie}').then((response){
        final user = json.decode(response.body);

        setState(() {
          userInfo.firstName = user['first_name'];
          userInfo.lastName = user['last_name'];
          userInfo.email = user['email'];
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserInfo();

    isUserCommenting = false;
    customerRatings = 0.0;
    customerRatingsText = 'Please rate this product.';
    _autoValidate = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        bottomBorderHeading('Review'),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              SmoothStarRating(
                size: 26,
                allowHalfRating: false,
                borderColor: Colors.black,
                rating: widget.rating ?? 0.0,
                color: Colors.black,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('${widget.ratingCount ?? 0} Reviews',
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey
                    )),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 10),
          child: !isUserCommenting ? primaryButton('Write a Review', onTapReview) : primaryButtonWithLoading('Submit Now', onTapSubmitReview, btnLoaded ?? true, vsync: this),
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 200),
          vsync: this,
          child: isUserCommenting ? Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Form(key: _formKey, child: TextFormField(
              autovalidate: _autoValidate ?? false,
              controller: commentController,
              keyboardType: TextInputType.text,
              maxLines: 5,
              validator: (val) => requiredValidator(val),
              decoration: InputDecoration(
                hintText: 'Write down your comment here!',
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.black)),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(0)),
              ),
            )),
          ) : Container(),
        ),
        AnimatedSize(
          vsync: this,
          duration: Duration(milliseconds: 200),
          child: isUserCommenting ? Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                SmoothStarRating(
                  size: 26,
                  allowHalfRating: false,
                  borderColor: Colors.black,
                  rating: customerRatings ?? 0.0,
                  color: Colors.black,
                  onRatingChanged: onRatingChange,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(customerRatingsText ?? '',
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black
                    )),
                ),
              ],
            ),
          ) : Container(),
        ),
        SizedBox(height: 15,),
      ],
    );
  }



  void onRatingChange(double ratings){
    setState(() {
      customerRatings = ratings;
      customerRatingsText = 'You rated $ratings to this product.';
    });
  }

  void onTapSubmitReview() {

    if ( _formKey.currentState.validate() ) {
      _formKey.currentState.save();
      setState(() {
        btnLoaded = false;
      });
      var url = 'https://bennbuy.com/wp-json/wc/v3/products/reviews?consumer_key=ck_05bbedd9f47eb253d46b414bff1266747b70ce53&consumer_secret=cs_4775677bde4935bec50f6e0b95cf745dd5e220c2';

      http.post(url, body: {
        'product_id': widget.productId.toString(),
        'reviewer': userInfo.firstName + ' ' + userInfo.lastName,
        'reviewer_email': userInfo.email,
        'review': commentController.text,
        'rating': customerRatings.toString()
      }).then((response){
        final data = json.decode(response.body);
        setState(() {
          btnLoaded = true;
        });
        if ( data['code'] == null ) {
          setState(() {
            _autoValidate = false;
            isUserCommenting = false;
            customerRatingsText = 'Please rate this product.';
            customerRatings = 0;
            commentController.text = '';
          });
        }
      });

    } else {
      setState(() {
        btnLoaded = true;
        _autoValidate = true;
        isUserCommenting = true;
      });
    }

  }

  void onTapReview() {
    if ( Authentication.isLogin ) {
      setState(() {
        isUserCommenting = true;
      });
    } else {
      setState(() {
        isUserCommenting = false;
      });
      Navigator.pushNamed(context, '/acc-management/0/false');
    }
  }
}
