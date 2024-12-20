import 'package:flutter/material.dart';
import 'Login_Page.dart';
import 'main_app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPageSecond extends StatefulWidget {
  final String firstname;
  final String lastname;
  final String username;
  final String phoneNumber;
  final String email;
  const RegisterPageSecond(
      {super.key,
      required this.username,
      required this.phoneNumber,
      required this.email,
      required this.firstname,
      required this.lastname});

  @override
  // ignore: library_private_types_in_public_api
  RegisterPageSecondState createState() => RegisterPageSecondState();
}

class RegisterPageSecondState extends State<RegisterPageSecond>
    with SingleTickerProviderStateMixin {
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _referralFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController referralController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPasswordVisible2 = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isLoading = false;
  final storage = const FlutterSecureStorage();
  late SharedPreferences prefs;
  bool _hasShownBottomSheet = false;

  @override
  void initState() {
    super.initState();
    countryController.text = "Nigeria";
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.25, end: 0.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Future<void> _registerUser() async {
  //   if (prefs == null) {
  //     await _initializePrefs();
  //   }
  //   final String firstname = widget.firstname;
  //   final String lastname = widget.lastname;
  //   final String username = widget.username;
  //   final String email = widget.email;
  //   final String password = passwordController.text.trim();
  //   final String passwordConfirmation = confirmPasswordController.text.trim();
  //   final String phoneNumber = widget.phoneNumber;
  //   final String country = countryController.text.trim();
  //   final String state = stateController.text.trim();
  //   final String referral = referralController.text.trim();

  //   if (username.isEmpty ||
  //       email.isEmpty ||
  //       phoneNumber.isEmpty ||
  //       password.isEmpty ||
  //       passwordConfirmation.isEmpty ||
  //       country.isEmpty ||
  //       state.isEmpty) {
  //     _showCustomSnackBar(
  //       context,
  //       'All fields are required.',
  //       isError: true,
  //     );
  //     return;
  //   }

  //   final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  //   if (!emailRegex.hasMatch(email)) {
  //     _showCustomSnackBar(
  //       context,
  //       'Please enter a valid email address.',
  //       isError: true,
  //     );
  //     return;
  //   }

  //   if (password.length < 6) {
  //     _showCustomSnackBar(
  //       context,
  //       'Password must be at least 6 characters.',
  //       isError: true,
  //     );
  //     return;
  //   }

  //   if (password != passwordConfirmation) {
  //     _showCustomSnackBar(
  //       context,
  //       'Passwords do not match.',
  //       isError: true,
  //     );

  //     return;
  //   }

  //   setState(() {
  //     isLoading = true;
  //   });

  //   final response = await http.post(
  //     Uri.parse('https://glad.payguru.com.ng/api/register'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'firstname': firstname,
  //       'lastname': lastname,
  //       'username': username,
  //       'email': email,
  //       'mobile': phoneNumber,
  //       'password': password,
  //       'password_confirmation': passwordConfirmation,
  //       'country': country,
  //       'state': state,
  //       'ref_by': referral
  //     }),
  //   );

  //   final Map<String, dynamic> responseData = jsonDecode(response.body);
  //   print('Response Data: $responseData');

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> user = responseData['user'];
  //     // final String accessToken = responseData['access_token'];

  //     // await storage.write(key: 'billsplug_accessToken', value: accessToken);
  //     await prefs.setString('user', jsonEncode(user));

  //     _showCustomSnackBar(
  //       context,
  //       'Sign up successful! Welcome, ${user['firstname']}',
  //       isError: false,
  //     );

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => MainApp(key: UniqueKey()),
  //       ),
  //     );
  //   } else if (response.statusCode == 400) {
  //     setState(() {
  //       isLoading = false;
  //     });

  //     final Map<String, dynamic> errors = responseData['errors'];
  //     String errorMessage = 'Error: ';

  //     // Collect error messages for each field
  //     errors.forEach((field, messages) {
  //       errorMessage += '$field: ${messages.join(", ")}\n';
  //     });

  //     _showCustomSnackBar(
  //       context,
  //       errorMessage,
  //       isError: true,
  //     );
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     _showCustomSnackBar(
  //       context,
  //       'An unexpected error occurred.',
  //       isError: true,
  //     );
  //   }
  // }

  Future<void> _registerUser(
      StateSetter setState, Function(String) onError) async {
    if (prefs == null) {
      await _initializePrefs();
    }
    final String firstname = widget.firstname;
    final String lastname = widget.lastname;
    final String username = widget.username;
    final String email = widget.email;
    final String password = passwordController.text.trim();
    final String passwordConfirmation = confirmPasswordController.text.trim();
    final String phoneNumber = widget.phoneNumber;
    final String country = countryController.text.trim();
    final String state = stateController.text.trim();
    final String referral = referralController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty ||
        passwordConfirmation.isEmpty ||
        country.isEmpty ||
        state.isEmpty) {
      onError('All fields are required.');
      return;
    }

    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      onError('Please enter a valid email address.');
      return;
    }

    if (password.length < 6) {
      onError('Password must be at least 6 characters.');
      return;
    }

    if (password != passwordConfirmation) {
      onError('Passwords do not match.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://glad.payguru.com.ng/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstname': firstname,
        'lastname': lastname,
        'username': username,
        'email': email,
        'mobile': phoneNumber,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'country': country,
        'state': state,
        'ref_by': referral
      }),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print('Response Data: $responseData');

    if (response.statusCode == 200) {
      final Map<String, dynamic> user = responseData['user'];
      await prefs.setString('user', jsonEncode(user));

      _showCustomSnackBar(
        context,
        'Sign up successful! Welcome, ${user['firstname']}',
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

      onError(errorMessage);
    } else {
      setState(() {
        isLoading = false;
      });
      onError('An unexpected error occurred.');
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

  void showCustomBottomSheet(BuildContext context) {
    final GlobalKey<FormState> _formKey =
        GlobalKey<FormState>(); // Create a GlobalKey for the form
    String serverErrorMessage = ''; // Variable to hold server error messages

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, dynamic result) {
              if (!didPop) {
                // Navigator.pop(context);
              }
            },
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 2,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Form(
                        key: _formKey, // Assign the GlobalKey to the Form
                        child: Column(
                          children: [
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
                                controller: passwordController,
                                focusNode: _passwordFocusNode,
                                style: const TextStyle(fontSize: 16.0),
                                decoration: InputDecoration(
                                  labelText: 'Password',
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
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        width: 3, color: Color(0xFF02AA03)),
                                  ),
                                  prefixIcon: IconButton(
                                    icon: const Icon(Icons.lock,
                                        color: Colors.grey),
                                    onPressed: () {},
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                cursorColor: const Color(0xFF02AA03),
                                obscureText: !_isPasswordVisible,
                                obscuringCharacter: "*",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null; // Return null if the input is valid
                                },
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                controller: confirmPasswordController,
                                focusNode: _confirmPasswordFocusNode,
                                style: const TextStyle(fontSize: 16.0),
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
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
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        width: 3, color: Color(0xFF02AA03)),
                                  ),
                                  prefixIcon: IconButton(
                                    icon: const Icon(Icons.lock,
                                        color: Colors.grey),
                                    onPressed: () {},
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible2
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible2 =
                                            !_isPasswordVisible2;
                                      });
                                    },
                                  ),
                                ),
                                cursorColor: const Color(0xFF02AA03),
                                obscureText: !_isPasswordVisible2,
                                obscuringCharacter: "*",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Confirm Password is required';
                                  } else if (value != passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null; // Return null if the input is valid
                                },
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
                                style: const TextStyle(fontSize: 16.0),
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
                                    icon: const Icon(Icons.map,
                                        color: Colors.grey),
                                    onPressed: () {},
                                  ),
                                ),
                                cursorColor: const Color(0xFF02AA03),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Country is required';
                                  }
                                  return null; // Return null if the input is valid
                                },
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                controller: stateController,
                                focusNode: _stateFocusNode,
                                style: const TextStyle(fontSize: 16.0),
                                decoration: InputDecoration(
                                  labelText: 'State',
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
                                    icon: const Icon(Icons.map,
                                        color: Colors.grey),
                                    onPressed: () {},
                                  ),
                                ),
                                cursorColor: const Color(0xFF02AA03),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'State is required';
                                  }
                                  return null; // Return null if the input is valid
                                },
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                controller: referralController,
                                focusNode: _referralFocusNode,
                                style: const TextStyle(fontSize: 16.0),
                                decoration: InputDecoration(
                                  labelText: 'Referral',
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
                                    icon: const Icon(Icons.person_add,
                                        color: Colors.grey),
                                    onPressed: () {},
                                  ),
                                ),
                                cursorColor: const Color(0xFF02AA03),
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return 'Referral is required';
                                //   }
                                //   return null; // Return null if the input is valid
                                // },
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
                                  if (_formKey.currentState!.validate()) {
                                    _registerUser(setState, (errorMessage) {
                                      setState(() {
                                        serverErrorMessage =
                                            errorMessage; // Update server error message
                                      });
                                    });
                                  }
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
                            if (serverErrorMessage
                                .isNotEmpty) // Display server error message
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                  serverErrorMessage,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
                                    MediaQuery.of(context).viewInsets.bottom),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  Positioned.fill(
                    child: AbsorbPointer(
                      absorbing: true, // Blocks interaction with widgets behind
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
          );
        });
      },
    );
  }

  @override
  void dispose() {
    countryController.dispose();
    passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasShownBottomSheet) {
      _hasShownBottomSheet = true; // Set the flag to true
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomBottomSheet(
            context); // Show the bottom sheet after the first frame
      });
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                                'Back',
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
                        Image.asset(
                          "images/AppLogo.png",
                          fit: BoxFit.contain,
                          width: 120,
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(vertical: 12.0),
                  //     decoration: const BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(25.0),
                  //         topRight: Radius.circular(25.0),
                  //       ),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black26,
                  //           spreadRadius: 2,
                  //           blurRadius: 10,
                  //         ),
                  //       ],
                  //     ),
                  //     child: SizedBox(
                  //       width: MediaQuery.of(context).size.width,
                  //       child: SingleChildScrollView(
                  //         // Add this line
                  //         child: Padding(
                  //           padding:
                  //               const EdgeInsets.symmetric(horizontal: 20.0),
                  //           child: Column(children: [
                  //             SizedBox(
                  //                 height: MediaQuery.of(context).size.height *
                  //                     0.03),
                  //             const Text(
                  //               'Register',
                  //               style: TextStyle(
                  //                 fontSize: 24,
                  //                 fontFamily: 'Inter',
                  //                 fontWeight: FontWeight.bold,
                  //                 color: Colors.black,
                  //               ),
                  //             ),
                  //             SizedBox(
                  //                 height: MediaQuery.of(context).size.height *
                  //                     0.04),
                  //             // Padding(
                  //             //   padding:
                  //             //       const EdgeInsets.symmetric(horizontal: 20.0),
                  //             //   child: TextFormField(
                  //             //     controller: stateController,
                  //             //     focusNode: _stateFocusNode,
                  //             //     style: const TextStyle(
                  //             //       fontSize: 16.0,
                  //             //     ),
                  //             //     decoration: InputDecoration(
                  //             //         labelText: 'State',
                  //             //         labelStyle: const TextStyle(
                  //             //           color: Colors.grey,
                  //             //           fontFamily: 'Inter',
                  //             //           fontSize: 12.0,
                  //             //           decoration: TextDecoration.none,
                  //             //         ),
                  //             //         floatingLabelBehavior:
                  //             //             FloatingLabelBehavior.never,
                  //             //         border: OutlineInputBorder(
                  //             //           borderRadius: BorderRadius.circular(15),
                  //             //           borderSide: const BorderSide(
                  //             //               width: 3, color: Colors.grey),
                  //             //         ),
                  //             //         focusedBorder: OutlineInputBorder(
                  //             //           borderRadius: BorderRadius.circular(15),
                  //             //           borderSide: const BorderSide(
                  //             //               width: 3, color: Color(0xFF02AA03)),
                  //             //         ),
                  //             //         prefixIcon: IconButton(
                  //             //           icon: const Icon(
                  //             //             Icons.map,
                  //             //             color: Colors.grey,
                  //             //           ),
                  //             //           onPressed: () {},
                  //             //         )),
                  //             //     cursorColor: const Color(0xFF02AA03),
                  //             //   ),
                  //             // ),
                  //             // SizedBox(
                  //             //     height:
                  //             //         MediaQuery.of(context).size.height * 0.02),
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 20.0),
                  //               child: TextFormField(
                  //                 controller: passwordController,
                  //                 focusNode: _passwordFocusNode,
                  //                 style: const TextStyle(
                  //                   fontSize: 16.0,
                  //                 ),
                  //                 decoration: InputDecoration(
                  //                     labelText: 'Password',
                  //                     labelStyle: const TextStyle(
                  //                       color: Colors.grey,
                  //                       fontFamily: 'Inter',
                  //                       fontSize: 12.0,
                  //                       decoration: TextDecoration.none,
                  //                     ),
                  //                     floatingLabelBehavior:
                  //                         FloatingLabelBehavior.never,
                  //                     border: OutlineInputBorder(
                  //                       borderRadius: BorderRadius.circular(15),
                  //                     ),
                  //                     focusedBorder: OutlineInputBorder(
                  //                       borderRadius: BorderRadius.circular(15),
                  //                       borderSide: const BorderSide(
                  //                           width: 3, color: Color(0xFF02AA03)),
                  //                     ),
                  //                     prefixIcon: IconButton(
                  //                       icon: const Icon(
                  //                         Icons.lock,
                  //                         color: Colors.grey,
                  //                       ),
                  //                       onPressed: () {},
                  //                     ),
                  //                     suffixIcon: IconButton(
                  //                       icon: Icon(
                  //                           _isPasswordVisible
                  //                               ? Icons.visibility
                  //                               : Icons.visibility_off,
                  //                           color: Colors.grey),
                  //                       onPressed: () {
                  //                         setState(() {
                  //                           _isPasswordVisible =
                  //                               !_isPasswordVisible;
                  //                         });
                  //                       },
                  //                     )),
                  //                 cursorColor: const Color(0xFF02AA03),
                  //                 obscureText: !_isPasswordVisible,
                  //                 obscuringCharacter: "*",
                  //               ),
                  //             ),
                  //             SizedBox(
                  //                 height: MediaQuery.of(context).size.height *
                  //                     0.02),
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 20.0),
                  //               child: TextFormField(
                  //                 controller: confirmPasswordController,
                  //                 focusNode: _confirmPasswordFocusNode,
                  //                 style: const TextStyle(
                  //                   fontSize: 16.0,
                  //                 ),
                  //                 decoration: InputDecoration(
                  //                     labelText: 'Confirm Password',
                  //                     labelStyle: const TextStyle(
                  //                       color: Colors.grey,
                  //                       fontFamily: 'Inter',
                  //                       fontSize: 12.0,
                  //                       decoration: TextDecoration.none,
                  //                     ),
                  //                     floatingLabelBehavior:
                  //                         FloatingLabelBehavior.never,
                  //                     border: OutlineInputBorder(
                  //                       borderRadius: BorderRadius.circular(15),
                  //                     ),
                  //                     focusedBorder: OutlineInputBorder(
                  //                       borderRadius: BorderRadius.circular(15),
                  //                       borderSide: const BorderSide(
                  //                           width: 3, color: Color(0xFF02AA03)),
                  //                     ),
                  //                     prefixIcon: IconButton(
                  //                       icon: const Icon(
                  //                         Icons.lock,
                  //                         color: Colors.grey,
                  //                       ),
                  //                       onPressed: () {},
                  //                     ),
                  //                     suffixIcon: IconButton(
                  //                       icon: Icon(
                  //                           _isPasswordVisible2
                  //                               ? Icons.visibility
                  //                               : Icons.visibility_off,
                  //                           color: Colors.grey),
                  //                       onPressed: () {
                  //                         setState(() {
                  //                           _isPasswordVisible2 =
                  //                               !_isPasswordVisible2;
                  //                         });
                  //                       },
                  //                     )),
                  //                 cursorColor: const Color(0xFF02AA03),
                  //                 obscureText: !_isPasswordVisible2,
                  //                 obscuringCharacter: "*",
                  //               ),
                  //             ),
                  //             SizedBox(
                  //                 height: MediaQuery.of(context).size.height *
                  //                     0.02),
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 20.0),
                  //               child: AbsorbPointer(
                  //                 child: TextFormField(
                  //                   controller: countryController,
                  //                   focusNode: _countryFocusNode,
                  //                   style: const TextStyle(
                  //                     fontSize: 16.0,
                  //                   ),
                  //                   decoration: InputDecoration(
                  //                       labelText: 'Country',
                  //                       labelStyle: const TextStyle(
                  //                         color: Colors.grey,
                  //                         fontFamily: 'Inter',
                  //                         fontSize: 12.0,
                  //                         decoration: TextDecoration.none,
                  //                       ),
                  //                       floatingLabelBehavior:
                  //                           FloatingLabelBehavior.never,
                  //                       border: OutlineInputBorder(
                  //                         borderRadius:
                  //                             BorderRadius.circular(15),
                  //                         borderSide: const BorderSide(
                  //                             width: 3, color: Colors.grey),
                  //                       ),
                  //                       focusedBorder: OutlineInputBorder(
                  //                         borderRadius:
                  //                             BorderRadius.circular(15),
                  //                         borderSide: const BorderSide(
                  //                             width: 3,
                  //                             color: Color(0xFF02AA03)),
                  //                       ),
                  //                       prefixIcon: IconButton(
                  //                         icon: const Icon(
                  //                           Icons.map,
                  //                           color: Colors.grey,
                  //                         ),
                  //                         onPressed: () {},
                  //                       )),
                  //                   cursorColor: const Color(0xFF02AA03),
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(
                  //                 height: MediaQuery.of(context).size.height *
                  //                     0.02),
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 20.0),
                  //               child: AbsorbPointer(
                  //                 child: TextFormField(
                  //                   controller: stateController,
                  //                   focusNode: _stateFocusNode,
                  //                   style: const TextStyle(
                  //                     fontSize: 16.0,
                  //                   ),
                  //                   decoration: InputDecoration(
                  //                       labelText: 'State',
                  //                       labelStyle: const TextStyle(
                  //                         color: Colors.grey,
                  //                         fontFamily: 'Inter',
                  //                         fontSize: 12.0,
                  //                         decoration: TextDecoration.none,
                  //                       ),
                  //                       floatingLabelBehavior:
                  //                           FloatingLabelBehavior.never,
                  //                       border: OutlineInputBorder(
                  //                         borderRadius:
                  //                             BorderRadius.circular(15),
                  //                         borderSide: const BorderSide(
                  //                             width: 3, color: Colors.grey),
                  //                       ),
                  //                       focusedBorder: OutlineInputBorder(
                  //                         borderRadius:
                  //                             BorderRadius.circular(15),
                  //                         borderSide: const BorderSide(
                  //                             width: 3,
                  //                             color: Color(0xFF02AA03)),
                  //                       ),
                  //                       prefixIcon: IconButton(
                  //                         icon: const Icon(
                  //                           Icons.map,
                  //                           color: Colors.grey,
                  //                         ),
                  //                         onPressed: () {},
                  //                       )),
                  //                   cursorColor: const Color(0xFF02AA03),
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(
                  //                 height: MediaQuery.of(context).size.height *
                  //                     0.02),
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 20.0),
                  //               child: TextFormField(
                  //                 controller: referralController,
                  //                 focusNode: _referralFocusNode,
                  //                 style: const TextStyle(
                  //                   fontSize: 16.0,
                  //                 ),
                  //                 decoration: InputDecoration(
                  //                     labelText: 'Referral',
                  //                     labelStyle: const TextStyle(
                  //                       color: Colors.grey,
                  //                       fontFamily: 'Inter',
                  //                       fontSize: 12.0,
                  //                       decoration: TextDecoration.none,
                  //                     ),
                  //                     floatingLabelBehavior:
                  //                         FloatingLabelBehavior.never,
                  //                     border: OutlineInputBorder(
                  //                       borderRadius: BorderRadius.circular(15),
                  //                       borderSide: const BorderSide(
                  //                           width: 3, color: Colors.grey),
                  //                     ),
                  //                     focusedBorder: OutlineInputBorder(
                  //                       borderRadius: BorderRadius.circular(15),
                  //                       borderSide: const BorderSide(
                  //                           width: 3, color: Color(0xFF02AA03)),
                  //                     ),
                  //                     prefixIcon: IconButton(
                  //                       icon: const Icon(
                  //                         Icons.person_add,
                  //                         color: Colors.grey,
                  //                       ),
                  //                       onPressed: () {},
                  //                     )),
                  //                 cursorColor: const Color(0xFF02AA03),
                  //               ),
                  //             ),
                  //             SizedBox(
                  //                 height: MediaQuery.of(context).size.height *
                  //                     0.05),
                  //             Container(
                  //               width: double.infinity,
                  //               height:
                  //                   (60 / MediaQuery.of(context).size.height) *
                  //                       MediaQuery.of(context).size.height,
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 20.0),
                  //               child: ElevatedButton(
                  //                 onPressed: () {
                  //                   _registerUser();
                  //                 },
                  //                 style: ButtonStyle(
                  //                   backgroundColor:
                  //                       WidgetStateProperty.resolveWith<Color>(
                  //                     (Set<WidgetState> states) {
                  //                       if (states
                  //                           .contains(WidgetState.pressed)) {
                  //                         return Colors.white;
                  //                       }
                  //                       return const Color(0xFF02AA03);
                  //                     },
                  //                   ),
                  //                   foregroundColor:
                  //                       WidgetStateProperty.resolveWith<Color>(
                  //                     (Set<WidgetState> states) {
                  //                       if (states
                  //                           .contains(WidgetState.pressed)) {
                  //                         return const Color(0xFF02AA03);
                  //                       }
                  //                       return Colors.white;
                  //                     },
                  //                   ),
                  //                   elevation:
                  //                       WidgetStateProperty.all<double>(4.0),
                  //                   shape: WidgetStateProperty.all<
                  //                       RoundedRectangleBorder>(
                  //                     const RoundedRectangleBorder(
                  //                       side: BorderSide(
                  //                           width: 3, color: Color(0xFF02AA03)),
                  //                       borderRadius: BorderRadius.all(
                  //                           Radius.circular(15)),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 child: const Text(
                  //                   'Register',
                  //                   style: TextStyle(
                  //                     fontFamily: 'Inter',
                  //                     fontWeight: FontWeight.bold,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(
                  //                 height: MediaQuery.of(context).size.height *
                  //                     0.03),
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 20.0),
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   const Text(
                  //                     "Already have an account?",
                  //                     style: TextStyle(
                  //                       fontFamily: 'Inter',
                  //                       fontSize: 13.0,
                  //                       fontWeight: FontWeight.bold,
                  //                       color: Colors.black,
                  //                     ),
                  //                   ),
                  //                   SizedBox(
                  //                       width:
                  //                           MediaQuery.of(context).size.width *
                  //                               0.01),
                  //                   InkWell(
                  //                     onTap: () {
                  //                       Navigator.push(
                  //                         context,
                  //                         MaterialPageRoute(
                  //                           builder: (context) =>
                  //                               LoginPage(key: UniqueKey()),
                  //                         ),
                  //                       );
                  //                     },
                  //                     child: const Text(
                  //                       'Login',
                  //                       textAlign: TextAlign.start,
                  //                       style: TextStyle(
                  //                         decoration: TextDecoration.none,
                  //                         decorationColor: Color(0xFF02AA03),
                  //                         fontFamily: 'Inter',
                  //                         fontWeight: FontWeight.w600,
                  //                         fontSize: 13.0,
                  //                         color: Color(0xFF02AA03),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ]),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
}
