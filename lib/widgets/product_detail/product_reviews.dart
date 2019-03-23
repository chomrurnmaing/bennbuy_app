import 'package:bennbuy/methods.dart';
import 'package:bennbuy/models/product_review.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_html/flutter_html.dart';

class ProductReviews extends StatefulWidget {
  final int productId;
  final int ratingCount;
  ProductReviews(this.productId, this.ratingCount);
  
  @override
  _ProductReviewsState createState() => _ProductReviewsState();
}

class _ProductReviewsState extends State<ProductReviews> with TickerProviderStateMixin<ProductReviews>{
  int perPage = 5;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(milliseconds: 200),
      vsync: this,
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: FutureBuilder<List<ProductReview>>(
          future: getProductReviews(widget.productId, perPage: perPage),
          builder: (context, data){
            List<ProductReview> reviews;
            if( data.hasData ){
              reviews = data.data;
              return reviewListing(reviews);
            } else if (data.connectionState == ConnectionState.waiting) {
              reviews = data.requireData;
              return reviewListing(reviews);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget reviewListing(List<ProductReview> reviews){
    return Column(
      children: <Widget>[
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: reviews.map((review){
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300])
                ),
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SmoothStarRating(
                          size: 16,
                          allowHalfRating: true,
                          borderColor: Colors.black,
                          rating: review.rating ?? 0.0,
                          color: Colors.black,
                        ),

                        Text(dateConverter(review.dateCreated), style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                    Html(
                      data: review.review,
                      padding: EdgeInsets.all(0),
                      renderNewlines: true,
                      defaultTextStyle: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      review.reviewer,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
              );
            }).toList()
        ),
        perPage < widget.ratingCount ? Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          child: InkWell(
            onTap: (){
              setState(() {
                perPage+=5;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all()
              ),
              child: Text('See More Reviews',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ) : Container(),
      ],
    );
  }
}
