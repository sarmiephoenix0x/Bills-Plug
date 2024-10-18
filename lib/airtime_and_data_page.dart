import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;

class AirtimeAndDataPage extends StatefulWidget {
  const AirtimeAndDataPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  AirtimeAndDataPageState createState() => AirtimeAndDataPageState();
}

class AirtimeAndDataPageState extends State<AirtimeAndDataPage>
    with SingleTickerProviderStateMixin {
  final FocusNode _phoneNumberFocusNode = FocusNode();

  final TextEditingController phoneNumberController = TextEditingController();

  TabController? _tabController;

  List<String> imagePaths = [
    "images/AdImg.png",
    "images/AdImg.png",
    "images/AdImg.png",
  ];
  int _current = 0;

  final CarouselController _controller = CarouselController();

  bool _addToBeneficiary = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                              const Spacer(),
                              const Text(
                                'Billsplug',
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
                            height: MediaQuery.of(context).size.height * 0.05),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TabBar(
                            controller: _tabController,
                            tabs: [
                              _buildTab('Airtime'),
                              _buildTab('Data'),
                            ],
                            labelColor: const Color(0xFF02AA03),
                            unselectedLabelColor: Colors.grey,
                            labelStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                            unselectedLabelStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                            labelPadding: EdgeInsets.zero,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: const Color(0xFF02AA03),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              ListView(
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
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Select Phone',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Enter mobile number',
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Image.asset(
                                            'images/teenyicons_down-solid.png',
                                            height: 15,
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
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
                                              'images/MTNImg.png',
                                              height: 30,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02),
                                        Expanded(
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
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide.none,
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: const BorderSide(
                                                      width: 3,
                                                      color: Color(0xFF02AA03)),
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
                                            cursorColor:
                                                const Color(0xFF02AA03),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Top Up',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7.0, horizontal: 7.0),
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
                                          Image.asset(
                                            'images/NairaImg.png',
                                            height: 15,
                                          ),
                                          const Text(
                                            '0.00',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 20.0),
                                    child: Row(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Checkbox(
                                              activeColor:
                                                  const Color(0xFF02AA03),
                                              checkColor: Colors.white,
                                              value: _addToBeneficiary,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  _addToBeneficiary = value!;
                                                });
                                              },
                                            ),
                                            const Text(
                                              "Add To Beneficiaries",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Inter',
                                                fontSize: 12.0,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
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
                                      onPressed: () {},
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
                                        'Continue',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                ],
                              ),
                              ListView(
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
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Buy Data',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Enter mobile number',
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
                                      onPressed: () {},
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
                                        'Continue',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04),
                            const Text(
                              'Welcome back!',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            const Text(
                              'William  John(*******9546)',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
                            Container(
                              width: double.infinity,
                              height:
                                  (60 / MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: ElevatedButton(
                                onPressed: () {},
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
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
                                    MediaQuery.of(context).size.height * 0.02),
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

  Widget airtime(String amount) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
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

  Widget _buildTab(String name) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(name),
      ),
    );
  }
}
