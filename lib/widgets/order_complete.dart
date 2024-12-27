import 'package:flutter/material.dart';
import 'package:mcdonalds_app/models/transaction.dart';
import 'package:mcdonalds_app/services/cart.dart';

class OrderComplete extends StatefulWidget {
  final Transaction transaction;
  final void Function(bool) onApiCallComplete;

  const OrderComplete({super.key, required this.transaction, required this.onApiCallComplete});

  @override
  State<OrderComplete> createState() => _OrderCompleteState();
}

class _OrderCompleteState extends State<OrderComplete> {
  void performApiCall() async {
    bool success = await completeOrder(widget.transaction, context);

    widget.onApiCallComplete(success);
  }
  
  @override
  void initState() {
    super.initState();
    performApiCall();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
          child: Column(
            spacing: 10.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/images/mcdonalds_order.gif', height: 250.0, semanticLabel: 'Completed Order Animation')),
              SizedBox(height: 20.0),
              Text('Your order has been confirmed!',
                  style: TextTheme.of(context)
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              Text('Processing your transaction....',
                  style: TextTheme.of(context)
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
