import 'package:bills_plug/airtime_to_cash.dart';
import 'package:bills_plug/payment_successful_airtime.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:intl/intl.dart';

class AirtimeToCashSellPage extends StatefulWidget {
  final String networkImg;
  final String networkName;
  final String number;
  const AirtimeToCashSellPage(
      {super.key,
      required this.networkImg,
      required this.networkName,
      required this.number});

  @override
  // ignore: library_private_types_in_public_api
  AirtimeToCashSellPageState createState() => AirtimeToCashSellPageState();
}

class AirtimeToCashSellPageState extends State<AirtimeToCashSellPage>
    with SingleTickerProviderStateMixin {
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  List<String> imagePaths = [
    "images/AdImg.png",
    "images/AdImg2.png",
    "images/AdImg.png",
  ];
  int _current = 0;

  final CarouselController _controller = CarouselController();

  bool paymentSectionAirtimeToCashSellOpen = false;
  bool paymentSectionAirtimeToCash = false;
  bool paymentSuccessful = false;
  String? userBalance;
  late SharedPreferences prefs;
  bool isLoading = false;
  late AnimationController _scaleController;
  late Animation<double> _animation;
  String pinCode = "";
  final LocalAuthentication auth = LocalAuthentication();
  String pin = '';
  bool inputPin = false;

  @override
  void initState() {
    super.initState();
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    userBalance = await getUserBalance();
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
    _scaleController.dispose();
    super.dispose();
  }

  void handlePinInputComplete(String code) {
    setState(() {
      pinCode = code;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessfulAirtime(
          key: UniqueKey(),
          id: 0,
          network: widget.networkName,
          type: "VTU",
          number: widget.number,
          amount: amountController.text.trim(),
          timeStamp: "08 Oct, 2024 12:12PM",
        ),
      ),
    );
  }

  Future<void> authenticateWithFingerprint() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        // Handle successful authentication
        print("Fingerprint authentication successful!");
      } else {
        // Handle failed authentication
        print("Fingerprint authentication failed.");
      }
    } catch (e) {
      print("Error during fingerprint authentication: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
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
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Image.asset(
                                    'images/BackButton.png',
                                    height: 40,
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05),
                                const Text(
                                  'Airtime2cash',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.black,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: CarouselSlider(
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
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  imagePaths.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Image.asset(
                                      _current == index
                                          ? "images/ActiveElipses.png"
                                          : "images/InActiveElipses.png",
                                      width: (10 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .width) *
                                          MediaQuery.of(context).size.width,
                                      height: (10 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .height) *
                                          MediaQuery.of(context).size.height,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(55),
                                      child: SizedBox(
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
                                        child: Image.asset(
                                          widget.networkImg,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.networkName,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Inter',
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            widget.number,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Inter',
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Airtime Balance',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Inter',
                                              color: Colors.black,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'images/NairaImg.png',
                                                height: 15,
                                                color: const Color(0xFF02AA03),
                                              ),
                                              if (userBalance != null)
                                                Text(
                                                  double.tryParse(
                                                              userBalance!) !=
                                                          null
                                                      ? double.parse(
                                                              userBalance!)
                                                          .toStringAsFixed(2)
                                                      : "0.00",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF02AA03),
                                                  ),
                                                )
                                              else
                                                const Text(
                                                  "0.00",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF02AA03),
                                                  ),
                                                )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  'Amount to Sell',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Center(
                                  child: Wrap(
                                    spacing: 10.0,
                                    runSpacing: 10.0,
                                    children: [
                                      airtime("50"),
                                      airtime("100"),
                                      airtime("200"),
                                      airtime("500"),
                                      airtime("1,000"),
                                      airtime("2,000"),
                                      airtime("3,000"),
                                      airtime("4,000"),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: TextFormField(
                                  controller: amountController,
                                  focusNode: _amountFocusNode,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Input Amount',
                                    labelStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Inter',
                                      fontSize: 16.0,
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
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.grey),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  cursorColor: const Color(0xFF02AA03),
                                  keyboardType: TextInputType
                                      .number, // This allows only numeric input
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter
                                        .digitsOnly, // This will filter out non-numeric input
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an amount';
                                    }
                                    return null; // Return null if the input is valid
                                  },
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.05),
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
                                      paymentSectionAirtimeToCash = true;
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
                                    'Sell',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
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
                  if (paymentSectionAirtimeToCash == true)
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
                                          paymentSectionAirtimeToCash = false;
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
                                  Text(
                                    NumberFormat('#,###.##').format(
                                        double.parse(amountController.text
                                                .trim()
                                                .replaceAll(',', '')) -
                                            10),
                                    style: const TextStyle(
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
                                  Text(
                                    NumberFormat('#,###.##').format(
                                        double.parse(amountController.text
                                            .trim()
                                            .replaceAll(',', ''))),
                                    style: const TextStyle(
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
                                  if (widget.networkName == "MTN")
                                    network("images/MTNImg.png", "MTN"),
                                  if (widget.networkName == "AIRTEL")
                                    network("images/AirtelImg.png", "AIRTEL"),
                                  if (widget.networkName == "GLO")
                                    network("images/GloImg.png", "GLO"),
                                  if (widget.networkName == "9MOBILE")
                                    network("images/9MobileImg.png", "9MOBILE"),
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
                                      'Phone Number',
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
                                    child: Text(
                                      widget.number,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
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
                                      'Airtime Amount',
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
                                        Text(
                                          amountController.text.trim(),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Expanded(
                                    flex: 5,
                                    child: Text(
                                      'Amount To Receive',
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
                                      paymentSectionAirtimeToCash = false;
                                      inputPin = true;
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
                  if (inputPin)
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
                                inputPin = false;
                                pin = '';
                              });
                            }
                          },
                          child: GestureDetector(
                            onTap: () {
                              // Dismiss the keyboard when tapping outside
                              FocusScope.of(context).unfocus();
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03),
                                      const Text(
                                        'Input PIN',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      PinInput(pin: pin, length: 4),
                                      const SizedBox(height: 20),
                                      // Custom Keyboard
                                      CustomKeyboard(
                                        onNumberPressed: (String number) {
                                          setState(() {
                                            if (pin.length < 4) {
                                              pin += number;
                                            }
                                            if (pin.length == 4) {
                                              handlePinInputComplete(pin);
                                            }
                                          });
                                        },
                                        onFingerprintPressed: () async {
                                          await authenticateWithFingerprint();
                                        },
                                        onBackspacePressed: () {
                                          setState(() {
                                            if (pin.isNotEmpty) {
                                              pin = pin.substring(
                                                  0, pin.length - 1);
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (isLoading)
                    Positioned.fill(
                      child: AbsorbPointer(
                        absorbing:
                            true, // Blocks interaction with widgets behind
                        child: Container(
                          color: Colors.black
                              .withOpacity(0.5), // Semi-transparent background
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ScaleTransition(
                                scale: _animation,
                                child: Image.asset(
                                  'images/Loading.png',
                                ),
                              ),
                            ],
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

  Widget airtime(String amount) {
    return InkWell(
      onTap: () {
        setState(() {
          amountController.text = amount;
        });
      },
      child: Container(
        width: (70.0 / MediaQuery.of(context).size.width) *
            MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
        decoration: const BoxDecoration(
          color: Color(0xFFE3EEE8),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/NairaImg.png',
              height: 10,
            ),
            Text(
              amount,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget network(String img, String text) {
    return Expanded(
      flex: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(55),
            child: SizedBox(
              width: (30 / MediaQuery.of(context).size.width) *
                  MediaQuery.of(context).size.width,
              height: (30 / MediaQuery.of(context).size.height) *
                  MediaQuery.of(context).size.height,
              child: Image.asset(
                img,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Inter',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class PinInput extends StatelessWidget {
  final String pin;
  final int length;

  const PinInput({
    Key? key,
    required this.pin,
    required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                pin.length > index ? const Color(0xFF02AA03) : Colors.grey[300],
          ),
          alignment: Alignment.center,
          child: Text(
            pin.length > index ? pin[index] : '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }
}

class CustomKeyboard extends StatefulWidget {
  final Function(String) onNumberPressed;
  final Function onFingerprintPressed;
  final Function onBackspacePressed;

  const CustomKeyboard({
    super.key,
    required this.onNumberPressed,
    required this.onFingerprintPressed,
    required this.onBackspacePressed,
  });

  @override
  _CustomKeyboardState createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  List<bool> _isPressed =
      List.generate(12, (index) => false); // Track button press state

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (int i = 1; i <= 9; i++)
          GestureDetector(
            onTapDown: (_) => _setPressed(i - 1, true),
            onTapUp: (_) {
              _setPressed(i - 1, false);
              widget.onNumberPressed(i.toString());
            },
            onTapCancel: () => _setPressed(i - 1, false),
            child: _buildKey(i.toString(), i - 1),
          ),
        GestureDetector(
          onTapDown: (_) => _setPressed(9, true),
          onTapUp: (_) {
            _setPressed(9, false);
            widget.onNumberPressed('0');
          },
          onTapCancel: () => _setPressed(9, false),
          child: _buildKey('0', 9),
        ),
        GestureDetector(
          onTapDown: (_) => _setPressed(10, true),
          onTapUp: (_) {
            _setPressed(10, false);
            widget.onBackspacePressed();
          },
          onTapCancel: () => _setPressed(10, false),
          child: _buildKey('Backspace', 10, isIcon: true),
        ),
        GestureDetector(
          onTapDown: (_) => _setPressed(11, true),
          onTapUp: (_) {
            _setPressed(11, false);
            widget.onFingerprintPressed();
          },
          onTapCancel: () => _setPressed(11, false),
          child: _buildKey('Fingerprint', 11, isIcon: true),
        ),
      ],
    );
  }

  void _setPressed(int index, bool isPressed) {
    setState(() {
      _isPressed[index] = isPressed;
    });
  }

  Widget _buildKey(String label, int index, {bool isIcon = false}) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _isPressed[index] ? Colors.green[300] : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: isIcon
          ? Icon(
              label == 'Backspace' ? Icons.backspace : Icons.fingerprint,
              size: 45,
              color:
                  label == 'Backspace' ? Colors.black : const Color(0xFF02AA03),
            )
          : Text(
              label,
              style: const TextStyle(fontSize: 24),
            ),
    );
  }
}
