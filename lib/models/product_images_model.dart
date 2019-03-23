
class ProductImagesModel {

  final int index;
  final int id;
  final String src;
  final String title;

  ProductImagesModel({
      this.index,
      this.id,
      this.src,
      this.title});

  factory ProductImagesModel.fromJson(int index, Map<String, dynamic> data) {
    return ProductImagesModel(
      index: index,
      id: data['id'],
      src: data['src'],
      title: data['name'],
    );
  }
}