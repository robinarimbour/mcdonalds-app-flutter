import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("About Us"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 25.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10.0,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 25.0, 0, 0),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/github_icon.svg',
                      semanticsLabel: 'Github Icon',
                      height: 150.0,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                    'All images and content used in this application belong to their respective owners.',
                    style: TextTheme.of(context)
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(
                    'This web app was made purely for personal purpose and not intended for any commercial use.',
                    style: TextTheme.of(context)
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                RichText(
                  text: TextSpan(
                    text: 'For more information, contact me at ',
                    style: TextTheme.of(context)
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'www.github.com/robinarimbour',
                        style: TextStyle(color: Colors.blue.shade900),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final url = Uri.parse(
                                'https://www.github.com/robinarimbour');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                              );
                            }
                          },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
