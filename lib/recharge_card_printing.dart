import 'package:bills_plug/add_photo.dart';
import 'package:bills_plug/notification.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RechargeCardPrinting extends StatefulWidget {
  const RechargeCardPrinting({super.key});

  @override
  // ignore: library_private_types_in_public_api
  RechargeCardPrintingState createState() => RechargeCardPrintingState();
}

class RechargeCardPrintingState extends State<RechargeCardPrinting>
    with SingleTickerProviderStateMixin {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  List<String> imagePaths = [
    "images/AdImg.png",
    "images/AdImg2.png",
    "images/AdImg.png",
  ];
  int _current = 0;

  final CarouselController _controller = CarouselController();
  bool paymentSectionDataOpen = false;
  late SharedPreferences prefs;
  String? profileImg;
  String? firstName;
  String? lastName;
  String? fullName;
  String? userBalance;
  String? _type = 'Plan1';
  bool paymentSuccessful = false;

  @override
  void initState() {
    super.initState();
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
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

  Future<String?> getUserBalance() async {
    final String? userJson = prefs.getString('user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return userMap['balance'];
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 20.0,
                                bottom: 20.0),
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
                                          borderRadius:
                                              BorderRadius.circular(55),
                                          child: Container(
                                            width: (60 /
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width) *
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            height: (60 /
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height,
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
                                          borderRadius:
                                              BorderRadius.circular(55),
                                          child: Container(
                                            width: (60 /
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width) *
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            height: (60 /
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height,
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
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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
                                            builder: (context) =>
                                                NotificationPage(
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
                              ],
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Image.asset(
                                  _current == index
                                      ? "images/ActiveElipses.png"
                                      : "images/InActiveElipses.png",
                                  width:
                                      (10 / MediaQuery.of(context).size.width) *
                                          MediaQuery.of(context).size.width,
                                  height: (10 /
                                          MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.04),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Rechrge Card Printing',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.04),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width:
                                      (20 / MediaQuery.of(context).size.width) *
                                          MediaQuery.of(context).size.width,
                                  height: (110 /
                                          MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.width,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Image.asset(
                                      'images/teenyicons_down-solid.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02),
                                Container(
                                  width:
                                      (80 / MediaQuery.of(context).size.width) *
                                          MediaQuery.of(context).size.width,
                                  height: (110 /
                                          MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 7.0, horizontal: 7.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                  child: Image.asset(
                                    'images/MTNImg.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Select Plan',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      _typeDropdown(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.04),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Name on card',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              controller: nameController,
                              focusNode: _nameFocusNode,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Business Name',
                                labelStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Inter',
                                  fontSize: 12.0,
                                  decoration: TextDecoration.none,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      width: 3, color: Color(0xFF02AA03)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              cursorColor: const Color(0xFF02AA03),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Container(
                            width: double.infinity,
                            height: (60 / MediaQuery.of(context).size.height) *
                                MediaQuery.of(context).size.height,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  paymentSectionDataOpen = true;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors.white;
                                    }
                                    return const Color(0xFF02AA03);
                                  },
                                ),
                                foregroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return const Color(0xFF02AA03);
                                    }
                                    return Colors.white;
                                  },
                                ),
                                elevation: WidgetStateProperty.all<double>(4.0),
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
                                'Purchase Pin',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (paymentSectionDataOpen == true)
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          paymentSectionDataOpen = false;
                                        });
                                      },
                                      child: Image.asset(
                                        'images/CloseBut.png',
                                        height: 25,
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/NairaImg.png',
                                    height: 15,
                                  ),
                                  const Text(
                                    '1,370.00',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/NairaImg.png',
                                    height: 15,
                                    color: Colors.grey,
                                  ),
                                  const Text(
                                    '1,400.00',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Expanded(
                                    flex: 5,
                                    child: Text(
                                      'Network',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(55),
                                          child: SizedBox(
                                            width: (30 /
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width) *
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            height: (30 /
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height) *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height,
                                            child: Image.asset(
                                              'images/MTNImg.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01),
                                        const Text(
                                          'MTN',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Inter',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      'Plan',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      '10.0GB',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      'Phone Number',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      '0905 525 9546',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Expanded(
                                    flex: 5,
                                    child: Text(
                                      'Amount to pay',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(
                                          'images/NairaImg.png',
                                          height: 15,
                                        ),
                                        const Text(
                                          '730.32',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Inter',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.05),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "images/icons/AppIcon.png",
                                    fit: BoxFit.contain,
                                    width: 40,
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Balance",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'images/NairaImg.png',
                                              height: 15,
                                            ),
                                            if (userBalance != null)
                                              Text(
                                                double.tryParse(userBalance!) !=
                                                        null
                                                    ? "(${double.parse(userBalance!).toStringAsFixed(2)})"
                                                    : "(0.00)",
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 16.0,
                                                ),
                                              )
                                            else
                                              const Text(
                                                "(0.00)",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 16.0,
                                                ),
                                              )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Container(
                                width: double.infinity,
                                height:
                                    (60 / MediaQuery.of(context).size.height) *
                                        MediaQuery.of(context).size.height,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      paymentSectionDataOpen = false;
                                      paymentSuccessful = true;
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.pressed)) {
                                          return Colors.white;
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
                                        return Colors.white;
                                      },
                                    ),
                                    elevation:
                                        WidgetStateProperty.all<double>(4.0),
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 3, color: Color(0xFF02AA03)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Pay',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  if (paymentSuccessful)
                    Stack(
                      children: [
                        ModalBarrier(
                          dismissible: false,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        PopScope(
                          canPop: false,
                          onPopInvokedWithResult: (didPop, dynamic result) {
                            if (!didPop) {
                              setState(() {
                                paymentSuccessful = false;
                              });
                            }
                          },
                          child: Center(
                            child: SingleChildScrollView(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0), // Centered padding
                                padding: const EdgeInsets.all(
                                    16.0), // Inner padding for content
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Expands only as needed
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Close button
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            paymentSuccessful = false;
                                          });
                                        },
                                        child: Image.asset(
                                          'images/CloseBut.png',
                                          height: 25,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),

                                    // Receipt title and content
                                    const Text(
                                      'Payment Successful',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'images/NairaImg.png',
                                          height: 20,
                                        ),
                                        const Text(
                                          '1,370.00',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    const Text(
                                      'Airtime Sell was successful, the payment will be added to your wallet balance within 5 minutes',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                        color: Color(0xFF02AA03),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 12.0),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFDAF3DB),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15.0),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                'images/ShareReceipt.png',
                                                height: 20,
                                              ),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02),
                                              const Text(
                                                'Share Receipt',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 12.0),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFDAF3DB),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15.0),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                'images/Download.png',
                                                height: 20,
                                              ),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02),
                                              const Text(
                                                'View Receipt',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _typeDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: DropdownButtonFormField<String>(
        value: _type,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 16,
        isExpanded: true,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          labelText: '',
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Inter',
            fontSize: 12.0,
            decoration: TextDecoration.none,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: InputBorder.none, // Remove default border
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 3, color: Color(0xFF02AA03)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 0, color: Colors.grey),
          ),
        ),
        onChanged: (String? newValue) {
          setState(() {
            _type = newValue;
          });
        },
        hint: const Text('Select Data Plan'),
        items: <String>['Plan1', 'Plan2', 'Plan3']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          );
        }).toList(),
      ),
    );
  }
}
