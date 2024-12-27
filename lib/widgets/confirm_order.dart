import 'package:flutter/material.dart';
import 'package:mcdonalds_app/models/cart.dart';
import 'package:mcdonalds_app/models/checkout_form.dart';
import 'package:mcdonalds_app/services/cart.dart';
import 'package:mcdonalds_app/widgets/space_between_text_row.dart';

class ConfirmOrder extends StatelessWidget {
  final List<CartItem> cartItems;
  final double totalPrice;
  final double tax;
  final CheckoutForm checkoutForm;

  const ConfirmOrder(
      {super.key,
      required this.cartItems,
      required this.totalPrice,
      required this.tax,
      required this.checkoutForm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Transaction'),
      scrollable: true,
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.0,
            children: [
              Text('Order Details',
                  style: TextTheme.of(context)
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              Column(
                children: List.generate(
                    cartItems.length,
                    (index) => SpaceBetweenTextRow(
                        label:
                            '${cartItems[index].product.name!} (${cartItems[index].quantity}):',
                        value:
                            '\$ ${getSubTotal(cartItems[index].product.price!, cartItems[index].quantity).toStringAsFixed(2)}')),
              ),
              SpaceBetweenTextRow(
                  label: 'Estimated Tax:',
                  value: '\$ ${tax.toStringAsFixed(2)}'),
              SpaceBetweenTextRow(
                  label: 'Total:',
                  value: '\$ ${totalPrice.toStringAsFixed(2)}'),
              SizedBox(height: 10.0),
              Text('Payment Details',
                  style: TextTheme.of(context)
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              SpaceBetweenTextRow(
                  label: 'Name:',
                  value: '${checkoutForm.firstName} ${checkoutForm.lastName}'),
              SpaceBetweenTextRow(
                  label: 'Phone Number:', value: checkoutForm.phone),
              SpaceBetweenTextRow(
                  label: 'Credit Card:',
                  value:
                      'XXXX-XXXX-XXXX-${checkoutForm.creditCard.substring(checkoutForm.creditCard.length - 4)}'),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Back'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        ElevatedButton(
          child: const Text('Confirm'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
