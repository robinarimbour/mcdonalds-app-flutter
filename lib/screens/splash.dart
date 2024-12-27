import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mcdonalds_app/screens/base.dart';
import 'package:mcdonalds_app/services/api.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final List<String> loadingTexts = [
    'Firing up the grill... 🍔',
    'Loading your favorites... 🍟',
    'Stirring up a McFlurry of features... 🌀',
    'Your order is cooking, hang tight! 🍔⏳',
    'Sizzling into action... 🔥',
    'Serving up happiness... Just a sec! 😊',
    'Getting your Big Mac ready... 🍔✨',
    'Loading with love and a side of fries... 🍟❤️',
    'Almost ready... Did someone say McNuggets? 🐥',
    'Unwrapping your experience... 🎁🍔',
  ];

  // final List<Color> colorizeColors = [
  //   Colors.white,
  //   const Color.fromARGB(141, 255, 255, 255),
  //   const Color.fromARGB(51, 255, 255, 255),
  //   const Color.fromARGB(0, 255, 255, 255),
  // ];

  late Future<bool> futureDummyApi;

  Future<bool> getDummyApi() async {
    try {
      await Future.wait([Future.delayed(Duration(seconds: 5)), getImageUrl(1)]);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    futureDummyApi = getDummyApi();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureDummyApi,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            WidgetsBinding.instance.addPostFrameCallback((_) =>
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Base())));
          }

          return Scaffold(
            backgroundColor: Color.fromARGB(255, 213, 42, 30),
            body: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 40.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 32.0),
                      child: SvgPicture.asset(
                        'assets/images/mcdonalds_logo.svg',
                        semanticsLabel: 'McDonalds Logo',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      height: 150.0,
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: List.generate(
                            loadingTexts.length,
                            (index) => RotateAnimatedText(
                                  loadingTexts[index],
                                  textStyle: TextTheme.of(context)
                                      .headlineSmall!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                  alignment: Alignment.topLeft,
                                )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
