import 'package:bills_plug/add_money_old_users.dart';
import 'package:bills_plug/add_photo.dart';
import 'package:bills_plug/airtime_and_data_page.dart';
import 'package:bills_plug/notification.dart';
import 'package:bills_plug/self_service.dart';
import 'package:bills_plug/transaction.dart';
import 'package:bills_plug/transaction_pin.dart';
import 'package:bills_plug/upgrade_to_agent.dart';
import 'package:bills_plug/verify_account_details.dart';
import 'package:bills_plug/withdraw_money.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'add_money_new_users.dart';
import 'cable_tv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:bills_plug/referral_page.dart';
import 'package:bills_plug/networking.dart';
import 'package:bills_plug/billsplug_chat.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  String? profileImg;
  bool _isBalanceVisible = false;
  List<String> imagePaths = [
    "images/AdImg.png",
    "images/AdImg.png",
    "images/AdImg.png",
  ];
  int _current = 0;

  // Use the fully qualified CarouselController from the carousel_slider package
  final CarouselController _controller = CarouselController();
  late SharedPreferences prefs;
  String? firstName;
  String? lastName;
  String? fullName;
  String? userBalance;

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0, bottom: 40),
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
                                    borderRadius: BorderRadius.circular(55),
                                    child: Container(
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
                                    borderRadius: BorderRadius.circular(55),
                                    child: Container(
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
                                      MediaQuery.of(context).size.width * 0.02),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      builder: (context) => NotificationPage(
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
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Total Balance",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                              _isBalanceVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.white),
                                          onPressed: () {
                                            setState(() {
                                              _isBalanceVisible =
                                                  !_isBalanceVisible;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    if (_isBalanceVisible != false)
                                      Row(
                                        children: [
                                          Image.asset(
                                            'images/NairaImg.png',
                                            height: 20,
                                            color: Colors.white,
                                          ),
                                          if (userBalance != null)
                                            Text(
                                              double.tryParse(userBalance!) !=
                                                      null
                                                  ? double.parse(userBalance!)
                                                      .toStringAsFixed(2)
                                                  : "0.00",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 27.0,
                                                color: Colors.white,
                                              ),
                                            )
                                          else
                                            const Text(
                                              "0.00",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 27.0,
                                                color: Colors.white,
                                              ),
                                            )
                                        ],
                                      )
                                    else
                                      const Text(
                                        "****",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 27.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              // IconButton(
                              //   icon: Icon(
                              //       _isBalanceVisible
                              //           ? Icons.visibility
                              //           : Icons.visibility_off,
                              //       color: Colors.white),
                              //   onPressed: () {
                              //     setState(() {
                              //       _isBalanceVisible = !_isBalanceVisible;
                              //     });
                              //   },
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                              "Account Details",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Color(0xFF02AA03),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005),
                            const Text(
                              "Basic Information",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04),
                            basicInfo("Name: ", "William John", Icons.person),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Divider(
                                color: Colors.grey,
                                height: 20,
                              ),
                            ),
                            basicInfo("Email: ", "test@gmail.com", Icons.mail),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Divider(
                                color: Colors.grey,
                                height: 20,
                              ),
                            ),
                            basicInfo("Phone: ", "09022999999", Icons.phone),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Divider(
                                color: Colors.grey,
                                height: 20,
                              ),
                            ),
                            basicInfo("State: ", "Delta", Icons.map),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Divider(
                                color: Colors.grey,
                                height: 20,
                              ),
                            ),
                            basicInfo("KYC: ", "Not Submitted",
                                Icons.domain_verification,
                                showUnverified: true),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TransactionPage(
                                      key: UniqueKey(),
                                    ),
                                  ),
                                );
                              },
                              child: basicInfo(
                                  "Transaction History", "", Icons.history_edu,
                                  showArrow: true),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Divider(
                                color: Colors.grey,
                                height: 20,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelfServicePage(
                                      key: UniqueKey(),
                                    ),
                                  ),
                                );
                              },
                              child: basicInfo(
                                  "Self Help", "", Icons.self_improvement,
                                  showArrow: true),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Divider(
                                color: Colors.grey,
                                height: 20,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VerifyAccountDetails(
                                      key: UniqueKey(),
                                    ),
                                  ),
                                );
                              },
                              child: basicInfo("Password", "", Icons.lock,
                                  showArrow: true),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Divider(
                                color: Colors.grey,
                                height: 20,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TransactionPin(
                                      key: UniqueKey(),
                                    ),
                                  ),
                                );
                              },
                              child: basicInfo("Reset Pin", "", Icons.key,
                                  showArrow: true),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Divider(
                                color: Colors.grey,
                                height: 20,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReferralPage(
                                      key: UniqueKey(),
                                    ),
                                  ),
                                );
                              },
                              child: basicInfo("Referral", "", Icons.person_add,
                                  showArrow: true),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Divider(
                                color: Colors.grey,
                                height: 20,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Networking(
                                      key: UniqueKey(),
                                    ),
                                  ),
                                );
                              },
                              child: basicInfo("Networking", "", Icons.public,
                                  showArrow: true),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Divider(
                                color: Colors.grey,
                                height: 20,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BillsplugChat(
                                      key: UniqueKey(),
                                    ),
                                  ),
                                );
                              },
                              child: basicInfo("Billsplug Chat", "", Icons.chat,
                                  showArrow: true),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Divider(
                                color: Colors.grey,
                                height: 20,
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
          ],
        ),
      ),
    );
  }

  Widget basicInfo(String title, String value, IconData icon,
      {showUnverified = false, showArrow = false}) {
    return Row(
      children: [
        IconButton(
          icon: Icon(icon, color: const Color(0xFF02AA03)),
          onPressed: () {},
        ),
        Expanded(
          flex: 10,
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showUnverified == true)
          Expanded(
            flex: 10,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFF0C0C),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: const Text(
                "UNVERIFIED",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (showArrow == true) const Spacer(),
        if (showArrow == true)
          IconButton(
            icon: Icon(
              Icons.navigate_next,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {},
          ),
      ],
    );
  }
}
