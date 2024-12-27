class ProductCategory {
  String? sId;
  int? id;
  String? name;
  List<int>? products;

  ProductCategory({this.sId, this.id, this.name, this.products});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    products = json['products'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['id'] = id;
    data['name'] = name;
    data['products'] = products;
    return data;
  }
}
