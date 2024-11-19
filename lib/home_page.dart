import 'package:bills_plug/add_money_old_users.dart';
import 'package:bills_plug/add_photo.dart';
import 'package:bills_plug/airtime.dart';
import 'package:bills_plug/airtime_and_data_page.dart';
import 'package:bills_plug/data.dart';
import 'package:bills_plug/notification.dart';
import 'package:bills_plug/service_page.dart';
import 'package:bills_plug/transaction.dart';
import 'package:bills_plug/withdraw_money.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'add_money_new_users.dart';
import 'cable_tv.dart';
import 'help_service.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final Function welcomeAdActive;
  const HomePage({super.key, required this.welcomeAdActive});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String? profileImg;
  bool _isBalanceVisible = false;
  List<String> imagePaths = [
    "images/AdImg.png",
    "images/AdImg2.png",
    "images/AdImg.png",
  ];
  int _current = 0;

  // Use the fully qualified CarouselController from the carousel_slider package
  final CarouselController _controller = CarouselController();
  late SharedPreferences prefs;
  String? userName;
  String? firstName;
  String? lastName;
  String? fullName;
  String? userBalance;
  bool welcomeAd = false;
  late AnimationController _animController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animController);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    ));

    // Start the animation
    _animController.forward();
    _initializePrefs();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // If it's the first launch, show the welcome ad
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            welcomeAd = true;
            widget.welcomeAdActive();
          });
        }
      });

      // Set the flag to false so it won't show again
      await prefs.setBool('isFirstLaunch', false);
    }
  }

  Future<void> _initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    userName = await getUserName();
    firstName = await getFirstName();
    lastName = await getLastName();
    userBalance = await getUserBalance();
    if (mounted) {
      setState(() {
        fullName = "$firstName $lastName";
      });
    }
  }

  Future<String?> getFirstName() async {
    final String? userJson = prefs.getString('user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return userMap['firstname'];
    } else {
      return null;
    }
  }

  Future<String?> getLastName() async {
    final String? userJson = prefs.getString('user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return userMap['lastname'];
    } else {
      return null;
    }
  }

  Future<String?> getUserName() async {
    final String? userJson = prefs.getString('user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return userMap['username'];
    } else {
      return null;
    }
  }

  Future<String?> getUserBalance() async {
    final String? userJson = prefs.getString('user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return userMap['balance'];
    } else {
      return null;
    }
  }

  Future<String?> getProfileImg() async {
    final String? userJson = prefs.getString('user');

    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return userMap['image']; // Fetch the outer profile photo
    } else {
      return null;
    }
  }

  void _launchURL() async {
    const url = 'https://www.Billsplug.ng/Referredandearn583'; // Your URL here
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
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
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddPhoto(
                                          key: UniqueKey(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(55),
                                    child: Container(
                                      width: (60 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .width) *
                                          MediaQuery.of(context).size.width,
                                      height: (60 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .height) *
                                          MediaQuery.of(context).size.height,
                                      color: Colors.grey,
                                      child: Image.asset(
                                        'images/ProfilePic.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              else if (profileImg != null)
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddPhoto(
                                          key: UniqueKey(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(55),
                                    child: Container(
                                      width: (60 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .width) *
                                          MediaQuery.of(context).size.width,
                                      height: (60 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .height) *
                                          MediaQuery.of(context).size.height,
                                      color: Colors.grey,
                                      child: Image.network(
                                        profileImg!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Hello",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (fullName != null)
                                      Text(
                                        fullName!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: Colors.white,
                                        ),
                                      )
                                    else
                                      const Text(
                                        "Unknown User",
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NotificationPage(
                                        key: UniqueKey(),
                                      ),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'images/Notification.png',
                                  height: 40,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 10,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Total Balance",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                              _isBalanceVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.white),
                                          onPressed: () {
                                            setState(() {
                                              _isBalanceVisible =
                                                  !_isBalanceVisible;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    if (_isBalanceVisible != false)
                                      Row(
                                        children: [
                                          Image.asset(
                                            'images/NairaImg.png',
                                            height: 20,
                                            color: Colors.white,
                                          ),
                                          if (userBalance != null)
                                            Text(
                                              double.tryParse(userBalance!) !=
                                                      null
                                                  ? double.parse(userBalance!)
                                                      .toStringAsFixed(2)
                                                  : "0.00",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 27.0,
                                                color: Colors.white,
                                              ),
                                            )
                                          else
                                            const Text(
                                              "0.00",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 27.0,
                                                color: Colors.white,
                                              ),
                                            )
                                        ],
                                      )
                                    else
                                      const Text(
                                        "****",
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
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddMoneyNewUsers(
                                        key: UniqueKey(),
                                      ),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'images/AddMoneyImg2.png',
                                  height: 40,
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(
                          //     height:
                          //         MediaQuery.of(context).size.height * 0.02),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     SizedBox(
                          //       height:
                          //           (50 / MediaQuery.of(context).size.height) *
                          //               MediaQuery.of(context).size.height,
                          //       child: ElevatedButton(
                          //         onPressed: () {
                          //           // Navigator.push(
                          //           //   context,
                          //           //   MaterialPageRoute(
                          //           //     builder: (context) =>
                          //           //         AddMoneyOldUsers(key: UniqueKey()),
                          //           //   ),
                          //           // );
                          //           Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //               builder: (context) =>
                          //                   AddMoneyNewUsers(key: UniqueKey()),
                          //             ),
                          //           );
                          //         },
                          //         style: ButtonStyle(
                          //           backgroundColor:
                          //               WidgetStateProperty.resolveWith<Color>(
                          //             (Set<WidgetState> states) {
                          //               if (states
                          //                   .contains(WidgetState.pressed)) {
                          //                 return const Color(0xFF02AA03);
                          //               }
                          //               return const Color(0xFFEEF1F4);
                          //             },
                          //           ),
                          //           foregroundColor:
                          //               WidgetStateProperty.resolveWith<Color>(
                          //             (Set<WidgetState> states) {
                          //               if (states
                          //                   .contains(WidgetState.pressed)) {
                          //                 return Colors.white;
                          //               }
                          //               return const Color(0xFF02AA03);
                          //             },
                          //           ),
                          //           elevation:
                          //               WidgetStateProperty.all<double>(0),
                          //           shape: WidgetStateProperty.all<
                          //               RoundedRectangleBorder>(
                          //             const RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.all(
                          //                   Radius.circular(35)),
                          //             ),
                          //           ),
                          //         ),
                          //         child: Row(
                          //           children: [
                          //             Image.asset(
                          //               'images/AddMoneyImg.png',
                          //               height: 20,
                          //             ),
                          //             SizedBox(
                          //                 width: MediaQuery.of(context)
                          //                         .size
                          //                         .width *
                          //                     0.03),
                          //             const Text(
                          //               'Add Money',
                          //               style: TextStyle(
                          //                 fontFamily: 'Inter',
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: 14.0,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(
                          //         width:
                          //             MediaQuery.of(context).size.width * 0.02),
                          //     SizedBox(
                          //       height:
                          //           (50 / MediaQuery.of(context).size.height) *
                          //               MediaQuery.of(context).size.height,
                          //       child: ElevatedButton(
                          //         onPressed: () {
                          //           Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //               builder: (context) =>
                          //                   WithdrawMoneyPage(key: UniqueKey()),
                          //             ),
                          //           );
                          //         },
                          //         style: ButtonStyle(
                          //           backgroundColor:
                          //               WidgetStateProperty.resolveWith<Color>(
                          //             (Set<WidgetState> states) {
                          //               if (states
                          //                   .contains(WidgetState.pressed)) {
                          //                 return const Color(0xFF02AA03);
                          //               }
                          //               return const Color(0xFFEEF1F4);
                          //             },
                          //           ),
                          //           foregroundColor:
                          //               WidgetStateProperty.resolveWith<Color>(
                          //             (Set<WidgetState> states) {
                          //               if (states
                          //                   .contains(WidgetState.pressed)) {
                          //                 return Colors.white;
                          //               }
                          //               return const Color(0xFF02AA03);
                          //             },
                          //           ),
                          //           elevation:
                          //               WidgetStateProperty.all<double>(0),
                          //           shape: WidgetStateProperty.all<
                          //               RoundedRectangleBorder>(
                          //             const RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.all(
                          //                   Radius.circular(35)),
                          //             ),
                          //           ),
                          //         ),
                          //         child: Row(
                          //           children: [
                          //             Image.asset(
                          //               'images/WithdrawImg.png',
                          //               height: 20,
                          //             ),
                          //             SizedBox(
                          //                 width: MediaQuery.of(context)
                          //                         .size
                          //                         .width *
                          //                     0.03),
                          //             const Text(
                          //               'Withdraw',
                          //               style: TextStyle(
                          //                 fontFamily: 'Inter',
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: 14.0,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                    CarouselSlider(
                      options: CarouselOptions(
                        enlargeCenterPage: false,
                        viewportFraction: 1.0,
                        height: 150,
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal:
                                  20.0), // Adjust horizontal padding as needed
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(
                              item,
                              width: double
                                  .infinity, // Make the width fill the screen
                              fit: BoxFit
                                  .cover, // Ensure the image covers the available space
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Row(
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionPage(
                                    key: UniqueKey(),
                                  ),
                                ),
                              );
                            },
                            child: Row(
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
                                    width: MediaQuery.of(context).size.width *
                                        0.008),
                                Image.asset(
                                  'images/mdi_arrow-bottom.png',
                                  height: 25,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'images/NoRecentActivityImg.png',
                            height: 100,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
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
                  top: MediaQuery.of(context).padding.top + 200,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
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
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DataPage(
                                    key: UniqueKey(),
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/DataImg.png',
                                  height: 50,
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.005),
                                const Text(
                                  'Data',
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
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AirtimePage(
                                    key: UniqueKey(),
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/AirtimeImg.png',
                                  height: 50,
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.005),
                                const Text(
                                  'Airtime',
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
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CableTVPage(key: UniqueKey()),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/CableTVImg.png',
                                  height: 50,
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.005),
                                const Text(
                                  'Cable TV',
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
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ServicePage(
                                    key: UniqueKey(),
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/MoreImg.png',
                                  height: 50,
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.005),
                                const Text(
                                  'More',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (welcomeAd)
                  Stack(
                    children: [
                      // Your main content goes here
                      // For example, a Scaffold with a FloatingActionButton:
                      SizedBox(
                        height: MediaQuery.of(context)
                            .size
                            .height, // Specify a fixed height
                        child: ModalBarrier(
                          dismissible: true,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      // The modal overlay
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 50,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _opacityAnimation,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    bottom: 10.0, top: 10),
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context)
                                      .size
                                      .height, // Set a max height for the content
                                  maxWidth: MediaQuery.of(context).size.width *
                                      0.9, // Set a width for the content
                                ),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .white, // White background for the content
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Curved edges
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: PopScope(
                                  canPop: false,
                                  onPopInvokedWithResult:
                                      (didPop, dynamic result) {
                                    if (!didPop) {
                                      setState(() {
                                        welcomeAd = false;
                                        widget.welcomeAdActive();
                                      });
                                    }
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                            top: 12.0,
                                            bottom: 14),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "images/icons/AppIcon.png",
                                              fit: BoxFit.contain,
                                              width: 40,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02,
                                            ),
                                            const Expanded(
                                              child: Text(
                                                "Get Started With Us",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Image.asset(
                                        'images/AdImg2.png',
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Text(
                                          'Enjoy our service that brings you fast and reliable deals for Airtime, Data, Cable TV, and more. Take a first try and give us feedback.',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: GestureDetector(
                                          onTap:
                                              _launchURL, // Call the function when tapped
                                          child: const Text(
                                            'www.Billsplug.ng/Referredandearn583',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 16.0,
                                              color: Color(0xFF1469CC),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                28, 2, 170, 2),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Row(children: [
                                            const Text(
                                              'Ignore',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                                color: Color(0xFF5B5B5B),
                                              ),
                                            ),
                                            const Spacer(),
                                            Row(
                                              children: [
                                                const Text(
                                                  'View',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 16.0,
                                                    color: Color(0xFF02AA03),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.navigate_next,
                                                    color: Color(0xFF02AA03),
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ],
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (welcomeAd == false) ...[
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpServicePage(
                      key: UniqueKey(),
                    ),
                  ),
                );
              },
              backgroundColor: const Color(0xFF02AA03),
              child: const Icon(Icons.question_mark),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
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
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
