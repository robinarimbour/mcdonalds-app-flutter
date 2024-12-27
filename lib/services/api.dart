import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mcdonalds_app/models/category.dart';
import 'package:mcdonalds_app/models/image_url.dart';
import 'package:mcdonalds_app/models/ipdata.dart';
import 'package:mcdonalds_app/models/product.dart';
import 'package:mcdonalds_app/models/transaction.dart';
import 'package:mcdonalds_app/services/api_endpoints.dart';

final dio = Dio();

Future<ImageUrl> getImageUrl(int id) async {
  // await Future.delayed(Duration(seconds: 3));
  // throw Error();
  final Response response = await dio.get('$imageUrlEndpoint/$id');
  Map<String, dynamic> responseJson = response.data;
  ImageUrl imageUrl = ImageUrl.fromJson(responseJson);
  return imageUrl;
}

Future<List<ProductCategory>> getProductCategories() async {
  // await Future.delayed(Duration(seconds: 3));
  // throw Error();
  final Response response = await dio.get(categoriesEndpoint);
  List<dynamic> responseJson = response.data;
  List<ProductCategory> categories = List.generate(responseJson.length,
      (index) => ProductCategory.fromJson(responseJson[index]));
  return categories;
}

Future<Product> getProduct(int id) async {
  // await Future.delayed(Duration(seconds: 3));
  // throw Error();
  final Response response = await dio.get('$productEndpoint/$id');
  Map<String, dynamic> responseJson = response.data;
  Product product = Product.fromJson(responseJson);
  return product;
}

Future<IpData?> getIpData() async {
  try {
    // await Future.delayed(Duration(seconds: 3));
    // throw Error();
    final Response response = await dio.get(ipDataEndpoint);
    Map<String, dynamic> responseJson = jsonDecode(response.data);
    IpData ipData = IpData.fromJson(responseJson);
    return ipData;
  } catch (e) {
    // print(e);
    return null;
  }
}

Future<bool> postTransaction(Transaction transaction) async {
  try {
    // await Future.delayed(Duration(seconds: 3));
    // throw Error();
    Map<String, dynamic> data = transaction.toJson();
    final Response response = await dio.post(transactionEndpoint, data: data);
    if (response.statusCode == 200) {
      return true;
    } else {
      // print('${response.statusCode} ${response.statusMessage}');
      // print('${response.data}');
      return false;
    }
  } catch(e) { 
    // print(e);
    return false;
  }
}
