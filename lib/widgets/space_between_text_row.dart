import 'package:flutter/material.dart';

class SpaceBetweenTextRow extends StatelessWidget {
  final String label;
  final String value;

  const SpaceBetweenTextRow(
      {super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label, style: TextTheme.of(context).titleMedium),
        ),
        Text(value, style: TextTheme.of(context).titleMedium),
      ],
    );
  }
}
