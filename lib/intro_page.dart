import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:bills_plug/login_page.dart';
import 'package:bills_plug/register_page.dart';

import 'login_page_OldUser.dart';
import 'package:flutter/services.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  List<String> imagePaths = [
    "images/WelcomeImg.png",
    "images/WelcomeImg.png",
    "images/WelcomeImg.png",
  ];

  List<String> imageHeaders = [
    "Welcome to Flexi Data",
    "Welcome to Flexi Data",
    "Welcome to Flexi Data",
  ];

  List<String> imageSubheadings = [
    "We offer you the most affordable data bundle, airtime and subscription for your cableTV.",
    "We offer you the most affordable data bundle, airtime and subscription for your cableTV.",
    "We offer you the most affordable data bundle, airtime and subscription for your cableTV.",
  ];

  int _current = 0;

  // Use the fully qualified CarouselController from the carousel_slider package
  final CarouselController _controller = CarouselController();
  DateTime? currentBackPressTime;

  void _showCustomSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, dynamic result) {
            if (!didPop) {
              DateTime now = DateTime.now();
              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime!) >
                      const Duration(seconds: 2)) {
                currentBackPressTime = now;
                _showCustomSnackBar(
                  context,
                  'Press back again to exit',
                  isError: true,
                );
              } else {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }
            }
          },
          child: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      CarouselSlider(
                        options: CarouselOptions(
                          enlargeCenterPage: false,
                          height: MediaQuery.of(context).size.height,
                          // Set a fixed height for the carousel
                          viewportFraction: 1.0,
                          enableInfiniteScroll: false,
                          initialPage: 0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        carouselController: _controller,
                        items: imagePaths.map((item) {
                          return SingleChildScrollView(
                            child: ListView(
                              // Use ListView for vertical scrolling
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              // Prevent ListView from scrolling horizontally
                              children: [
                                Image.asset(
                                  item,
                                  height: 250,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    imageHeaders[_current],
                                    style: const TextStyle(
                                      color: Color(0xFF02AA03),
                                      fontFamily: 'Inter',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Text(
                                      imageSubheadings[_current],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 420,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        imagePaths.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.asset(
                            _current == index
                                ? "images/ActiveElipses.png"
                                : "images/InActiveElipses.png",
                            width: (10 / MediaQuery.of(context).size.width) *
                                MediaQuery.of(context).size.width,
                            height: (10 / MediaQuery.of(context).size.height) *
                                MediaQuery.of(context).size.height,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE9FFEF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 2,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Container(
                              width: double.infinity,
                              height:
                                  (60 / MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LoginPage(key: UniqueKey()),
                                    ),
                                  );
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         LoginPageOldUser(key: UniqueKey()),
                                  //   ),
                                  // );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.pressed)) {
                                        return const Color(0xFF02AA03);
                                      }
                                      return const Color(0xFFE9FFEF);
                                    },
                                  ),
                                  foregroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.pressed)) {
                                        return const Color(0xFFE9FFEF);
                                      }
                                      return const Color(0xFF02AA03);
                                    },
                                  ),
                                  elevation:
                                      WidgetStateProperty.all<double>(4.0),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 3, color: Color(0xFF02AA03)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Container(
                              width: double.infinity,
                              height:
                                  (60 / MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterPage(key: UniqueKey()),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.pressed)) {
                                        return const Color(0xFFE9FFEF);
                                      }
                                      return const Color(0xFF02AA03);
                                    },
                                  ),
                                  foregroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.pressed)) {
                                        return const Color(0xFF02AA03);
                                      }
                                      return const Color(0xFFE9FFEF);
                                    },
                                  ),
                                  elevation:
                                      WidgetStateProperty.all<double>(4.0),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 3, color: Color(0xFF02AA03)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
