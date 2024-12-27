import 'package:flutter/material.dart';
import 'package:mcdonalds_app/models/product.dart';
import 'package:mcdonalds_app/screens/product_details.dart';
import 'package:mcdonalds_app/services/api.dart';
import 'package:mcdonalds_app/widgets/error_message.dart';

class ProductMenu extends StatefulWidget {
  final int productId;

  const ProductMenu({super.key, required this.productId});

  @override
  State<ProductMenu> createState() => _ProductMenuState();
}

class _ProductMenuState extends State<ProductMenu>
    with AutomaticKeepAliveClientMixin {
  late Future<Product> futureProduct;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    futureProduct = getProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: FutureBuilder<Product>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductDetails(productId: widget.productId)));
              },
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Image.network(
                            snapshot.data!.imageGridUrl!,
                            semanticLabel: '${snapshot.data!.name} Image',
                            fit: BoxFit.cover,
                            height: 120.0,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            snapshot.data!.name!,
                            style: TextTheme.of(context).titleMedium,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return ErrorMessage();
          }
          // By default, show a loading spinner.
          return Center(child: const CircularProgressIndicator());
        },
      ),
    );
  }
}
