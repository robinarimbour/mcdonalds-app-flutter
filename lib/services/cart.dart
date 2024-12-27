import 'package:flutter/material.dart';
import 'package:mcdonalds_app/models/cart.dart';
import 'package:mcdonalds_app/models/cart_state.dart';
import 'package:mcdonalds_app/models/ipdata.dart';
import 'package:mcdonalds_app/models/transaction.dart';
import 'package:mcdonalds_app/models/product.dart';
import 'package:mcdonalds_app/services/api.dart';
import 'package:mcdonalds_app/services/boxes.dart';
import 'package:provider/provider.dart';

int getProductQuantityInCart(int productId) {
  int quantity = 0;
  Cart? cart = cartBox.get('myCart');
  if (cart != null) {
    quantity = cart.getProductQuantity(productId);
    // print('Get- $quantity');
  } else {
    // print("!!!!!! Cart not initialized");
  }

  return quantity;
}

int updateProductQuantityInCart(
    BuildContext context, Product product, int increment) {
  int quantity = 0;
  Cart? cart = cartBox.get('myCart');
  if (cart != null) {
    quantity = cart.updateProductQuantity(product, increment);

    // Update the cart item count
    Provider.of<CartState>(context, listen: false).updateItemCart();

    // Update the myCart box
    cartBox.put('myCart', cart);
    // print('Update- $quantity');
  } else {
    // print("!!!!!! Cart not initialized");
  }

  return quantity;
}

void clearCart(BuildContext context) {
  Cart? cart = cartBox.get('myCart');
  if (cart != null) {
    cart.clearCart();

    // Update the cart item count
    Provider.of<CartState>(context, listen: false).updateItemCart();

    // Update the myCart box
    cartBox.put('myCart', cart);
  } else {
    // print("!!!!!! Cart not initialized");
  }
}

double getSubTotal(int price, int quantity) {
  return (price * quantity).toDouble();
}

double getTax(double totalPrice) {
  return totalPrice * 0.1;
}

double getTotal(double totalPrice) {
  return totalPrice * 1.1;
}

Future<bool> completeOrder(
    Transaction transaction, BuildContext context) async {
  try {
    // Get IP Data
    IpData? ipData = await getIpData();
    transaction.ipData = ipData;

    // Post Transaction
    bool result = await postTransaction(transaction);
    if (!result) {
      return false;
    }

    // Clear cart
    if (context.mounted) {
      clearCart(context);
    }
    return true;
  } catch (e) {
    return false;
  }
}
