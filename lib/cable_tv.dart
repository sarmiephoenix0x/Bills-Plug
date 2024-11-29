import 'package:bills_plug/payment_successful_cableTV.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class CableTVPage extends StatefulWidget {
  const CableTVPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  CableTVPageState createState() => CableTVPageState();
}

class CableTVPageState extends State<CableTVPage>
    with SingleTickerProviderStateMixin {
  final FocusNode _iucNumberFocusNode = FocusNode();

  final TextEditingController iucNumberController = TextEditingController();

  List<String> imagePaths = [
    "images/AdImg.png",
    "images/AdImg.png",
    "images/AdImg.png",
  ];
  int _current = 0;

  final CarouselController _controller = CarouselController();

  bool _addToBeneficiary = false;
  bool paymentSectionCableTVOpen = false;
  String? userBalance;
  late SharedPreferences prefs;
  bool paymentSuccessful = false;
  bool selectPlan = false;
  bool selectOption = false;
  int? _selectedPlanRadioValue = -1;
  int? _selectedOptionRadioValue = -1;
  String planText = "Select a plan";
  String optionText = "Select an option";
  bool autoRenewalActive = false;
  bool autoRenewal = false;
  bool selectTime = false;
  String timeText = "Select Time";
  int? _selectedTimeRadioValue = -1;
  String startDateText = "dd/mm/yyyy";
  String endDateText = "dd/mm/yyyy";
  String currentSubscriptionType = "";
  String currentAmount = "";
  List<String> tvImagePaths = [
    "images/GoTVImg.png",
    "images/DStv.png",
    "images/Startimes.png",
  ];

  int currentTV = 0;
  final LocalAuthentication auth = LocalAuthentication();
  String pin = '';
  String pinCode = "";
  bool inputPin = false;
  bool isLoading = false;
  late AnimationController _scaleController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.25, end: 0.4).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
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

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void handlePinInputComplete(String code) {
    setState(() {
      pinCode = code;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessfulCabletv(
          key: UniqueKey(),
          id: 0,
          iucNumber: int.parse(iucNumberController.text.trim()),
          plan: currentSubscriptionType,
          decoder: "GoTv",
          type: optionText,
          amount: currentAmount,
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
                                        0.2),
                                const Text(
                                  'Cable TV',
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
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  'Cable TV',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.05),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: tvImagePaths.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  currentTV = index;
                                                });
                                              },
                                              child: Container(
                                                width: (90 /
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width) *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 7.0,
                                                        horizontal: 7.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(5.0),
                                                  ),
                                                  border: currentTV == index
                                                      ? Border.all(
                                                          width: 2,
                                                          color: const Color(
                                                              0xFF02AA03))
                                                      : Border.all(
                                                          width: 0,
                                                          color: Colors
                                                              .transparent),
                                                ),
                                                child: Image.asset(
                                                  tvImagePaths[index],
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ))),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'IUC Number',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    TextFormField(
                                      controller: iucNumberController,
                                      focusNode: _iucNumberFocusNode,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: '',
                                        labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                          fontSize: 16.0,
                                          decoration: TextDecoration.none,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              width: 3,
                                              color: Color(0xFF02AA03)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                  'Select a Plan',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectPlan = true;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            planText,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Image.asset(
                                          'images/mdi_arrow-dropdown.png',
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  'Select Option',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectOption = true;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            optionText,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Image.asset(
                                          'images/mdi_arrow-dropdown.png',
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  'Auto-renewal',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Switch(
                                      value: autoRenewalActive,
                                      onChanged: (bool value) {
                                        setState(() {
                                          autoRenewalActive = value;
                                          if (value == true) {
                                            autoRenewal = value;
                                          }
                                        });
                                      },
                                    ),
                                    const Spacer(),
                                  ],
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
                                      paymentSectionCableTVOpen = true;
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (planText != "Select a plan" &&
                                            optionText != "Select an option" &&
                                            iucNumberController.text
                                                .trim()
                                                .isNotEmpty) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return Colors.white;
                                          }
                                          return const Color(0xFF02AA03);
                                        } else {
                                          return Colors.grey;
                                        }
                                      },
                                    ),
                                    foregroundColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (planText != "Select a plan" &&
                                            optionText != "Select an option" &&
                                            iucNumberController.text
                                                .trim()
                                                .isNotEmpty) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return const Color(0xFF02AA03);
                                          }
                                          return Colors.white;
                                        } else {
                                          return Colors.white;
                                        }
                                      },
                                    ),
                                    elevation:
                                        WidgetStateProperty.all<double>(4.0),
                                    shape: WidgetStateProperty.resolveWith<
                                        RoundedRectangleBorder>(
                                      (Set<WidgetState> states) {
                                        final bool isFilled = planText !=
                                                "Select a plan" &&
                                            optionText != "Select an option" &&
                                            iucNumberController.text
                                                .trim()
                                                .isNotEmpty;

                                        return RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 3,
                                            color: isFilled
                                                ? const Color(0xFF02AA03)
                                                : Colors.grey,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                        );
                                      },
                                    ),
                                  ),
                                  child: const Text(
                                    'Continue',
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
                  Stack(
                    children: [
                      // Overlay to close the payment section when tapped
                      if (paymentSectionCableTVOpen)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              paymentSectionCableTVOpen = false;
                            });
                          },
                          child: Container(
                            // Make the overlay fill the screen and slightly transparent
                            color: Colors.black.withOpacity(0.4),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          ),
                        ),
                      if (paymentSectionCableTVOpen == true)
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              paymentSectionCableTVOpen = false;
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
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                            double.parse(currentAmount
                                                .replaceAll(',', ''))),
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Expanded(
                                        flex: 5,
                                        child: Text(
                                          'Decoder',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Inter',
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(55),
                                        child: SizedBox(
                                          width: (50 /
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width) *
                                              MediaQuery.of(context).size.width,
                                          height: (50 /
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height) *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7.0, horizontal: 7.0),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                            ),
                                            child: Image.asset(
                                              'images/GoTVImg.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Expanded(
                                        flex: 5,
                                        child: Text(
                                          'Subscription Type',
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
                                          currentSubscriptionType,
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
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Expanded(
                                        flex: 5,
                                        child: Text(
                                          'IUC Number',
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
                                          iucNumberController.text.trim(),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Inter',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05),
                                  Row(
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
                                                    double.tryParse(
                                                                userBalance!) !=
                                                            null
                                                        ? "(${double.parse(userBalance!).toStringAsFixed(2)})"
                                                        : "(0.00)",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 16.0,
                                                    ),
                                                  )
                                                else
                                                  const Text(
                                                    "(0.00)",
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Container(
                                    width: double.infinity,
                                    height: (60 /
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        MediaQuery.of(context).size.height,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          paymentSectionCableTVOpen = false;
                                          inputPin = true;
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.pressed)) {
                                              return Colors.white;
                                            }
                                            return const Color(0xFF02AA03);
                                          },
                                        ),
                                        foregroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.pressed)) {
                                              return const Color(0xFF02AA03);
                                            }
                                            return Colors.white;
                                          },
                                        ),
                                        elevation:
                                            WidgetStateProperty.all<double>(
                                                4.0),
                                        shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 3,
                                                color: Color(0xFF02AA03)),
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                ]),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (selectPlan)
                    Stack(
                      children: [
                        ModalBarrier(
                          dismissible: true,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        PopScope(
                          canPop: false,
                          onPopInvokedWithResult: (didPop, dynamic result) {
                            if (!didPop) {
                              setState(() {
                                selectPlan = false;
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
                                    const Text(
                                      'Select a plan',
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
                                    radioButton(
                                        "GOTV Jinja Bouquet (NGN2,700.00)", 0),
                                    radioButton(
                                        "GOTV Jinja Bouquet (NGN3,950.00)", 1),
                                    radioButton("GOTV Max (NGN5,700.00)", 2),
                                    radioButton(
                                        "GOTV Smallie - quarterly (NGN1,300.00)",
                                        3),
                                    radioButton("GOTV Supa (NGN10,500.00)", 4),
                                    radioButton(
                                        "GOTV Supa Plus (NGN12,500.00)", 5),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (selectOption)
                    Stack(
                      children: [
                        ModalBarrier(
                          dismissible: true,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        PopScope(
                          canPop: false,
                          onPopInvokedWithResult: (didPop, dynamic result) {
                            if (!didPop) {
                              setState(() {
                                selectOption = false;
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
                                    const Text(
                                      'Select an option',
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
                                    radioButton2("Renew Plan", 0),
                                    radioButton2("Change Plan", 1),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                                        Text(
                                          currentAmount,
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    const Text(
                                      'The recipient IUC number will receive it within 1 minute',
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
                  if (autoRenewal)
                    Stack(
                      children: [
                        ModalBarrier(
                          dismissible: true,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        PopScope(
                          canPop: false,
                          onPopInvokedWithResult: (didPop, dynamic result) {
                            if (!didPop) {
                              if (selectTime != true) {
                                setState(() {
                                  autoRenewal = false;
                                });
                              }
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
                                    const Text(
                                      'Auto Renewal',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 0.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Service Time',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectTime = true;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFF8F8F8),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: Text(
                                                  timeText,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Image.asset(
                                                'images/teenyicons_down-solid.png',
                                                height: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 0.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Select start date',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 16.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02),
                                              GestureDetector(
                                                onTap: () async {
                                                  final DateTime? picked =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1900),
                                                    lastDate: DateTime.now(),
                                                  );
                                                  if (picked != null) {
                                                    setState(() {
                                                      // Format the date in dd/MM/yyyy format before updating the controller
                                                      startDateText =
                                                          _formatDate(picked);
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 10.0),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFFF8F8F8),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5.0),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        flex: 5,
                                                        child: Text(
                                                          startDateText,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontSize: 16.0,
                                                          ),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.calendar_month,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface,
                                                        ),
                                                        onPressed: () async {
                                                          final DateTime?
                                                              picked =
                                                              await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                DateTime.now(),
                                                            firstDate:
                                                                DateTime(1900),
                                                            lastDate:
                                                                DateTime.now(),
                                                          );
                                                          if (picked != null) {
                                                            setState(() {
                                                              // Format the date in dd/MM/yyyy format before updating the controller
                                                              startDateText =
                                                                  _formatDate(
                                                                      picked);
                                                            });
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 0.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Select end date',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 16.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02),
                                              GestureDetector(
                                                onTap: () async {
                                                  final DateTime? picked =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1900),
                                                    lastDate: DateTime.now(),
                                                  );
                                                  if (picked != null) {
                                                    setState(() {
                                                      // Format the date in dd/MM/yyyy format before updating the controller
                                                      endDateText =
                                                          _formatDate(picked);
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 10.0),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFFF8F8F8),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5.0),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        flex: 5,
                                                        child: Text(
                                                          endDateText,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontSize: 16.0,
                                                          ),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.calendar_month,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface,
                                                        ),
                                                        onPressed: () async {
                                                          final DateTime?
                                                              picked =
                                                              await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                DateTime.now(),
                                                            firstDate:
                                                                DateTime(1900),
                                                            lastDate:
                                                                DateTime.now(),
                                                          );
                                                          if (picked != null) {
                                                            setState(() {
                                                              // Format the date in dd/MM/yyyy format before updating the controller
                                                              endDateText =
                                                                  _formatDate(
                                                                      picked);
                                                            });
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05),
                                    Container(
                                      width: double.infinity,
                                      height: (60 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .height) *
                                          MediaQuery.of(context).size.height,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            autoRenewal = false;
                                          });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty
                                              .resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.pressed)) {
                                                return Colors.white;
                                              }
                                              return const Color(0xFF02AA03);
                                            },
                                          ),
                                          foregroundColor: WidgetStateProperty
                                              .resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.pressed)) {
                                                return const Color(0xFF02AA03);
                                              }
                                              return Colors.white;
                                            },
                                          ),
                                          elevation:
                                              WidgetStateProperty.all<double>(
                                                  4.0),
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            const RoundedRectangleBorder(
                                              side: BorderSide(
                                                  width: 3,
                                                  color: Color(0xFF02AA03)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Done',
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
                          ),
                        ),
                      ],
                    ),
                  if (selectTime)
                    Stack(
                      children: [
                        ModalBarrier(
                          dismissible: true,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        PopScope(
                          canPop: false,
                          onPopInvokedWithResult: (didPop, dynamic result) {
                            if (!didPop) {
                              setState(() {
                                selectTime = false;
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
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                        'Service Time',
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
                                                0.02),
                                    radioButton3("Daily", 0),
                                    radioButton3("Bi-Daily", 1),
                                    radioButton3("Weekly", 2),
                                    radioButton3("Bi-Weekly", 3),
                                    radioButton3("Monthly", 4),
                                    radioButton3("Bi-Monthly", 5),
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

  Widget radioButton(String text, int value) {
    RegExp exp = RegExp(r"(.+)\s\(NGN([0-9,]+)\.00\)");
    Match? match = exp.firstMatch(text);
    return RadioListTile<int>(
      value: value,
      activeColor: const Color(0xFF02AA03),
      groupValue: _selectedPlanRadioValue,
      onChanged: (int? value) {
        setState(() {
          _selectedPlanRadioValue = value!;
          planText = text;
          if (match != null) {
            currentSubscriptionType = match.group(1) ?? '';
            currentAmount = match.group(2) ?? '';
          }
        });
      },
      title: Text(
        text,
        softWrap: true,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget radioButton2(String text, int value) {
    return RadioListTile<int>(
      value: value,
      activeColor: const Color(0xFF02AA03),
      groupValue: _selectedOptionRadioValue,
      onChanged: (int? value) {
        setState(() {
          _selectedOptionRadioValue = value!;
          optionText = text;
        });
      },
      title: Text(
        text,
        softWrap: true,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget radioButton3(String text, int value) {
    return RadioListTile<int>(
      value: value,
      activeColor: const Color(0xFF02AA03),
      groupValue: _selectedTimeRadioValue,
      onChanged: (int? value) {
        setState(() {
          _selectedTimeRadioValue = value!;
          timeText = text;
        });
      },
      title: Text(
        text,
        softWrap: true,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      controlAffinity: ListTileControlAffinity.trailing,
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
