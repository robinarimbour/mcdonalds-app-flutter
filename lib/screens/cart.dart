import 'package:flutter/material.dart';
import 'package:mcdonalds_app/models/cart_state.dart';
import 'package:mcdonalds_app/screens/checkout.dart';
import 'package:mcdonalds_app/services/cart.dart';
import 'package:mcdonalds_app/widgets/product_cart.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> _pullRefresh() async {
    Provider.of<CartState>(context, listen: false).refreshCart();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartState>(builder: (context, value, child) {
      return RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: (value.itemCount == 0)
                  ? _buildEmptyCart(context)
                  : _buildFilledCart(context, value)),
        ),
      );
    });
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10.0,
        children: [
          SizedBox(
            child: Center(
              child: Image.asset('assets/images/empty_mcdonalds.jpg',
                  height: 200.0, semanticLabel: 'Empty Cart'),
            ),
          ),
          SizedBox(height: 30.0),
          Text('Looks like your cart is empty!',
              style: TextTheme.of(context)
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          Text('Add some products to view your cart.',
              style: TextTheme.of(context)
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _buildFilledCart(BuildContext context, CartState value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
              onPressed: () {
                clearCart(context);
              },
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Clear Cart", style: TextStyle(color: Colors.white))),
        ),
        SizedBox(height: 10.0),
        ListView(
          shrinkWrap: true,
          addAutomaticKeepAlives: true,
          physics: NeverScrollableScrollPhysics(),
          children: List.generate(
              value.cartItems.length,
              (index) => ProductCart(
                  key: ValueKey(value.cartItems[index].product.id),
                  productId: value.cartItems[index].product.id!)),
        ),
        SizedBox(height: 10.0),
        Text(
          'Total: \$${value.totalPrice}*',
          style: TextTheme.of(context)
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text('* Shipping charges may apply.'),
        SizedBox(height: 10.0),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Checkout(
                          cartItems: value.cartItems,
                          totalPrice: value.totalPrice)));
            },
            child: Text("Checkout")),
      ],
    );
  }
}
