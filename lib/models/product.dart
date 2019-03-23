class Product {
  String title;
  int id;
  String permalink;
  String price;
  String regularPrice;
  String salePrice;
  int stockQuantity;
  String stockStatus;
  bool shippingRequired;
  bool shippingTaxable;
  String description;
  String shortDescription;
  bool reviewsAllowed;
  String averageRating;
  int ratingCount;
  List relatedIds;
  List categories;
  List tags;
  List images;
  List attributes;
  int totalSale;
  List variations;

  Product({this.title, this.id, this.permalink, this.regularPrice, this.price,
      this.salePrice, this.stockQuantity, this.stockStatus,
      this.shippingRequired, this.shippingTaxable,
      this.description, this.shortDescription, this.reviewsAllowed,
      this.averageRating, this.ratingCount, this.relatedIds, this.categories,
      this.tags, this.images, this.attributes,
      this.totalSale, this.variations});

  factory Product.fromJson(Map json) {
    return Product(
        title: json['name'],
        id: json['id'],
        permalink: json['permalink'],
        price: json['price'],
        regularPrice: json['regular_price'],
        salePrice: json['sale_price'],
        stockQuantity: json['stock_quantity'],
        stockStatus: json['stock_status'],
        shippingRequired: json['shipping_required'],
        shippingTaxable: json['shipping_taxable'],
        description: json['description'],
        shortDescription: json['short_description'],
        reviewsAllowed: json['reviews_allowed'],
        averageRating: json['average_rating'],
        ratingCount: json['rating_count'],
        relatedIds: json['related_ids'],
        categories: json['categories'],
        tags: json['tags'],
        images: json['images'],
        attributes: json['attributes'],
        totalSale: int.parse(json['total_sales'].toString()),
        variations: json['variations']
    );
  }
}