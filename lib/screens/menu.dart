import 'package:flutter/material.dart';
import 'package:mcdonalds_app/models/category.dart';
import 'package:mcdonalds_app/screens/error_screen.dart';
import 'package:mcdonalds_app/services/api.dart';
import 'package:mcdonalds_app/widgets/category.dart';
import 'package:mcdonalds_app/widgets/loading.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late Future<List<ProductCategory>> futureCategories;

  Future<void> _pullRefresh() async {
    setState(() {
      futureCategories = getProductCategories();
    });
  }

  @override
  void initState() {
    super.initState();
    futureCategories = getProductCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductCategory>>(
      future: futureCategories,
      builder: (context, snapshot) {
        return RefreshIndicator(
            onRefresh: _pullRefresh, child: _menuContent(snapshot));
      },
    );
  }

  Widget _menuContent(AsyncSnapshot snapshot) {
    if (snapshot.connectionState != ConnectionState.waiting) {
      if (snapshot.hasData) {
        return ListView.builder(
          shrinkWrap: true,
          addAutomaticKeepAlives: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) =>
              ProductCategoryWidget(category: snapshot.data![index]),
        );
      } else if (snapshot.hasError) {
        return ErrorScreen();
      }
    }

    // By default, show a loading spinner.
    return Loading();
  }
}
