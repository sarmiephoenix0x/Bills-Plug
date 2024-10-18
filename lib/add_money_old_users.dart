import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;

class AddMoneyOldUsers extends StatefulWidget {
  const AddMoneyOldUsers({super.key});

  @override
  // ignore: library_private_types_in_public_api
  AddMoneyOldUsersState createState() => AddMoneyOldUsersState();
}

class AddMoneyOldUsersState extends State<AddMoneyOldUsers>
    with SingleTickerProviderStateMixin {
  List<String> bankName = [
    "Moniepoint Bank",
    "OPAY",
    "KUDA",
  ];
  int _current = 0;

  final CarouselController _controller = CarouselController();

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
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.01),
                              const Text(
                                'Add Money',
                                style: TextStyle(
                                  fontFamily: 'Inter',
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
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Center(
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Note: ',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Color(0xFFFF2626),
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'Automated bank transfer attracts additional charges of 1.7% only. Any money sent to this accounts will reflect on your account immediately.',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16.0,
                                      color: Color(0xFFFF2626),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        SizedBox(
                          height: (280.0 / MediaQuery.of(context).size.height) *
                              MediaQuery.of(context).size.height,
                          child: PageView.builder(
                            itemCount:
                                bankName.length, // Number of latest news items
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 20.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        // Softer shadow for a clean look
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: const Offset(
                                            0, 2), // Position shadow for depth
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
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
                                                'images/BankImg.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          const Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Bank Transfer",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                Text(
                                                  "Add money via mobile or internet banking",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      Image.asset(
                                        'images/DividerImg.png',
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: 'Bank Name: ',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 18.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: bankName[index],
                                                    style: const TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 18.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          Image.asset(
                                            'images/ion_copy-outline.png',
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      const Text(
                                        "650 698 1859",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: (40 /
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0.0),
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<WidgetState> states) {
                                                      if (states.contains(
                                                          WidgetState
                                                              .pressed)) {
                                                        return const Color(
                                                            0xFF02AA03);
                                                      }
                                                      return Colors.white;
                                                    },
                                                  ),
                                                  foregroundColor:
                                                      WidgetStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<WidgetState> states) {
                                                      if (states.contains(
                                                          WidgetState
                                                              .pressed)) {
                                                        return const Color(
                                                            0xFFE9FFEF);
                                                      }
                                                      return const Color(
                                                          0xFF02AA03);
                                                    },
                                                  ),
                                                  elevation: WidgetStateProperty
                                                      .all<double>(4.0),
                                                  shape: WidgetStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                    const RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          width: 3,
                                                          color: Color(
                                                              0xFF02AA03)),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  35)),
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Copy Number',
                                                  textAlign: TextAlign.center,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          Expanded(
                                            child: Container(
                                              height: (40 /
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0.0),
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<WidgetState> states) {
                                                      if (states.contains(
                                                          WidgetState
                                                              .pressed)) {
                                                        return const Color(
                                                            0xFFE9FFEF);
                                                      }
                                                      return const Color(
                                                          0xFF02AA03);
                                                    },
                                                  ),
                                                  foregroundColor:
                                                      WidgetStateProperty
                                                          .resolveWith<Color>(
                                                    (Set<WidgetState> states) {
                                                      if (states.contains(
                                                          WidgetState
                                                              .pressed)) {
                                                        return const Color(
                                                            0xFF02AA03);
                                                      }
                                                      return const Color(
                                                          0xFFE9FFEF);
                                                    },
                                                  ),
                                                  elevation: WidgetStateProperty
                                                      .all<double>(4.0),
                                                  shape: WidgetStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                    const RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          width: 3,
                                                          color: Color(
                                                              0xFF02AA03)),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  35)),
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Share Details",
                                                  textAlign: TextAlign.center,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
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
                              );
                            },
                            onPageChanged: (index) {
                              setState(() {
                                _current =
                                    index; // Update the current page index
                              });
                            },
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            bankName.length,
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
                                height:
                                    (10 / MediaQuery.of(context).size.height) *
                                        MediaQuery.of(context).size.height,
                              ),
                            ),
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
      },
    );
  }
}
