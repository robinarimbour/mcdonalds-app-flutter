import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10.0,
          children: [
            Text('Oops!',
                style: TextTheme.of(context)
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text('Something went wrong. Please try again later.',
                style: TextTheme.of(context)
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
          ],
        )));
  }
}
