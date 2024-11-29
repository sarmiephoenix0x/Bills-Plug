import 'package:bills_plug/add_photo.dart';
import 'package:bills_plug/notification.dart';
import 'package:bills_plug/payment_successful_electricity.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:intl/intl.dart';

class ElectricityBill extends StatefulWidget {
  const ElectricityBill({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ElectricityBillState createState() => ElectricityBillState();
}

class ElectricityBillState extends State<ElectricityBill>
    with SingleTickerProviderStateMixin {
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _meterNumberFocusNode = FocusNode();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController meterNumberController = TextEditingController();

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
  String? _type = 'Prepaid';
  bool paymentSuccessful = false;
  List<String> planText = [
    "Prepaid",
    "Postpaid",
  ];
  String currentPlanText = "Prepaid";
  String providerImg = "images/IkejaDisco.png";
  String providerText = "Ikeja Disco";
  bool selectPlan = false;
  String currentBillType = "";
  int? _selectedPlanRadioValue = -1;
  String searchQuery = '';
  final List<String> providers = [
    "Ikeja Disco",
    "Eko Electricity",
    "Enugu Electricity",
    "Kano Electricity",
  ];

  final List<String> providersImg = [
    "images/IkejaDisco.png",
    "images/EkoElectricity.png",
    "images/EnuguElectricity.png",
    "images/KanoElectricity.png",
  ];

  bool isLoading = false;
  late AnimationController _scaleController;
  late Animation<double> _animation;
  String pinCode = "";
  bool inputPin = false;
  bool isButtonEnabled = false;
  final LocalAuthentication auth = LocalAuthentication();
  String pin = '';
  String phoneNumber = '09016482578';

  @override
  void initState() {
    super.initState();
    meterNumberController.addListener(validateForm);
    amountController.addListener(validateForm);
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
    _scaleController.dispose();
    super.dispose();
  }

  List<String> get filteredProviders {
    if (searchQuery.isEmpty) {
      return providers;
    } else {
      return providers
          .where((provider) =>
              provider.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Provider',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredProviders.length,
                    itemBuilder: (context, index) {
                      return radioButton(providersImg[index],
                          filteredProviders[index], index, setState);
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void handlePinInputComplete(String code) {
    setState(() {
      pinCode = code;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessfulElectricity(
          key: UniqueKey(),
          id: 0,
          type: currentPlanText,
          number: meterNumberController.text.trim(),
          amount: amountController.text.trim(),
          timeStamp: "08 Oct, 2024 12:12PM",
        ),
      ),
    );
  }

  void validateForm() {
    setState(() {
      isButtonEnabled = amountController.text.trim().trim() != "" &&
          meterNumberController.text.trim() != "";
    });
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
                                          0.0), // Adjust horizontal padding as needed
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
                                'Electricity Bill',
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
                            child: InkWell(
                              onTap: () {
                                _showBottomSheet(context);
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(55),
                                      child: Container(
                                        width: (40 /
                                                MediaQuery.of(context)
                                                    .size
                                                    .width) *
                                            MediaQuery.of(context).size.width,
                                        height: (40 /
                                                MediaQuery.of(context)
                                                    .size
                                                    .height) *
                                            MediaQuery.of(context).size.height,
                                        color: Colors.grey,
                                        child: Image.asset(
                                          providerImg,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        providerText,
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
                              height:
                                  MediaQuery.of(context).size.height * 0.04),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              height:
                                  (50 / MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                scrollDirection:
                                    Axis.horizontal, // Set to horizontal
                                children:
                                    planText.map((text) => plan(text)).toList(),
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
                                'Meter Number',
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
                              controller: meterNumberController,
                              focusNode: _meterNumberFocusNode,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Meter Number',
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
                              keyboardType: TextInputType
                                  .number, // This allows only numeric input
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter
                                    .digitsOnly, // This will filter out non-numeric input
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
                                'Amount To Pay',
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
                              controller: amountController,
                              focusNode: _amountFocusNode,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                              decoration: InputDecoration(
                                labelText: '',
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
                              keyboardType: TextInputType
                                  .number, // This allows only numeric input
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter
                                    .digitsOnly, // This will filter out non-numeric input
                              ],
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
                              onPressed:
                                  isButtonEnabled // Enable or disable the button
                                      ? () {
                                          setState(() {
                                            paymentSectionDataOpen =
                                                true; // Proceed if valid
                                          });
                                        }
                                      : null, // Disable button if conditions are not met
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors
                                          .white; // Change color when pressed
                                    }
                                    return isButtonEnabled // Check if button should be enabled
                                        ? const Color(
                                            0xFF02AA03) // Active color
                                        : Colors.grey; // Inactive color
                                  },
                                ),
                                foregroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    return isButtonEnabled // Check if button should be enabled
                                        ? (states.contains(WidgetState.pressed)
                                            ? const Color(
                                                0xFF02AA03) // Change text color when pressed
                                            : Colors
                                                .white) // Default text color
                                        : Colors
                                            .white; // Text color when inactive
                                  },
                                ),
                                elevation: WidgetStateProperty.all<double>(4.0),
                                shape: WidgetStateProperty.resolveWith<
                                    RoundedRectangleBorder>(
                                  (Set<WidgetState> states) {
                                    return RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 3,
                                        color: isButtonEnabled
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
                                      'Electricity Type',
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
                                      width: (40 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .width) *
                                          MediaQuery.of(context).size.width,
                                      height: (40 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .height) *
                                          MediaQuery.of(context).size.height,
                                      child: Image.asset(
                                        providerImg,
                                        fit: BoxFit.cover,
                                      ),
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
                                      'Meter Number',
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
                                      meterNumberController.text.trim(),
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
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      'Meter Username',
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
                                      'William Gift',
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
                                      'Discount',
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
                                        const Text(
                                          '-',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Inter',
                                            color: Colors.black,
                                          ),
                                        ),
                                        Image.asset(
                                          'images/NairaImg.png',
                                          height: 15,
                                        ),
                                        const Text(
                                          '10.00',
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
                                      'Your Electricity bill for 001FD28910 has been sent and received within 1 hour',
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

  Widget radioButton(
      String img, String text, int value, StateSetter setState2) {
    return RadioListTile<int>(
      value: value,
      activeColor: const Color(0xFF02AA03),
      groupValue: _selectedPlanRadioValue,
      onChanged: (int? value) {
        setState(() {
          providerText = text;
          providerImg = img;
        });
        setState2(() {
          _selectedPlanRadioValue = value!;
        });
      },
      title: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(55),
                child: Container(
                  width: (40 / MediaQuery.of(context).size.width) *
                      MediaQuery.of(context).size.width,
                  height: (40 / MediaQuery.of(context).size.height) *
                      MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(55.0),
                    ),
                  ),
                  child: Image.asset(
                    img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Expanded(
                child: Text(
                  text,
                  softWrap: true,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
          // Wrap Divider with a Container to ensure it occupies the full width
          const SizedBox(
            width: double.infinity, // Makes the divider occupy the full width
            child: Divider(),
          ),
        ],
      ),
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget plan(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap: () {
          setState(() {
            currentPlanText = text;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(127, 173, 255, 174),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            border: currentPlanText == text
                ? Border.all(width: 2, color: const Color(0xFF02AA03))
                : Border.all(width: 0, color: Colors.transparent),
          ),
          child: SizedBox(
            width: (120 / MediaQuery.of(context).size.width) *
                MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      color: currentPlanText == text
                          ? const Color(0xFF02AA03)
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _typeDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 0, color: Colors.grey),
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
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (String? newValue) {
          setState(() {
            _type = newValue;
          });
        },
        hint: const Text('Select Meter Type'),
        items: <String>['Prepaid', 'Postpaid']
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

class Plan {
  final String name;
  final String userPrice;
  final String planId;

  Plan({required this.planId, required this.name, required this.userPrice});

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      name: json['name'],
      userPrice: json['user_price'],
      planId: json['plan_id'] ?? "0",
    );
  }
}
