import 'package:bills_plug/register_page_second.dart';
import 'package:flutter/material.dart';
import 'Login_Page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_app.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final storage = const FlutterSecureStorage();
  late SharedPreferences prefs;
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  final ScrollController _scrollController = ScrollController();
  bool _hasShownBottomSheet = false;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _firstNameFocusNode.addListener(() {
      if (_firstNameFocusNode.hasFocus) {
        _scrollToField(_firstNameFocusNode);
      }
    });
    _lastNameFocusNode.addListener(() {
      if (_lastNameFocusNode.hasFocus) {
        _scrollToField(_lastNameFocusNode);
      }
    });
    _userNameFocusNode.addListener(() {
      if (_userNameFocusNode.hasFocus) {
        _scrollToField(_userNameFocusNode);
      }
    });
    _phoneNumberFocusNode.addListener(() {
      if (_phoneNumberFocusNode.hasFocus) {
        _scrollToField(_phoneNumberFocusNode);
      }
    });
    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        _scrollToField(_emailFocusNode);
      }
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.25, end: 0.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _scrollToField(FocusNode focusNode) {
    // Scroll to the focused field
    Scrollable.ensureVisible(
      focusNode.context!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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

    _scaffoldKey.currentState?.showSnackBar(snackBar);
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void showCustomBottomSheet(BuildContext context) {
    final GlobalKey<FormState> _formKey =
        GlobalKey<FormState>(); // Create a GlobalKey for the form

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
                                controller: firstNameController,
                                focusNode: _firstNameFocusNode,
                                style: const TextStyle(fontSize: 16.0),
                                decoration: InputDecoration(
                                    labelText: 'First Name',
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
                                      onPressed: null,
                                    )),
                                cursorColor: const Color(0xFF02AA03),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'First Name is required';
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
                                controller: lastNameController,
                                focusNode: _lastNameFocusNode,
                                style: const TextStyle(fontSize: 16.0),
                                decoration: InputDecoration(
                                    labelText: 'Last Name',
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
                                      onPressed: null,
                                    )),
                                cursorColor: const Color(0xFF02AA03),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Last Name is required';
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
                                controller: userNameController,
                                focusNode: _userNameFocusNode,
                                style: const TextStyle(fontSize: 16.0),
                                decoration: InputDecoration(
                                    labelText: 'Username',
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
                                      onPressed: null,
                                    )),
                                cursorColor: const Color(0xFF02AA03),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Username is required';
                                  } else if (value.length < 6) {
                                    return 'Username must be at least 6 characters';
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
                                controller: phoneNumberController,
                                focusNode: _phoneNumberFocusNode,
                                style: const TextStyle(fontSize: 16.0),
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
                                      onPressed: null,
                                    )),
                                cursorColor: const Color(0xFF02AA03),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Phone Number is required';
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
                                controller: emailController,
                                focusNode: _emailFocusNode,
                                style: const TextStyle(fontSize: 16.0),
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
                                      onPressed: null,
                                    )),
                                cursorColor: const Color(0xFF02AA03),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  final RegExp emailRegex =
                                      RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null; // Return null if the input is valid
                                },
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
                                    // If the form is valid, proceed with the next steps
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterPageSecond(
                                          key: UniqueKey(),
                                          username:
                                              userNameController.text.trim(),
                                          phoneNumber:
                                              phoneNumberController.text.trim(),
                                          email: emailController.text.trim(),
                                          firstname:
                                              firstNameController.text.trim(),
                                          lastname:
                                              lastNameController.text.trim(),
                                        ),
                                      ),
                                    );
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
                                  'Next',
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

  void _showContacts() async {
    // Request permission to access contacts
    var status = await Permission.contacts.request();
    if (status.isGranted) {
      // Show loading indicator while fetching contacts
      showDialog(
        context: context,
        barrierDismissible:
            false, // Prevent dismissing the dialog while loading
        builder: (context) {
          return const AlertDialog(
            title: Text('Loading Contacts...'),
            content: SizedBox(
              height: 100,
              child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF02AA03))),
            ),
          );
        },
      );

      // Fetch contacts
      Iterable<Contact> contacts = await ContactsService.getContacts();
      Navigator.of(context).pop(); // Close the loading dialog

      // Create a stateful widget to manage the search functionality
      showDialog(
        context: context,
        builder: (context) {
          String searchQuery = '';
          return StatefulBuilder(
            builder: (context, setState) {
              // Filter contacts based on the search query
              List<Contact> filteredContacts = contacts
                  .where((contact) =>
                      contact.displayName
                          ?.toLowerCase()
                          .contains(searchQuery.toLowerCase()) ??
                      false)
                  .toList();

              return AlertDialog(
                title: const Text('Select a Contact'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Search',
                          hintText: 'Type to search...',
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredContacts.length,
                          itemBuilder: (context, index) {
                            Contact contact = filteredContacts[index];
                            return ListTile(
                              title: Text(contact.displayName ?? ''),
                              subtitle: Text(contact.phones!.isNotEmpty
                                  ? contact.phones!.first.value ?? ''
                                  : 'No phone number'),
                              onTap: () {
                                // Populate the TextFormField with the selected contact's phone number
                                if (contact.phones!.isNotEmpty) {
                                  String phoneNumber =
                                      contact.phones!.first.value!;

                                  // Replace the country code "+234" with "0"
                                  if (phoneNumber.startsWith('+234')) {
                                    phoneNumber =
                                        '0${phoneNumber.substring(4)}'; // Remove "+234" and prepend "0"
                                  }

                                  phoneNumberController.text = phoneNumber;
                                }
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      // Handle the case when permission is denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission to access contacts denied')),
      );
    }
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
        return ScaffoldMessenger(
          key: _scaffoldKey, // Assign the GlobalKey to the ScaffoldMessenger
          child: Scaffold(
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
                              height:
                                  MediaQuery.of(context).size.height * 0.015),
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
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       // Dismiss the keyboard when tapping outside of the text fields
                    //       FocusScope.of(context).unfocus();
                    //     },
                    //     child: Container(
                    //       padding: const EdgeInsets.symmetric(vertical: 12.0),
                    //       decoration: const BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.only(
                    //           topLeft: Radius.circular(25.0),
                    //           topRight: Radius.circular(25.0),
                    //         ),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.black26,
                    //             spreadRadius: 2,
                    //             blurRadius: 10,
                    //           ),
                    //         ],
                    //       ),
                    //       child: SizedBox(
                    //         width: MediaQuery.of(context).size.width,
                    //         child: SingleChildScrollView(
                    //           controller: _scrollController,
                    //           child: Padding(
                    //             padding:
                    //                 const EdgeInsets.symmetric(horizontal: 20.0),
                    //             child: Column(children: [
                    //               SizedBox(
                    //                   height: MediaQuery.of(context).size.height *
                    //                       0.03),
                    //               const Text(
                    //                 'Register',
                    //                 style: TextStyle(
                    //                   fontSize: 24,
                    //                   fontFamily: 'Inter',
                    //                   fontWeight: FontWeight.bold,
                    //                   color: Colors.black,
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                   height: MediaQuery.of(context).size.height *
                    //                       0.04),
                    //               Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 20.0),
                    //                 child: TextFormField(
                    //                   controller: firstNameController,
                    //                   focusNode: _firstNameFocusNode,
                    //                   style: const TextStyle(
                    //                     fontSize: 16.0,
                    //                   ),
                    //                   decoration: InputDecoration(
                    //                       labelText: 'First Name',
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
                    //                           Icons.person,
                    //                           color: Colors.grey,
                    //                         ),
                    //                         onPressed: null,
                    //                       )),
                    //                   cursorColor: const Color(0xFF02AA03),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                   height: MediaQuery.of(context).size.height *
                    //                       0.02),
                    //               Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 20.0),
                    //                 child: TextFormField(
                    //                   controller: lastNameController,
                    //                   focusNode: _lastNameFocusNode,
                    //                   style: const TextStyle(
                    //                     fontSize: 16.0,
                    //                   ),
                    //                   decoration: InputDecoration(
                    //                       labelText: 'Last Name',
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
                    //                           Icons.person,
                    //                           color: Colors.grey,
                    //                         ),
                    //                         onPressed: null,
                    //                       )),
                    //                   cursorColor: const Color(0xFF02AA03),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                   height: MediaQuery.of(context).size.height *
                    //                       0.02),
                    //               Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 20.0),
                    //                 child: TextFormField(
                    //                   controller: userNameController,
                    //                   focusNode: _userNameFocusNode,
                    //                   style: const TextStyle(
                    //                     fontSize: 16.0,
                    //                   ),
                    //                   decoration: InputDecoration(
                    //                       labelText: 'Username',
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
                    //                           Icons.person,
                    //                           color: Colors.grey,
                    //                         ),
                    //                         onPressed: null,
                    //                       )),
                    //                   cursorColor: const Color(0xFF02AA03),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                   height: MediaQuery.of(context).size.height *
                    //                       0.02),
                    //               Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 20.0),
                    //                 child: TextFormField(
                    //                   controller: phoneNumberController,
                    //                   focusNode: _phoneNumberFocusNode,
                    //                   style: const TextStyle(
                    //                     fontSize: 16.0,
                    //                   ),
                    //                   decoration: InputDecoration(
                    //                       labelText: 'Phone Number',
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
                    //                           Icons.phone,
                    //                           color: Colors.grey,
                    //                         ),
                    //                         onPressed: null,
                    //                       )),
                    //                   cursorColor: const Color(0xFF02AA03),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                   height: MediaQuery.of(context).size.height *
                    //                       0.02),
                    //               Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 20.0),
                    //                 child: TextFormField(
                    //                   controller: emailController,
                    //                   focusNode: _emailFocusNode,
                    //                   style: const TextStyle(
                    //                     fontSize: 16.0,
                    //                   ),
                    //                   decoration: InputDecoration(
                    //                       labelText: 'Email',
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
                    //                           Icons.mail,
                    //                           color: Colors.grey,
                    //                         ),
                    //                         onPressed: null,
                    //                       )),
                    //                   cursorColor: const Color(0xFF02AA03),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                   height: MediaQuery.of(context).size.height *
                    //                       0.05),
                    //               Container(
                    //                 width: double.infinity,
                    //                 height: (60 /
                    //                         MediaQuery.of(context).size.height) *
                    //                     MediaQuery.of(context).size.height,
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 20.0),
                    //                 child: ElevatedButton(
                    //                   onPressed: () {
                    //                     if (firstNameController.text
                    //                             .trim()
                    //                             .isEmpty ||
                    //                         lastNameController.text
                    //                             .trim()
                    //                             .isEmpty ||
                    //                         userNameController.text
                    //                             .trim()
                    //                             .isEmpty ||
                    //                         emailController.text.trim().isEmpty ||
                    //                         phoneNumberController.text
                    //                             .trim()
                    //                             .isEmpty) {
                    //                       _showCustomSnackBar(
                    //                         context,
                    //                         'All fields are required.',
                    //                         isError: true,
                    //                       );
                    //                       return;
                    //                     }

                    //                     if (userNameController.text
                    //                             .trim()
                    //                             .length <
                    //                         6) {
                    //                       _showCustomSnackBar(
                    //                         context,
                    //                         'Username must be at least 6 characters.',
                    //                         isError: true,
                    //                       );
                    //                       return;
                    //                     }

                    //                     final RegExp emailRegex =
                    //                         RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    //                     if (!emailRegex.hasMatch(
                    //                         emailController.text.trim())) {
                    //                       _showCustomSnackBar(
                    //                         context,
                    //                         'Please enter a valid email address.',
                    //                         isError: true,
                    //                       );
                    //                       return;
                    //                     }
                    //                     Navigator.push(
                    //                       context,
                    //                       MaterialPageRoute(
                    //                         builder: (context) =>
                    //                             RegisterPageSecond(
                    //                           key: UniqueKey(),
                    //                           username:
                    //                               userNameController.text.trim(),
                    //                           phoneNumber: phoneNumberController
                    //                               .text
                    //                               .trim(),
                    //                           email: emailController.text.trim(),
                    //                           firstname:
                    //                               firstNameController.text.trim(),
                    //                           lastname:
                    //                               lastNameController.text.trim(),
                    //                         ),
                    //                       ),
                    //                     );
                    //                   },
                    //                   style: ButtonStyle(
                    //                     backgroundColor: WidgetStateProperty
                    //                         .resolveWith<Color>(
                    //                       (Set<WidgetState> states) {
                    //                         if (states
                    //                             .contains(WidgetState.pressed)) {
                    //                           return Colors.white;
                    //                         }
                    //                         return const Color(0xFF02AA03);
                    //                       },
                    //                     ),
                    //                     foregroundColor: WidgetStateProperty
                    //                         .resolveWith<Color>(
                    //                       (Set<WidgetState> states) {
                    //                         if (states
                    //                             .contains(WidgetState.pressed)) {
                    //                           return const Color(0xFF02AA03);
                    //                         }
                    //                         return Colors.white;
                    //                       },
                    //                     ),
                    //                     elevation:
                    //                         WidgetStateProperty.all<double>(4.0),
                    //                     shape: WidgetStateProperty.all<
                    //                         RoundedRectangleBorder>(
                    //                       const RoundedRectangleBorder(
                    //                         side: BorderSide(
                    //                             width: 3,
                    //                             color: Color(0xFF02AA03)),
                    //                         borderRadius: BorderRadius.all(
                    //                             Radius.circular(15)),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   child: const Text(
                    //                     'Next',
                    //                     style: TextStyle(
                    //                       fontFamily: 'Inter',
                    //                       fontWeight: FontWeight.bold,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                   height: MediaQuery.of(context).size.height *
                    //                       0.03),
                    //               Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 20.0),
                    //                 child: Row(
                    //                   mainAxisAlignment: MainAxisAlignment.center,
                    //                   children: [
                    //                     const Text(
                    //                       "Already have an account?",
                    //                       style: TextStyle(
                    //                         fontFamily: 'Inter',
                    //                         fontSize: 13.0,
                    //                         fontWeight: FontWeight.bold,
                    //                         color: Colors.black,
                    //                       ),
                    //                     ),
                    //                     SizedBox(
                    //                         width: MediaQuery.of(context)
                    //                                 .size
                    //                                 .width *
                    //                             0.01),
                    //                     InkWell(
                    //                       onTap: () {
                    //                         Navigator.push(
                    //                           context,
                    //                           MaterialPageRoute(
                    //                             builder: (context) =>
                    //                                 LoginPage(key: UniqueKey()),
                    //                           ),
                    //                         );
                    //                       },
                    //                       child: const Text(
                    //                         'Login',
                    //                         textAlign: TextAlign.start,
                    //                         style: TextStyle(
                    //                           decoration: TextDecoration.none,
                    //                           decorationColor: Color(0xFF02AA03),
                    //                           fontFamily: 'Inter',
                    //                           fontWeight: FontWeight.w600,
                    //                           fontSize: 13.0,
                    //                           color: Color(0xFF02AA03),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ]),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
