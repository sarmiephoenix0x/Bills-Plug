import 'package:bills_plug/register_page_second.dart';
import 'package:flutter/material.dart';
import 'Login_Page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_app.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  final storage = const FlutterSecureStorage();
  late SharedPreferences prefs;
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.4, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _registerUser() async {
    if (prefs == null) {
      await _initializePrefs();
    }
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String phoneNumber = phoneNumberController.text.trim();
    final String country = countryController.text.trim();
    final String username = userNameController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty ||
        country.isEmpty) {
      _showCustomSnackBar(
        context,
        'All fields are required.',
        isError: true,
      );
      return;
    }

    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      _showCustomSnackBar(
        context,
        'Please enter a valid email address.',
        isError: true,
      );
      return;
    }

    if (password.length < 6) {
      _showCustomSnackBar(
        context,
        'Password must be at least 6 characters.',
        isError: true,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://glad.payguru.com.ng/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'country': country,
      }),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print('Response Data: $responseData');

    if (response.statusCode == 201) {
      final Map<String, dynamic> user = responseData['user'];
      final String accessToken = responseData['access_token'];
      final String profilePhoto = responseData['profile_photo'];

      user['profile_photo'] = profilePhoto;
      await storage.write(key: 'accessToken', value: accessToken);
      await prefs.setString('user', jsonEncode(user));

      _showCustomSnackBar(
        context,
        'Sign up successful! Welcome, ${user['name']}',
        isError: false,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainApp(key: UniqueKey()),
        ),
      );
    } else if (response.statusCode == 400) {
      setState(() {
        isLoading = false;
      });

      final Map<String, dynamic> errors = responseData['errors'];
      String errorMessage = 'Error: ';

      // Collect error messages for each field
      errors.forEach((field, messages) {
        errorMessage += '$field: ${messages.join(", ")}\n';
      });

      _showCustomSnackBar(
        context,
        errorMessage,
        isError: true,
      );
    } else {
      setState(() {
        isLoading = false;
      });
      _showCustomSnackBar(
        context,
        'An unexpected error occurred.',
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
                              'Register',
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                controller: nameController,
                                focusNode: _nameFocusNode,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                                decoration: InputDecoration(
                                    labelText: 'Name',
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
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          width: 3, color: Color(0xFF02AA03)),
                                    ),
                                    prefixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {},
                                    )),
                                cursorColor: const Color(0xFF02AA03),
                              ),
                            ),
                            // SizedBox(
                            //     height:
                            //         MediaQuery.of(context).size.height * 0.02),
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 20.0),
                            //   child: TextFormField(
                            //     controller: userNameController,
                            //     focusNode: _userNameFocusNode,
                            //     style: const TextStyle(
                            //       fontSize: 16.0,
                            //     ),
                            //     decoration: InputDecoration(
                            //         labelText: 'Last Name',
                            //         labelStyle: const TextStyle(
                            //           color: Colors.grey,
                            //           fontFamily: 'Inter',
                            //           fontSize: 12.0,
                            //           decoration: TextDecoration.none,
                            //         ),
                            //         floatingLabelBehavior:
                            //             FloatingLabelBehavior.never,
                            //         border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(15),
                            //           borderSide: const BorderSide(
                            //               width: 3, color: Colors.grey),
                            //         ),
                            //         focusedBorder: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(15),
                            //           borderSide: const BorderSide(
                            //               width: 3, color: Color(0xFF02AA03)),
                            //         ),
                            //         prefixIcon: IconButton(
                            //           icon: const Icon(
                            //             Icons.person,
                            //             color: Colors.grey,
                            //           ),
                            //           onPressed: () {},
                            //         )),
                            //     cursorColor: const Color(0xFF02AA03),
                            //   ),
                            // ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                controller: phoneNumberController,
                                focusNode: _phoneNumberFocusNode,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                                decoration: InputDecoration(
                                    labelText: 'Phone Number',
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
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          width: 3, color: Color(0xFF02AA03)),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
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
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          width: 3, color: Color(0xFF02AA03)),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                controller: countryController,
                                focusNode: _countryFocusNode,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                                decoration: InputDecoration(
                                    labelText: 'Country',
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
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          width: 3, color: Color(0xFF02AA03)),
                                    ),
                                    prefixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.map,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {},
                                    )),
                                cursorColor: const Color(0xFF02AA03),
                              ),
                            ),
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
                                onPressed: () {
                                  _registerUser();
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         RegisterPageSecond(key: UniqueKey()),
                                  //   ),
                                  // );
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                          ]),
                        ),
                      ),
                    ),
                  ),
                  if (isLoading)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: ScaleTransition(
                            scale: _animation,
                            child: Image.asset(
                              'images/Loading.png',
                            ),
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
}
