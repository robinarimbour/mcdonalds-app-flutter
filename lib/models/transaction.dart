import 'package:mcdonalds_app/models/cart.dart';
import 'package:mcdonalds_app/models/checkout_form.dart';
import 'package:mcdonalds_app/models/ipdata.dart';

class Transaction {
  List<CartItem> cartItems;
  double tax;
  double totalPrice;
  CheckoutForm checkoutForm;
  IpData? ipData;

  Transaction(
      {required this.cartItems,
      required this.tax,
      required this.totalPrice,
      required this.checkoutForm,
      this.ipData});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['cartItems'] = cartItems.map((v) => v.toJson()).toList();
    data['tax'] = tax;
    data['totalPrice'] = totalPrice;
    data['checkoutForm'] = checkoutForm.toJson();
    if (ipData != null) {
      data['ipData'] = ipData!.toJson();
    }
    return data;
  }
}
