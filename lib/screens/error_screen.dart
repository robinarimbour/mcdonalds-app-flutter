import 'package:flutter/material.dart';
import 'package:mcdonalds_app/widgets/error_message.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            children: [
              Image.asset('assets/images/sad_mcdonalds.jpg', fit: BoxFit.cover, semanticLabel: 'Sad McDonalds'),
              ErrorMessage(),
            ],
          )),
    );
  }
}
