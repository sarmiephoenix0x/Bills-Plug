import 'package:bills_plug/airtime_to_cash.dart';
import 'package:flutter/material.dart';
import 'package:bills_plug/airtime_and_data_page.dart';
import 'cable_tv.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage>
    with TickerProviderStateMixin {
  String? profileImg;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ListView(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 20.0,
                                  bottom: 40),
                              decoration: const BoxDecoration(
                                color: Color(0xFF02AA03),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (profileImg == null)
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
                                              'images/ProfilePic.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      else if (profileImg != null)
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
                                            child: Image.network(
                                              profileImg!,
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
                                              "Hello",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              "William John",
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
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         TransactionPin(key: UniqueKey()),
                                          //   ),
                                          // );
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
                                    MediaQuery.of(context).size.height * 0.05),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Payment Services",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                    Wrap(
                                      runSpacing: 10.0,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AirtimeAndDataPage(
                                                  key: UniqueKey(),
                                                  tabIndex: 0,
                                                ),
                                              ),
                                            );
                                          },
                                          child: services(
                                              'images/Airtime.png', 'Airtime'),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AirtimeAndDataPage(
                                                  key: UniqueKey(),
                                                  tabIndex: 1,
                                                ),
                                              ),
                                            );
                                          },
                                          child: services(
                                              'images/Data.png', 'Data'),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CableTVPage(
                                                        key: UniqueKey()),
                                              ),
                                            );
                                          },
                                          child: services(
                                              'images/CableTV.png', 'Cable TV'),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: services('images/ExamPins.png',
                                              'Exam Pins'),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: services('images/DataPins.png',
                                              'Data Pin'),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: services(
                                              'images/Electricity.png',
                                              'Electricity'),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: services('images/Betting.png',
                                              'Fund Betting Wallet'),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AirtimeToCashPage(
                                                  key: UniqueKey(),
                                                ),
                                              ),
                                            );
                                          },
                                          child: services(
                                              'images/Airtime2Cash.png',
                                              'Airtime2cash'),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: services(
                                              'images/RechargeCardPrinting.png',
                                              'Recharge card printing'),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: services('images/ExamPins.png',
                                              'Jamb E-PIN'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Others",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                    Wrap(
                                      runSpacing: 10.0,
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: services(
                                              'images/Pricing.png', 'Pricing'),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: services(
                                              'images/History.png', 'History'),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: services('images/mdi_bell.png',
                                              'Notification'),
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

  Widget services(String img, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        decoration: const BoxDecoration(
          color: Color(0xFFF7FFF1),
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              img,
              height: 30,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
