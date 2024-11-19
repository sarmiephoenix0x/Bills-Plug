import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  DataPageState createState() => DataPageState();
}

class DataPageState extends State<DataPage>
    with SingleTickerProviderStateMixin {
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  List<String> imagePaths = [
    "images/MTNImg.png",
    "images/AirtelImg.png",
    "images/GloImg.png",
    "images/9MobileImg.png",
  ];

  List<String> networkImg = [
    "images/MTNImg.png",
    "images/AirtelImg.png",
    "images/GloImg.png",
    "images/9MobileImg.png",
  ];

  List<String> networkNumber = [
    "09099999999",
    "08088888888",
    "07077777777",
    "07066666666",
  ];

  List<String> planText = [
    "SME",
    "Gifting",
    "CO - OPERATE GIFTING",
    "Special Offer"
  ];

  List<String> mtnPrefixes = [
    "0703",
    "0704",
    "0706",
    "0803",
    "0806",
    "0810",
    "0813",
    "0814",
    "0816",
    "0903",
    "0906",
    "0913",
    "0916"
  ];

  List<String> airtelPrefixes = [
    "0701",
    "0708",
    "0802",
    "0808",
    "0812",
    "0815",
    "0817",
    "0901",
    "0902",
    "0907"
  ];

  List<String> gloPrefixes = [
    "0705",
    "0805",
    "0811",
    "0815",
    "0818",
    "0905",
    "0915"
  ];

  List<String> nineMobilePrefixes = [
    "0709",
    "0809",
    "0817",
    "0818",
    "0819",
    "0904",
    "09088",
    "0909"
  ];

  bool paymentSectionDataOpen = false;
  String? userBalance;
  late SharedPreferences prefs;
  bool paymentSuccessful = false;
  String currentPlanText = "SME";
  String currentPlanOptionText = "";
  int currentNetwork = 0;
  String currentAmount = "0.00";
  List<Map<String, dynamic>> plans = [];
  late Future<List<Plan>> futurePlans;
  final storage = const FlutterSecureStorage();
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  String pinCode = "";
  String networkName = "MTN";
  bool inputPin = false;
  String planID = "0";
  Plan? selectedPlan;
  String phoneNumber = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isButtonEnabled = false;
  String networkErrorMessage = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.25, end: 0.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    futurePlans = fetchPlans();
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
    _controller.dispose();
    super.dispose();
  }

  void handleOtpInputComplete(String code) {
    setState(() {
      pinCode = code;
    });
    _submitDataPurchase(pinCode);
  }

  Future<List<Plan>> fetchPlans() async {
    final accessToken = await storage.read(key: 'billsplug_accessToken');
    final response = await http.get(
      Uri.parse('https://glad.payguru.com.ng/api/data/bundles/sme'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // Add the token to the headers
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['plans'];
      return jsonList.map((json) => Plan.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load plans');
    }
  }

  Future<void> _submitDataPurchase(String pin) async {
    setState(() {
      isLoading = true;
    });
    final accessToken = await storage.read(key: 'billsplug_accessToken');
    final url = Uri.parse("https://glad.payguru.com.ng/api/data/purchase");
    final requestBody = {
      "phone_number": phoneNumberController.text.trim(),
      "network": networkName,
      "plan_id": planID,
      "pin": pin,
    };

    try {
      final response =
          await http.post(url, body: json.encode(requestBody), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        inputPin = false;
        paymentSuccessful = true;
        print("Data purchase successful");
      } else if (response.statusCode == 400) {
        final errorMessage = json.decode(response.body)['error'];
        _showCustomSnackBar(
          context,
          errorMessage ?? "An error occurred",
          isError: true,
        );
      } else {
        final errors = json.decode(response.body)['errors'];
        print("Error: $errors");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showCustomSnackBar(
        context,
        'An error occurred. Please try again later.',
        isError: true,
      );
    }
  }

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
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void validateForm() {
    setState(() {
      isButtonEnabled = currentPlanOptionText != "" &&
          _formKey.currentState!
              .validate(); // Update button state based on validation
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentNetwork == 0) {
      networkName = "MTN";
    } else if (currentNetwork == 1) {
      networkName = "AIRTEL";
    } else if (currentNetwork == 2) {
      networkName = "GLO";
    } else if (currentNetwork == 3) {
      networkName = "9MOBILE";
    }
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
                    height: MediaQuery.of(context).size.height,
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
                                        0.15),
                                const Text(
                                  'Data Bundle',
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
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: imagePaths.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              currentNetwork = index;
                                              currentPlanOptionText = "";
                                            });
                                          },
                                          child: Container(
                                            width: (80 /
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width) *
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7.0, horizontal: 7.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                              border: currentNetwork == index
                                                  ? Border.all(
                                                      width: 2,
                                                      color: const Color(
                                                          0xFF02AA03))
                                                  : Border.all(
                                                      width: 0,
                                                      color:
                                                          Colors.transparent),
                                            ),
                                            child: Image.asset(
                                              imagePaths[index],
                                              height: 30,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ))),
                          // SizedBox(
                          //     height:
                          //         MediaQuery.of(context).size.height * 0.04),
                          // const Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 20.0),
                          //   child: Text(
                          //     'Recent Number',
                          //     style: TextStyle(
                          //       fontFamily: 'Inter',
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: 18.0,
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //     height:
                          //         MediaQuery.of(context).size.height * 0.04),
                          // SizedBox(
                          //   height: (50 / MediaQuery.of(context).size.height) *
                          //       MediaQuery.of(context).size.height,
                          //   child: ListView.builder(
                          //     scrollDirection: Axis.horizontal,
                          //     itemCount: networkImg.length,
                          //     itemBuilder: (context, index) {
                          //       return number(index, networkImg[index],
                          //           networkNumber[index]);
                          //     },
                          //   ),
                          // ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.04),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: IntlPhoneField(
                                    decoration: InputDecoration(
                                      labelText: 'Mobile Number',
                                      labelStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Inter',
                                        fontSize: 16.0,
                                        decoration: TextDecoration.none,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Color(0xFF02AA03),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                          width: 2,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: IconButton(
                                        icon: const Icon(
                                          Icons.contact_phone,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          // Action when the icon is pressed
                                        },
                                      ),
                                      counterText: '',
                                    ),
                                    initialCountryCode:
                                        'NG', // Set the initial country code to Nigeria
                                    showCountryFlag:
                                        false, // Hide the country flag
                                    onChanged: (phone) {
                                      validateForm();
                                      setState(() {
                                        phoneNumber = phone.completeNumber;
                                        if (phoneNumber.startsWith('+234')) {
                                          phoneNumber = phoneNumber
                                              .replaceFirst('+234', '');
                                        } else if (phoneNumber
                                            .startsWith('234')) {
                                          phoneNumber = phoneNumber
                                              .replaceFirst('234', '');
                                        }

                                        // Ensure the phone number is 11 digits long after removing the international code
                                        if (phoneNumber.length > 11) {
                                          phoneNumber = phoneNumber.substring(
                                              phoneNumber.length - 11);
                                        }

                                        // Check for MTN
                                        if (mtnPrefixes.any((prefix) =>
                                                phoneNumber
                                                    .startsWith(prefix)) &&
                                            currentNetwork == 0) {
                                          networkErrorMessage =
                                              ""; // Valid MTN number
                                        } else {
                                          if (currentNetwork == 0) {
                                            networkErrorMessage =
                                                'Please enter a valid MTN number.';
                                          }
                                        }

                                        // Check for Glo
                                        if (gloPrefixes.any((prefix) =>
                                            phoneNumber.startsWith(prefix))) {
                                          if (currentNetwork == 2) {
                                            networkErrorMessage =
                                                ""; // Valid Glo number
                                          }
                                        } else {
                                          if (currentNetwork == 2) {
                                            networkErrorMessage =
                                                'Please enter a valid Glo number.';
                                          }
                                        }

                                        // Check for Airtel
                                        if (airtelPrefixes.any((prefix) =>
                                            phoneNumber.startsWith(prefix))) {
                                          if (currentNetwork == 1) {
                                            networkErrorMessage =
                                                ""; // Valid Airtel number
                                          }
                                        } else {
                                          if (currentNetwork == 1) {
                                            networkErrorMessage =
                                                'Please enter a valid Airtel number.';
                                          }
                                        }

                                        // Check for 9Mobile
                                        if (nineMobilePrefixes.any((prefix) =>
                                            phoneNumber.startsWith(prefix))) {
                                          if (currentNetwork == 3) {
                                            networkErrorMessage =
                                                ""; // Valid 9Mobile number
                                          }
                                        } else {
                                          if (currentNetwork == 3) {
                                            networkErrorMessage =
                                                'Please enter a valid 9Mobile number.';
                                          }
                                        }
                                      });
                                    },
                                    validator: (value) {
                                      // Validate the phone number length for Nigeria
                                      if (value == null ||
                                          value.number.length != 11) {
                                        return 'Please enter a valid 11-digit mobile number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                // Display the error message below the input field
                                if (networkErrorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 20.0),
                                    child: Text(
                                      networkErrorMessage,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 14.0),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.04),
                          SizedBox(
                            height: (50 / MediaQuery.of(context).size.height) *
                                MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: ListView(
                              scrollDirection:
                                  Axis.horizontal, // Set to horizontal
                              children:
                                  planText.map((text) => plan(text)).toList(),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.04),

                          FutureBuilder<List<Plan>>(
                            future: futurePlans,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF02AA03),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Oops! Something went wrong while fetching the plans.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 16),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            futurePlans =
                                                fetchPlans(); // Retry fetching plans
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF02AA03)),
                                        child: const Text(
                                          'Retry',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                  child:
                                      Text('No plans available at the moment.'),
                                );
                              } else {
                                final plans = snapshot.data!;
                                List<Widget> planWidgets = [];

                                if (currentPlanText == "SME") {
                                  if (phoneNumber.length != 11) {
                                    // _showCustomSnackBar(
                                    //   context,
                                    //   'Please enter a valid 11-digit mobile number',
                                    //   isError: true,
                                    // );
                                    print(
                                        'Please enter a valid 11-digit mobile number');
                                    return Container();
                                  }
                                  if (currentNetwork == 0) {
                                    bool isMtnNumber = mtnPrefixes.any(
                                        (prefix) =>
                                            phoneNumber.startsWith(prefix));
                                    if (isMtnNumber) {
                                      planWidgets = plans
                                          .where((plan) => plan.name.contains(
                                              "MTN")) // Filtering based on your logic
                                          .map(
                                            (plan) => planOptions(plan.name,
                                                plan.userPrice, plan.planId,
                                                isSelected:
                                                    selectedPlan == plan),
                                          )
                                          .toList();
                                    }
                                  } else {
                                    // Add other plan conditions here (e.g., "CO - OPERATE GIFTING")
                                    selectedPlan = null;
                                  }
                                } else {
                                  // Add other plan conditions here (e.g., "CO - OPERATE GIFTING")
                                  selectedPlan = null;
                                }

                                // If a plan is selected, show only that plan
                                if (selectedPlan != null) {
                                  return Container(
                                    constraints: const BoxConstraints(
                                      maxHeight: 400.0, // Set a maximum height
                                    ),
                                    child: ListView(
                                      shrinkWrap:
                                          true, // Make the ListView shrink to fit its contents
                                      physics:
                                          const AlwaysScrollableScrollPhysics(), // Ensure it can still scroll if needed
                                      children: [
                                        planOptions(
                                          selectedPlan!.name,
                                          selectedPlan!.userPrice,
                                          selectedPlan!.planId,
                                          isSelected: true,
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container(
                                    constraints: const BoxConstraints(
                                      maxHeight: 400.0, // Set a maximum height
                                    ),
                                    child: ListView(
                                      shrinkWrap:
                                          true, // Make the ListView shrink to fit its contents
                                      physics:
                                          const AlwaysScrollableScrollPhysics(), // Ensure it can still scroll if needed
                                      children: planWidgets,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          // if (currentPlanText == "SME") ...[
                          //   planOptions("1.GB For 03 Days", "195.00"),
                          //   planOptions("2.GB For 07 Day", "290.00"),
                          //   planOptions("3.5GB For 30 Days", "485.00"),
                          //   planOptions("15GB For 30 Days", "1,950.00"),
                          // ] else if (currentPlanText ==
                          //     "CO - OPERATE GIFTING") ...[
                          //   planOptions("500MB For 07 Days", "145.00"),
                          //   planOptions("1GB For 02 Days", "265.00"),
                          //   planOptions("2GB For 30 Days", "530.00"),
                          //   planOptions("3GB For 30 Days", "795.00"),
                          //   planOptions("5GB For 30 Days", "1,325.00"),
                          //   planOptions("10GB For 30 Days", "2,650.00"),
                          // ],
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
                                'Purchase',
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
                  Stack(
                    children: [
                      // Overlay to close the payment section when tapped
                      if (paymentSectionDataOpen)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              paymentSectionDataOpen = false;
                            });
                          },
                          child: Container(
                            // Make the overlay fill the screen and slightly transparent
                            color: Colors.black.withOpacity(0.4),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
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
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                            double.parse(currentAmount
                                                .replaceAll(',', ''))),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
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
                                      if (currentNetwork == 0)
                                        network("images/MTNImg.png", "MTN"),
                                      if (currentNetwork == 1)
                                        network(
                                            "images/AirtelImg.png", "AIRTEL"),
                                      if (currentNetwork == 2)
                                        network("images/GloImg.png", "GLO"),
                                      if (currentNetwork == 3)
                                        network(
                                            "images/9MobileImg.png", "9MOBILE"),
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
                                          'Plan',
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
                                          currentPlanOptionText,
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
                                          phoneNumberController.text.trim(),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Image.asset(
                                              'images/NairaImg.png',
                                              height: 15,
                                            ),
                                            Text(
                                              currentAmount,
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
                                          paymentSectionDataOpen = false;
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
                                          NumberFormat('#,###.##').format(
                                              double.parse(currentAmount
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    const Text(
                                      'The recipient phone number will receive it within 1 minute',
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
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    OtpTextField(
                                      numberOfFields: 4,
                                      fieldWidth: (50 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .width) *
                                          MediaQuery.of(context).size.width,
                                      focusedBorderColor: const Color(
                                          0xFF02AA03), // Border color when focused
                                      enabledBorderColor: Colors.grey,
                                      borderColor: Colors.grey,
                                      showFieldAsBox: true,
                                      onCodeChanged: (String code) {
                                        // Handle real-time OTP input changes
                                      },
                                      onSubmit: (String code) =>
                                          handleOtpInputComplete(code),
                                    ),
                                  ],
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

  Widget number(int currentNetworkIndex, String img, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: InkWell(
        onTap: () {
          setState(() {
            currentNetwork = currentNetworkIndex;
            phoneNumberController.text = text;
            currentPlanOptionText = "";
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            border: currentNetwork == currentNetworkIndex &&
                    phoneNumberController.text == text
                ? Border.all(width: 2, color: const Color(0xFF02AA03))
                : Border.all(width: 0, color: Colors.transparent),
          ),
          child: SizedBox(
            width: (150 / MediaQuery.of(context).size.width) *
                MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                Flexible(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
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

  Widget plan(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: InkWell(
        onTap: () {
          setState(() {
            currentPlanText = text;
            currentPlanOptionText = "";
            networkErrorMessage = "";
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
            width: (150 / MediaQuery.of(context).size.width) *
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

  Widget planOptions(String text, String amount, String planId,
      {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: InkWell(
        onTap: () {
          validateForm();
          setState(() {
            if (isSelected) {
              // Deselect the current plan
              currentPlanOptionText = "";
              selectedPlan = null; // Deselect the plan
            } else {
              // Select a new plan
              currentPlanOptionText = text;
              currentAmount = amount;
              selectedPlan = Plan(
                name: text,
                userPrice: amount,
                planId: planId,
              ); // Update selectedPlan
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 7.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: isSelected
                ? Border.all(width: 2, color: const Color(0xFF02AA03))
                : Border.all(width: 2, color: Colors.black),
            color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 10,
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'images/NairaImg.png',
                      height: 15,
                    ),
                    Text(
                      amount,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
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
