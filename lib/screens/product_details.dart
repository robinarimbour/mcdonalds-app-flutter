import 'package:flutter/material.dart';
import 'package:mcdonalds_app/models/product.dart';
import 'package:mcdonalds_app/services/api.dart';
import 'package:mcdonalds_app/services/cart.dart';
import 'package:mcdonalds_app/widgets/error_message.dart';
import 'package:mcdonalds_app/widgets/loading.dart';
import 'package:mcdonalds_app/widgets/product_details.dart';
import 'package:text_scroll/text_scroll.dart';

class ProductDetails extends StatefulWidget {
  final int productId;

  const ProductDetails({super.key, required this.productId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late Future<Product> futureProduct;
  late int quantity;
  String? appBarTitle;

  void updateQuantity(BuildContext context, int increment) {
    futureProduct.then((product) {
      if (!context.mounted) return;

      int newQuantity =
          updateProductQuantityInCart(context, product, increment);

      setState(() {
        quantity = newQuantity;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    futureProduct = getProduct(widget.productId);
    quantity = getProductQuantityInCart(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: appBarTitle == null
            ? Text("Loading...")
            : TextScroll(
                appBarTitle!,
                mode: TextScrollMode.endless,
                pauseBetween: Duration(seconds: 1),
                velocity: Velocity(pixelsPerSecond: Offset(30, 0)),
                selectable: true,
                intervalSpaces: 10,
              ),
        actions: [
          const SizedBox(
            width: 50.0,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Product>(
          future: futureProduct,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Update appBarTitle when data is loaded
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (appBarTitle != snapshot.data!.name!) {
                  setState(() {
                    appBarTitle = snapshot.data!.name!;
                  });
                }
              });

              return Container(
                padding: EdgeInsets.fromLTRB(12.0, 30.0, 12.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductDetailsWidget(product: snapshot.data!),
                    (quantity == 0)
                        ? ElevatedButton(
                            onPressed: () {
                              updateQuantity(context, 1);
                            },
                            child: Text("Add to Cart"))
                        : Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    updateQuantity(context, -1);
                                  },
                                  icon: Icon(Icons.remove)),
                              OutlinedButton(
                                  onPressed: null,
                                  child: Text(quantity.toString())),
                              IconButton(
                                  onPressed: () {
                                    updateQuantity(context, 1);
                                  },
                                  icon: Icon(Icons.add)),
                            ],
                          )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  child: ErrorMessage());
            }
            
            return Loading();
          },
        ),
      ),
    );
  }
}
