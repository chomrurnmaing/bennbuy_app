class ProductSearch{
  int id;
  String title;
  String slug;

  ProductSearch({
    this.id,
    this.title,
    this.slug
  });

  factory ProductSearch.fromJson(Map data){
    return ProductSearch(
      id: data['id'],
      title: data['name'],
      slug: data['slug']
    );
  }
}