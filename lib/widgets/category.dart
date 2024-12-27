import 'package:flutter/material.dart';
import 'package:mcdonalds_app/models/category.dart';
import 'package:mcdonalds_app/widgets/product_menu.dart';

class ProductCategoryWidget extends StatefulWidget {
  final ProductCategory category;

  const ProductCategoryWidget({super.key, required this.category});

  @override
  State<ProductCategoryWidget> createState() => _ProductCategoryWidgetState();
}

class _ProductCategoryWidgetState extends State<ProductCategoryWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.category.name!,
              style: TextTheme.of(context)
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(
            height: 18.0,
          ),
          GridView.count(
            addAutomaticKeepAlives: true,
            primary: false,
            shrinkWrap: true,
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? 4
                    : 2,
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 6.0,
            childAspectRatio: 0.9,
            children: List.generate(widget.category.products!.length,
                (index) => ProductMenu(productId: widget.category.products![index])),
          )
        ],
      ),
    );
  }
}
