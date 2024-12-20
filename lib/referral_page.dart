import 'package:bills_plug/add_photo.dart';
import 'package:bills_plug/notification.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:bills_plug/withdraw_money.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage>
    with TickerProviderStateMixin {
  String? profileImg;
  late SharedPreferences prefs;
  String? firstName;
  String? lastName;
  String? fullName;

  @override
  void initState() {
    super.initState();
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    firstName = await getFirstName();
    lastName = await getLastName();
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
                                  bottom: 20.0),
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
                                    MediaQuery.of(context).size.height * 0.05),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 20.0),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.0),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Referrals",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                                color: Color(0xFF02AA03)),
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02),
                                          const Text(
                                            "0",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 20.0),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.0),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Commission",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                                color: Color(0xFF02AA03)),
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'images/NairaImg.png',
                                                height: 15,
                                              ),
                                              const Text(
                                                "0",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
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
                                    Radius.circular(15.0),
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
                                      "Referral Link",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0,
                                          color: Color(0xFF02AA03)),
                                    ),
                                    const Text(
                                      "Referral Link",
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10.0),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFE2E2E2),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: Text(
                                                "https://billsplug.ng//mobile/register/?referral=09055259546",
                                                overflow: TextOverflow.clip,
                                                softWrap: false,
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: (50 /
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height) *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Copy the link to the clipboard
                                              Clipboard.setData(const ClipboardData(
                                                  text:
                                                      "https://billsplug.ng//mobile/register/?referral=09055259546"));
                                              // Optionally show a snackbar to inform the user
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Link copied to clipboard!')),
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty
                                                      .resolveWith<Color>(
                                                (Set<WidgetState> states) {
                                                  if (states.contains(
                                                      WidgetState.pressed)) {
                                                    return const Color(
                                                        0xFFE9FFEF);
                                                  }
                                                  return const Color(
                                                      0xFFFF0000);
                                                },
                                              ),
                                              foregroundColor:
                                                  WidgetStateProperty
                                                      .resolveWith<Color>(
                                                (Set<WidgetState> states) {
                                                  if (states.contains(
                                                      WidgetState.pressed)) {
                                                    return const Color(
                                                        0xFFFF0000);
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
                                                      color: Color(0xFFFF0000)),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(35)),
                                                ),
                                              ),
                                            ),
                                            child: const Row(
                                              children: [
                                                Text(
                                                  'Copy Link',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
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
                                        SizedBox(
                                          height: (50 /
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height) *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      WithdrawMoneyPage(
                                                    key: UniqueKey(),
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty
                                                      .resolveWith<Color>(
                                                (Set<WidgetState> states) {
                                                  if (states.contains(
                                                      WidgetState.pressed)) {
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
                                                      WidgetState.pressed)) {
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
                                                      color: Color(0xFF02AA03)),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(35)),
                                                ),
                                              ),
                                            ),
                                            child: const Row(
                                              children: [
                                                Text(
                                                  'Withdraw',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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
                                    Radius.circular(15.0),
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
                                      "Commission List",
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10.0),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF02AA03),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(0.0),
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: Text(
                                                "Service",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 16.0,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Spacer(),
                                            Expanded(
                                              flex: 5,
                                              child: Text(
                                                "Bonus",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 16.0,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    list("Account Upgrade", "0"),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                    list("Airtime Bonus", "0"),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                    list("Data Bonus", "0"),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                    list("Cable TV Bonus", "0"),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                    list("Electricity Bonus", "0"),
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

  Widget list(String text, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(0.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 10,
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 16.0),
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
                  amount,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
