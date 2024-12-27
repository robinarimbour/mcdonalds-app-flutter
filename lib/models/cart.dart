import 'package:hive/hive.dart';
import 'package:mcdonalds_app/models/product.dart';

part 'cart.g.dart';

@HiveType(typeId: 0)
class Cart {
  @HiveField(0)
  List<CartItem> items;

  @HiveField(1)
  double totalPrice;

  Cart({required this.items, required this.totalPrice});

  List<CartItem> get getItems => items;
  double get getTotalPrice => totalPrice;

  int getCartQuantity() {
    return items.length;
  }

  int getProductQuantity(int productId) {
    int index = items.indexWhere((item) => item.product.id == productId);

    return index >= 0 ? items[index].quantity : 0;
  }

  int updateProductQuantity(Product product, int increment) {
    int index = items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      items[index].quantity += increment;

      calculateTotalPrice();

      if (items[index].quantity <= 0) {
        items.removeAt(index);
        return 0;
      }

      return items[index].quantity;
    } else {
      if (increment > 0) {
        items.add(CartItem(product: product, quantity: increment));
        calculateTotalPrice();
        return increment;
      }
    }

    return 0;
  }

  void calculateTotalPrice() {
    totalPrice = 0.0;

    for (var item in items) {
      totalPrice += item.product.price! * item.quantity;
    }
  }

  void clearCart() {
    items = [];
    totalPrice = 0.0;
  }
}

@HiveType(typeId: 1)
class CartItem {
  @HiveField(0)
  Product product;

  @HiveField(1)
  int quantity;

  CartItem({required this.product, required this.quantity});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['product'] = product.toJson();
    data['quantity'] = quantity;
    return data;
  }
}
