import 'package:flutter/material.dart';
import 'package:mcdonalds_app/models/product.dart';
import 'package:mcdonalds_app/screens/product_details.dart';
import 'package:mcdonalds_app/services/api.dart';
import 'package:mcdonalds_app/services/cart.dart';
import 'package:mcdonalds_app/widgets/error_message.dart';

class ProductCart extends StatefulWidget {
  final int productId;

  const ProductCart({super.key, required this.productId});

  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart>
    with AutomaticKeepAliveClientMixin {
  late Future<Product> futureProduct;
  late int quantity;
  late double subTotal = 0.0;

  void updateQuantity(BuildContext context, int increment, int price) {
    futureProduct.then((product) {
      if (!context.mounted) return;

      int updatedQuantity =
          updateProductQuantityInCart(context, product, increment);

      setState(() {
        quantity = updatedQuantity;
        updateSubTotal(price);
      });
    });
  }

  void updateSubTotal(int price) {
    subTotal = (quantity * price).toDouble();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    futureProduct = getProduct(widget.productId);
    quantity = getProductQuantityInCart(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    quantity = getProductQuantityInCart(widget.productId);
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(5.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<Product>(
          future: futureProduct,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              if (snapshot.hasData) {
                updateSubTotal(snapshot.data!.price!);

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10.0,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                      productId: widget.productId)));
                        },
                        child: Image.network(
                          snapshot.data!.imageGridUrl!,
                          semanticLabel: '${snapshot.data!.name} Image',
                          fit: BoxFit.cover,
                          width: 150.0,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshot.data!.name!,
                                style: TextTheme.of(context).titleMedium),
                            Text(
                                'Price: \$${snapshot.data!.price!.toDouble().toStringAsFixed(2)}'),
                            Text('Quantity: $quantity'),
                            Text('Subtotal: \$${subTotal.toStringAsFixed(2)}'),
                            SizedBox(height: 8.0),
                            Wrap(
                              children: [
                                SizedBox(
                                  height: 30.0,
                                  child: IconButton(
                                    onPressed: () {
                                      updateQuantity(
                                          context, -1, snapshot.data!.price!);
                                    },
                                    icon: Icon(Icons.remove),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                  child: OutlinedButton(
                                      onPressed: null,
                                      child: Text(quantity.toString())),
                                ),
                                SizedBox(
                                  height: 30.0,
                                  child: IconButton(
                                    onPressed: () {
                                      updateQuantity(
                                          context, 1, snapshot.data!.price!);
                                    },
                                    icon: Icon(Icons.add),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return ErrorMessage();
              }
            }

            // By default, show a loading spinner.
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(child: const CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
