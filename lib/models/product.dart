
import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 2)
class Product {
  @HiveField(0)
  String? sId;

  @HiveField(1)
  int? id;

  @HiveField(2)
  String? name;

  @HiveField(3)
  List<String>? descriptions;

  @HiveField(4)
  String? imageGridUrl;
  
  @HiveField(5)
  String? imageFullUrl;
  
  @HiveField(6)
  int? price;

  Product(
      {this.sId,
      this.id,
      this.name,
      this.descriptions,
      this.imageGridUrl,
      this.imageFullUrl,
      this.price});

  Product.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    descriptions = json['descriptions'].cast<String>();
    imageGridUrl = json['imageGridUrl'];
    imageFullUrl = json['imageFullUrl'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['id'] = id;
    data['name'] = name;
    data['descriptions'] = descriptions;
    data['imageGridUrl'] = imageGridUrl;
    data['imageFullUrl'] = imageFullUrl;
    data['price'] = price;
    return data;
  }
}
