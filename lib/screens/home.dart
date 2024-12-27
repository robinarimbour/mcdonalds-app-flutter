import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mcdonalds_app/models/image_url.dart';
import 'package:mcdonalds_app/screens/error_screen.dart';
import 'package:mcdonalds_app/screens/product_details.dart';
import 'package:mcdonalds_app/services/api.dart';
import 'package:mcdonalds_app/widgets/loading.dart';

class Home extends StatefulWidget {
  final Function(int) onIndexChange;

  const Home({super.key, required this.onIndexChange});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<ImageUrl>> futureImagesUrls;
  int _current = 0;

  Future<List<ImageUrl>> getImageUrls() async {
    var responses = await Future.wait([getImageUrl(2), getImageUrl(3)]);
    return responses;
  }

  Future<void> _pullRefresh() async {
    setState(() {
      futureImagesUrls = getImageUrls();
    });
  }

  @override
  void initState() {
    super.initState();
    futureImagesUrls = getImageUrls();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ImageUrl>>(
        future: futureImagesUrls,
        builder: (context, snapshot) {
          return RefreshIndicator(
              onRefresh: _pullRefresh, child: _homeContent(snapshot));
        });
  }

  Widget _homeContent(AsyncSnapshot snapshot) {
    if (snapshot.connectionState != ConnectionState.waiting) {
      if (snapshot.hasData) {
        return SingleChildScrollView(
          child: Column(spacing: 10.0, children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CarouselSlider(
                    items: List.generate(
                      snapshot.data!.length,
                      (index) => Image.network(snapshot.data![index].url!,
                          fit: BoxFit.cover,
                          semanticLabel: snapshot.data![index].name),
                    ),
                    options: CarouselOptions(
                        autoPlay: true,
                        viewportFraction: 1.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        snapshot.data!.length,
                        (index) => Container(
                              width: 12.0,
                              height: 12.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withAlpha(
                                      _current == index ? 235 : 125)),
                            ))),
              ],
            ),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpandablePanel(
                  header: Text('Delicious Double Quarter Pounder®* with Cheese',
                      style: TextTheme.of(context)
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  collapsed: Image.network(snapshot.data![0].url!,
                      semanticLabel: snapshot.data![0].name),
                  expanded: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetails(productId: 6)));
                    },
                    child: Column(
                      spacing: 10.0,
                      children: [
                        Image.network(snapshot.data![0].url!,
                            semanticLabel: snapshot.data![0].name),
                        Text(
                          'Try the new Double Quarter Pounder®* with Cheese! Features two quarter pound* 100% fresh beef burger patties that are hot, deliciously juicy and cooked when you order.',
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpandablePanel(
                  header: Text('It\'s Breakfast o\' clock!',
                      style: TextTheme.of(context)
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  collapsed: Image.network(snapshot.data![1].url!,
                      semanticLabel: snapshot.data![1].name),
                  expanded: GestureDetector(
                    onTap: () {
                      widget.onIndexChange(1);
                    },
                    child: Column(
                      spacing: 10.0,
                      children: [
                        Image.network(snapshot.data![1].url!,
                            semanticLabel: snapshot.data![1].name),
                        Text(
                          'Start your day with McDonald\'s Breakfast Menu. Fill up with delicious Egg McMuffin® sandwich, golden brown hotcakes and Fruit and Maple Oatmeal.',
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ]),
        );
      } else if (snapshot.hasError) {
        return ErrorScreen();
      }
    }

    // By default, show a loading spinner.
    return Loading();
  }
}
