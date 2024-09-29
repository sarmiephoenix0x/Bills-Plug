import 'package:bills_plug/register_page_second.dart';
import 'package:flutter/material.dart';
import 'package:bills_plug/register_page.dart';
import 'Login_Page.dart';
import 'package:bills_plug/forgot_password_number.dart';

import 'forgot_password_email.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword>
    with TickerProviderStateMixin {
  final FocusNode _whatsappNumberFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  final TextEditingController whatsappNumberController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();

  TabController? _tabController;

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
                            height: MediaQuery.of(context).size.height * 0.05),
                        Image.asset(
                          "images/AppLogo.png",
                          fit: BoxFit.contain,
                          width: 150,
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
                              'Forgot Password',
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
                              'Enter the email account associated with your account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF02AA03),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            TabBar(
                              controller: _tabController,
                              tabs: [
                                _buildTab('Phone Number'),
                                _buildTab('Email'),
                              ],
                              labelColor:
                                  Theme.of(context).colorScheme.onSurface,
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
                              indicatorColor: Colors.black,
                              dividerHeight: 0,
                            ),
                            SizedBox(
                              height:
                                  (190 / MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  ListView(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: TextFormField(
                                          controller: whatsappNumberController,
                                          focusNode: _whatsappNumberFocusNode,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                          ),
                                          decoration: InputDecoration(
                                              labelText: 'WhatsApp Number',
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
                                                borderSide: const BorderSide(
                                                    width: 3,
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: const BorderSide(
                                                    width: 3,
                                                    color: Color(0xFF02AA03)),
                                              ),
                                              prefixIcon: IconButton(
                                                icon: const Icon(
                                                  Icons.phone,
                                                  color: Colors.grey,
                                                ),
                                                onPressed: () {},
                                              )),
                                          cursorColor: const Color(0xFF02AA03),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
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
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPasswordNumber(
                                                        key: UniqueKey()),
                                              ),
                                            );
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
                                                  return const Color(
                                                      0xFF02AA03);
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
                                            'Recover Password',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ListView(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: TextFormField(
                                          controller: emailController,
                                          focusNode: _emailFocusNode,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                          ),
                                          decoration: InputDecoration(
                                              labelText: 'Email',
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
                                                borderSide: const BorderSide(
                                                    width: 3,
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: const BorderSide(
                                                    width: 3,
                                                    color: Color(0xFF02AA03)),
                                              ),
                                              prefixIcon: IconButton(
                                                icon: const Icon(
                                                  Icons.mail,
                                                  color: Colors.grey,
                                                ),
                                                onPressed: () {},
                                              )),
                                          cursorColor: const Color(0xFF02AA03),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
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
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPasswordEmail(
                                                        key: UniqueKey()),
                                              ),
                                            );
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
                                                  return const Color(
                                                      0xFF02AA03);
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
                                            'Recover Password',
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
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Already have an account?",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LoginPage(key: UniqueKey()),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Login',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        decorationColor: Color(0xFF02AA03),
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13.0,
                                        color: Color(0xFF02AA03),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterPage(key: UniqueKey()),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Register',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        decorationColor: Color(0xFF02AA03),
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13.0,
                                        color: Color(0xFF02AA03),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

  Widget _buildTab(String name) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(name),
      ),
    );
  }
}
