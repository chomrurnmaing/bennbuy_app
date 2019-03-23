class ProductReview {
  int id;
  String dateCreated;
  String dateCreatedGmt;
  int productId;
  String status;
  String reviewer;
  String reviewerEmail;
  String review;
  double rating;
  bool verified;
  Map reviewerAvatarUrls;

  ProductReview(
      {this.id,
      this.dateCreated,
      this.dateCreatedGmt,
      this.productId,
      this.status,
      this.reviewer,
      this.reviewerEmail,
      this.review,
      this.rating,
      this.verified,
      this.reviewerAvatarUrls});

  factory ProductReview.fromJson(Map data) {
    return ProductReview(
        id: data['id'],
        dateCreated: data['date_created'],
        dateCreatedGmt: data['date_created_gmt'],
        productId: data['product_id'],
        status: data['status'],
        reviewer: data['reviewer'],
        reviewerEmail: data['reviewer_email'],
        review: data['review'],
        rating: data['rating'].toDouble(),
        verified: data['verified'],
        reviewerAvatarUrls: data['reviewer_avatar_urls']);
  }
}
