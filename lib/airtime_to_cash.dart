import 'package:bills_plug/airtime_to_cash2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;

class AirtimeToCashPage extends StatefulWidget {
  const AirtimeToCashPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  AirtimeToCashPageState createState() => AirtimeToCashPageState();
}

class AirtimeToCashPageState extends State<AirtimeToCashPage>
    with SingleTickerProviderStateMixin {
  final FocusNode _phoneNumberFocusNode = FocusNode();

  final TextEditingController phoneNumberController = TextEditingController();

  List<String> imagePaths = [
    "images/AdImg.png",
    "images/AdImg2.png",
    "images/AdImg.png",
  ];
  int _current = 0;

  final CarouselController _controller = CarouselController();

  bool _addToBeneficiary = false;
  bool paymentSectionAirtimeToCashOpen = false;
  List<String> networkImagePaths = [
    "images/MTNImg.png",
    "images/AirtelImg.png",
    "images/GloImg.png",
    "images/9MobileImg.png",
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
  String networkErrorMessage = "";
  int currentNetwork = 0;
  String phoneNumber = '';
  String networkName = "MTN";
  String currentNetworkImg = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentNetwork == 0) {
      networkName = "MTN";
      currentNetworkImg = "images/MTNImg.png";
    } else if (currentNetwork == 1) {
      networkName = "AIRTEL";
      currentNetworkImg = "images/AirtelImg.png";
    } else if (currentNetwork == 2) {
      networkName = "GLO";
      currentNetworkImg = "images/GloImg.png";
    } else if (currentNetwork == 3) {
      networkName = "9MOBILE";
      currentNetworkImg = "images/9MobileImg.png";
    }
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
                                  child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: networkImagePaths.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  currentNetwork = index;
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
                                                  border: currentNetwork ==
                                                          index
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
                                                  networkImagePaths[index],
                                                  height: 30,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ))),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: TextFormField(
                                      controller: phoneNumberController,
                                      focusNode: _phoneNumberFocusNode,
                                      decoration: InputDecoration(
                                        labelText: 'Mobile Number',
                                        labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                          fontSize: 16.0,
                                          decoration: TextDecoration.none,
                                        ),
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
                                            color: Color(0xFF02AA03),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                      maxLength:
                                          11, // Limit to 11 digits for Nigeria
                                      keyboardType: TextInputType.phone,
                                      onChanged: (value) {
                                        setState(() {
                                          phoneNumber = value;

                                          // Ensure the phone number is 11 digits long
                                          if (phoneNumber.length > 11) {
                                            phoneNumber = phoneNumber.substring(
                                                phoneNumber.length - 11);
                                          }

                                          if (phoneNumber.length == 11) {
                                            FocusScope.of(context)
                                                .unfocus(); // Dismiss the keyboard
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
                                            value.length != 11) {
                                          return 'Please enter a valid 11-digit mobile number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
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
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              if (phoneNumber.length == 11 &&
                                  networkErrorMessage.isEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        'images/SellAirtimeBG.png',
                                        width: double.infinity,
                                        fit: BoxFit.contain,
                                      ),
                                      Positioned(
                                        top: MediaQuery.of(context)
                                                .padding
                                                .left +
                                            10,
                                        left: MediaQuery.of(context)
                                                .padding
                                                .left +
                                            10,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'images/NairaAndPhoneImg.png',
                                              width: 40,
                                              fit: BoxFit.contain,
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02),
                                            const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'SELL AIRTIME',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                    color: Color(0xFF02AA03),
                                                  ),
                                                ),
                                                Text(
                                                  'To Get Cash',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 13.0,
                                                    color: Color(0xFF02AA03),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: MediaQuery.of(context)
                                                .padding
                                                .bottom +
                                            10,
                                        right: MediaQuery.of(context)
                                                .padding
                                                .right +
                                            10,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AirtimeToCashOTPPage(
                                                  key: UniqueKey(),
                                                  networkImg: currentNetworkImg,
                                                  networkName: networkName,
                                                  number: phoneNumber,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 12.0),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF02AA03),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(25.0),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                const Text(
                                                  'GO',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02),
                                                Image.asset(
                                                  'images/TinyForwardArrow.png',
                                                  width: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
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
