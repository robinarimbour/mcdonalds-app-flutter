import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mcdonalds_app/models/cart.dart';
import 'package:mcdonalds_app/models/cart_state.dart';
import 'package:mcdonalds_app/models/product.dart';
import 'package:mcdonalds_app/screens/splash.dart';
import 'package:mcdonalds_app/services/boxes.dart';
import 'package:provider/provider.dart';

void main() async {
  // Initialize hive
  await Hive.initFlutter();

  // Register the adapters
  Hive.registerAdapter(CartAdapter());
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(ProductAdapter());

  // Open the boxes
  cartBox = await Hive.openBox<Cart>('cartBox');

  // Init the myCart
  Cart? cart = cartBox.get('myCart');
  if (cart == null) {
    Cart cart = Cart(items: [], totalPrice: 0.0);
    await cartBox.put('myCart', cart);
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            final cartState = CartState();
            cartState.initializeCart();
            return cartState;
          }),
        ],
        child: MaterialApp(
          home: Splash(),
          theme: getAppTheme(context),
        ));
  }
}

ThemeData getAppTheme(BuildContext context) {
  Color primaryColor = Color.fromARGB(255, 253, 201, 47);
  Color disabledColor = Colors.grey[300]!;
  WidgetStateProperty<Color> buttonBackgroundColor =
      WidgetStateProperty.resolveWith<Color>((states) {
    if (states.contains(WidgetState.disabled)) {
      return disabledColor; // Disabled state color
    }
    return primaryColor; // Default color for other states
  });
  WidgetStateProperty<OutlinedBorder> buttonShape =
      WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)));
  WidgetStateProperty<TextStyle> buttonTextStyle =
      WidgetStateProperty.all<TextStyle>(TextTheme.of(context).titleMedium!);

  return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      primaryColor: primaryColor,
      // fontFamily: 'Roboto',
      appBarTheme:
          AppBarTheme(backgroundColor: primaryColor, toolbarHeight: 48.0),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: primaryColor,
        height: 54.0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(backgroundColor: buttonBackgroundColor, shape: buttonShape, textStyle: buttonTextStyle)
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(shape: buttonShape, textStyle: buttonTextStyle)),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
              backgroundColor: buttonBackgroundColor, shape: buttonShape)),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(shape: buttonShape, textStyle: buttonTextStyle)),
      inputDecorationTheme: InputDecorationTheme(
          alignLabelWithHint: true, border: OutlineInputBorder()));
}
