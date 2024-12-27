import 'package:flutter/material.dart';
import 'package:mcdonalds_app/models/cart.dart';
import 'package:mcdonalds_app/services/boxes.dart';

class CartState extends ChangeNotifier {
  int _itemCount = 0;
  List<CartItem> _cartItems = [];
  double _totalPrice = 0.0;

  int get itemCount => _itemCount;
  List<CartItem> get cartItems => _cartItems;
  double get totalPrice => _totalPrice;

  void updateItemCart() {
    Cart? cart = cartBox.get('myCart');
    _itemCount = cart != null ? cart.getCartQuantity() : 0;
    _cartItems = cart != null ? cart.getItems : [];
    _totalPrice = cart != null ? cart.getTotalPrice : 0.0;
    notifyListeners();
  }

  void initializeCart() {
    Cart? cart = cartBox.get('myCart');
    _itemCount = cart != null ? cart.getCartQuantity() : 0;
    _cartItems = cart != null ? cart.getItems : [];
    _totalPrice = cart != null ? cart.getTotalPrice : 0.0;
    notifyListeners();
  }

  void refreshCart() {
    notifyListeners();
  }
}
