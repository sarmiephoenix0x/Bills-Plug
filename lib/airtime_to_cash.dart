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
                                  'Phone Number',
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
                                child: TextFormField(
                                  controller: phoneNumberController,
                                  focusNode: _phoneNumberFocusNode,
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
                                      suffixIcon: IconButton(
                                        icon: const Icon(
                                          Icons.contact_phone,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {},
                                      )),
                                  cursorColor: const Color(0xFF02AA03),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
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
                                      top: MediaQuery.of(context).padding.left +
                                          10,
                                      left:
                                          MediaQuery.of(context).padding.left +
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
                                      right:
                                          MediaQuery.of(context).padding.right +
                                              10,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AirtimeToCashOTPPage(
                                                key: UniqueKey(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 12.0),
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
                                                  width: MediaQuery.of(context)
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
