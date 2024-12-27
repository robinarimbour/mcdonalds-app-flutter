import 'package:flutter/material.dart';
import 'package:mcdonalds_app/models/cart_state.dart';
import 'package:mcdonalds_app/screens/about.dart';
import 'package:mcdonalds_app/screens/cart.dart';
import 'package:mcdonalds_app/screens/home.dart';
import 'package:mcdonalds_app/screens/menu.dart';
import 'package:provider/provider.dart';

class Base extends StatefulWidget {
  const Base({super.key});

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  int _currentPageIndex = 0;

  void _updateIndex(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  // Screens for each tab
  List<Widget> get _screens => [
        Home(onIndexChange: (index) => _updateIndex(index)),
        Menu(),
        CartScreen(),
      ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: [
          Text('Home'),
          Text('Our Menu'),
          Text('Cart')
        ][_currentPageIndex],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                child: Container(
                    padding: EdgeInsets.all(12.0),
                    child: Image.asset(
                        'assets/images/mcdonalds_golden_arches.png',
                        semanticLabel: 'McDonalds Logo'))),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const About()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (int index) {
          _updateIndex(index);
        },
        selectedIndex: _currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.menu_book),
            icon: Icon(Icons.menu_book_outlined),
            label: 'Menu',
          ),
          Consumer<CartState>(
            builder: (context, value, child) => NavigationDestination(
              selectedIcon: (value.itemCount > 0)
                  ? Badge(
                      label: Text(value.itemCount.toString()),
                      child: Icon(Icons.shopping_cart),
                    )
                  : Icon(Icons.shopping_cart),
              icon: (value.itemCount > 0)
                  ? Badge(
                      label: Text(value.itemCount.toString()),
                      child: Icon(Icons.shopping_cart_outlined),
                    )
                  : Icon(Icons.shopping_cart_outlined),
              label: 'Cart',
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 25.0),
        child: IndexedStack(
          index: _currentPageIndex,
          children: _screens,
        ),
      ),
    );
  }
}
