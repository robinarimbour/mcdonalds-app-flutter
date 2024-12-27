import 'package:flutter/material.dart';
import 'package:mcdonalds_app/models/product.dart';

class ProductDetailsWidget extends StatelessWidget {
  final Product product;

  const ProductDetailsWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InteractiveViewer(
          child: Center(
            child: Image.network(
                      product.imageFullUrl!,
                      semanticLabel: '${product.name} Image',
                      fit: BoxFit.fitHeight,
                    ),
          ),
        ),
        SizedBox(height: 66.0),
        Text(product.name!,
            style: TextTheme.of(context)
                .headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(product.descriptions!.length,
              (index) => Text(product.descriptions![index])),
        ),
        SizedBox(height: 20.0),
        Text(
          '\$ ${product.price!.toDouble().toStringAsFixed(2)}',
          style: TextTheme.of(context)
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
