
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  String? profileImg;
  bool _isBalanceVisible = false;
  List<String> imagePaths = [
    "images/AdImg.png",
    "images/AdImg.png",
    "images/AdImg.png",
  ];
  int _current = 0;

  // Use the fully qualified CarouselController from the carousel_slider package
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0, bottom: 70),
                    decoration: const BoxDecoration(
                      color: Color(0xFF02AA03),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (profileImg == null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(55),
                                child: Container(
                                  width:
                                  (60 / MediaQuery
                                      .of(context)
                                      .size
                                      .width) *
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                  height:
                                  (60 / MediaQuery
                                      .of(context)
                                      .size
                                      .height) *
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .height,
                                  color: Colors.grey,
                                  child: Image.asset(
                                    'images/ProfilePic.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            else
                              if (profileImg != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(55),
                                  child: Container(
                                    width:
                                    (60 / MediaQuery
                                        .of(context)
                                        .size
                                        .width) *
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                    height:
                                    (60 / MediaQuery
                                        .of(context)
                                        .size
                                        .height) *
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height,
                                    color: Colors.grey,
                                    child: Image.network(
                                      profileImg!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.02),
                            const Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hello",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "William John",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {},
                              child: Image.asset(
                                'images/Notification.png',
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.02),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Available Balance",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "\$0.00",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 27.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                  _isBalanceVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _isBalanceVisible = !_isBalanceVisible;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: (50 / MediaQuery
                                  .of(context)
                                  .size
                                  .height) *
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                      if (states.contains(
                                          WidgetState.pressed)) {
                                        return const Color(0xFF02AA03);
                                      }
                                      return const Color(0xFFEEF1F4);
                                    },
                                  ),
                                  foregroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                      if (states.contains(
                                          WidgetState.pressed)) {
                                        return Colors.white;
                                      }
                                      return const Color(0xFF02AA03);
                                    },
                                  ),
                                  elevation: WidgetStateProperty.all<double>(0),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(35)),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'images/AddMoneyImg.png',
                                      height: 20,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            0.03),
                                    const Text(
                                      'Add Money',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.02),
                            SizedBox(
                              height: (50 / MediaQuery
                                  .of(context)
                                  .size
                                  .height) *
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                      if (states.contains(
                                          WidgetState.pressed)) {
                                        return const Color(0xFF02AA03);
                                      }
                                      return const Color(0xFFEEF1F4);
                                    },
                                  ),
                                  foregroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                      if (states.contains(
                                          WidgetState.pressed)) {
                                        return Colors.white;
                                      }
                                      return const Color(0xFF02AA03);
                                    },
                                  ),
                                  elevation: WidgetStateProperty.all<double>(0),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(35)),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'images/WithdrawImg.png',
                                      height: 20,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            0.03),
                                    const Text(
                                      'Withdraw',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.06),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        enlargeCenterPage: false,
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
                        return Image.asset(
                          item,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        );
                      }).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      imagePaths.length,
                          (index) =>
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0),
                            child: Image.asset(
                              _current == index
                                  ? "images/ActiveElipses.png"
                                  : "images/InActiveElipses.png",
                              width: (10 / MediaQuery
                                  .of(context)
                                  .size
                                  .width) *
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                              height: (10 / MediaQuery
                                  .of(context)
                                  .size
                                  .height) *
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height,
                            ),
                          ),
                    ),
                  ),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 5,
                          child: Text(
                            "Recent Transaction",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Text(
                              'See all',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.008),
                            InkWell(
                              onTap: () {},
                              child: Image.asset(
                                'images/mdi_arrow-bottom.png',
                                height: 25,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'images/NoRecentActivityImg.png',
                          height: 100,
                        ),
                        SizedBox(height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.02),
                        const Text(
                          'Looks like there’s no recent activity to show here. Get started by making a transactions',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 250,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 20.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 2,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/DataImg.png',
                          height: 50,
                        ),
                        const Spacer(),
                        Image.asset(
                          'images/AirtimeImg.png',
                          height: 50,
                        ),
                        const Spacer(),
                        Image.asset(
                          'images/CableTVImg.png',
                          height: 50,
                        ),
                        const Spacer(),
                        Image.asset(
                          'images/MoreImg.png',
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: const Color(0xFF02AA03),
            child: const Icon(Icons.question_mark),
          ),
          SizedBox(height: MediaQuery
              .of(context)
              .size
              .height * 0.005),
          const Text(
            'Need Help With \nOur Service',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

