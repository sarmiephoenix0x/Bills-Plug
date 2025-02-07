import 'package:bills_plug/payment_successful_airtime.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AirtimePage extends StatefulWidget {
  const AirtimePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  AirtimePageState createState() => AirtimePageState();
}

class AirtimePageState extends State<AirtimePage>
    with SingleTickerProviderStateMixin {
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  List<String> imagePaths = [
    "images/MTNImg.png",
    "images/AirtelImg.png",
    "images/GloImg.png",
    "images/9MobileImg.png",
  ];

  List<String> networkImg = [
    "images/MTNImg.png",
    "images/AirtelImg.png",
    "images/GloImg.png",
    "images/9MobileImg.png",
  ];

  List<String> networkNumber = [
    "09099999999",
    "08088888888",
    "07077777777",
    "07066666666",
  ];

  List<String> mtnPrefixes = [
    "0703",
    "0704",
    "0706",
    "0803",
    "0806",
    "0810",
    "0813",
    "0814",
    "0816",
    "0903",
    "0906",
    "0913",
    "0916"
  ];

  List<String> airtelPrefixes = [
    "0701",
    "0708",
    "0802",
    "0808",
    "0812",
    "0815",
    "0817",
    "0901",
    "0902",
    "0907"
  ];

  List<String> gloPrefixes = [
    "0705",
    "0805",
    "0811",
    "0815",
    "0818",
    "0905",
    "0915"
  ];

  List<String> nineMobilePrefixes = [
    "0709",
    "0809",
    "0817",
    "0818",
    "0819",
    "0904",
    "09088",
    "0909"
  ];

  bool paymentSectionAirtimeOpen = false;
  String? userBalance;
  late SharedPreferences prefs;
  bool paymentSuccessful = false;
  int currentNetwork = 0;
  String currentAmount = "0.00";
  bool inputPin = false;
  String networkName = "MTN";
  final storage = const FlutterSecureStorage();
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  String pinCode = "";
  String phoneNumber = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isButtonEnabled = false;
  String networkErrorMessage = "";
  final LocalAuthentication auth = LocalAuthentication();
  String pin = '';
  String searchQuery = '';
  List<Contact> _cachedContacts = [];

  @override
  void initState() {
    super.initState();
    amountController.addListener(validateForm);
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
    userBalance = await getUserBalance();
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

  void handlePinInputComplete(String code) {
    setState(() {
      pinCode = code;
    });

    _submitAirtimePurchase(pinCode);
  }

  Future<void> _submitAirtimePurchase(String pin) async {
    setState(() {
      isLoading = true;
    });
    final accessToken = await storage.read(key: 'billsplug_accessToken');
    final url = Uri.parse("https://glad.payguru.com.ng/api/airtime/purchase");
    final requestBody = {
      "phone_number": phoneNumber,
      "network": networkName,
      "amount": amountController.text.trim(),
      "airtime_type": 'Prepaid',
      "da": 0,
      "pin": pin,
    };

    try {
      final response =
          await http.post(url, body: json.encode(requestBody), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        inputPin = false;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessfulAirtime(
              key: UniqueKey(),
              id: 0,
              network: networkName,
              type: "VTU",
              number: phoneNumberController.text.trim(),
              amount: amountController.text.trim(),
              timeStamp: "08 Oct, 2024 12:12PM",
            ),
          ),
        );
        print("Airtime purchase successful");
      } else if (response.statusCode == 400) {
        final errorMessage = json.decode(response.body)['error'];
        _showCustomSnackBar(
          context,
          errorMessage ?? "An error occurred",
          isError: true,
        );
      } else {
        final errors = json.decode(response.body)['errors'];
        print("Error: $errors");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showCustomSnackBar(
        context,
        'An error occurred. Please try again later.',
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

  void validateForm() {
    setState(() {
      isButtonEnabled = networkErrorMessage.isEmpty &&
          amountController.text.trim().isNotEmpty &&
          phoneNumber.length == 11; // Update button state based on validation
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> authenticateWithFingerprint() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        // Handle successful authentication
        print("Fingerprint authentication successful!");
      } else {
        // Handle failed authentication
        print("Fingerprint authentication failed.");
      }
    } catch (e) {
      print("Error during fingerprint authentication: $e");
    }
  }

  void _showPinInputBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false, // Prevents dismissing by tapping outside
      isScrollControlled: true, // Allows the bottom sheet to take full height
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return GestureDetector(
              onTap: () {
                // Dismiss the keyboard when tapping outside
                FocusScope.of(context).unfocus();
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Expands only as needed
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    const Text(
                      'Enter Payment PIN',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    PinInput(pin: pin, length: 4),
                    const SizedBox(height: 20),
                    // Custom Keyboard
                    CustomKeyboard(
                      onNumberPressed: (String number) {
                        setState(() {
                          if (pin.length < 4) {
                            pin += number;
                          }
                          if (pin.length == 4) {
                            handlePinInputComplete(pin);
                            Navigator.of(context)
                                .pop(); // Close the bottom sheet after input
                          }
                        });
                      },
                      onFingerprintPressed: () async {
                        await authenticateWithFingerprint();
                        Navigator.of(context)
                            .pop(); // Close the bottom sheet after fingerprint authentication
                      },
                      onBackspacePressed: () {
                        setState(() {
                          if (pin.isNotEmpty) {
                            pin = pin.substring(0, pin.length - 1);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
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

      // Fetch contacts if not already cached
      if (_cachedContacts.isEmpty) {
        Iterable<Contact> contacts = await ContactsService.getContacts();
        _cachedContacts = contacts.toList(); // Cache the contacts
      }
      Navigator.of(context).pop(); // Close the loading dialog

      // Create a stateful widget to manage the search functionality
      showDialog(
        context: context,
        builder: (context) {
          String searchQuery = '';
          return StatefulBuilder(
            builder: (context, setState) {
              // Filter contacts based on the search query
              List<Contact> filteredContacts = _cachedContacts
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

                                  phoneNumber = phoneNumber.replaceAll(' ', '');

                                  // Replace the country code "+234" with "0"
                                  if (phoneNumber.startsWith('+234')) {
                                    phoneNumber =
                                        '0${phoneNumber.substring(4)}'; // Remove "+234" and prepend "0"
                                  }

                                  phoneNumberController.text = phoneNumber;

                                  validatePhoneNumber(phoneNumber);
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

// New method to validate the phone number
  void validatePhoneNumber(String phoneNumber) {
    setState(() {
      // Ensure the phone number is 11 digits long
      if (phoneNumber.length > 11) {
        phoneNumber = phoneNumber.substring(phoneNumber.length - 11);
      }

      // Check for MTN
      if (mtnPrefixes.any((prefix) => phoneNumber.startsWith(prefix)) &&
          currentNetwork == 0) {
        networkErrorMessage = ""; // Valid MTN number
      } else {
        if (currentNetwork == 0) {
          networkErrorMessage = 'Please enter a valid MTN number.';
        }
      }

      // Check for Glo
      if (gloPrefixes.any((prefix) => phoneNumber.startsWith(prefix))) {
        if (currentNetwork == 2) {
          networkErrorMessage = ""; // Valid Glo number
        }
      } else {
        if (currentNetwork == 2) {
          networkErrorMessage = 'Please enter a valid Glo number.';
        }
      }

      // Check for Airtel
      if (airtelPrefixes.any((prefix) => phoneNumber.startsWith(prefix))) {
        if (currentNetwork == 1) {
          networkErrorMessage = ""; // Valid Airtel number
        }
      } else {
        if (currentNetwork == 1) {
          networkErrorMessage = 'Please enter a valid Airtel number.';
        }
      }

      // Check for 9Mobile
      if (nineMobilePrefixes.any((prefix) => phoneNumber.startsWith(prefix))) {
        if (currentNetwork == 3) {
          networkErrorMessage = ""; // Valid 9Mobile number
        }
      } else {
        if (currentNetwork == 3) {
          networkErrorMessage = 'Please enter a valid 9Mobile number.';
        }
      }
      isButtonEnabled = networkErrorMessage.isEmpty &&
          amountController.text.trim().isNotEmpty &&
          phoneNumber.length == 11;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentNetwork == 0) {
      networkName = "MTN";
    } else if (currentNetwork == 1) {
      networkName = "AIRTEL";
    } else if (currentNetwork == 2) {
      networkName = "GLO";
    } else if (currentNetwork == 3) {
      networkName = "9MOBILE";
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
                    height: MediaQuery.of(context).size.height,
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
                                        0.15),
                                const Text(
                                  'Airtime TopUp',
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
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: imagePaths.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              currentNetwork = index;
                                            });
                                          },
                                          child: Container(
                                            width: (80 /
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width) *
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7.0, horizontal: 7.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                              border: currentNetwork == index
                                                  ? Border.all(
                                                      width: 2,
                                                      color: const Color(
                                                          0xFF02AA03))
                                                  : Border.all(
                                                      width: 0,
                                                      color:
                                                          Colors.transparent),
                                            ),
                                            child: Image.asset(
                                              imagePaths[index],
                                              height: 30,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ))),
                          // SizedBox(
                          //     height:
                          //         MediaQuery.of(context).size.height * 0.04),
                          // const Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 20.0),
                          //   child: Text(
                          //     'Recent Number',
                          //     style: TextStyle(
                          //       fontFamily: 'Inter',
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: 18.0,
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //     height:
                          //         MediaQuery.of(context).size.height * 0.04),
                          // SizedBox(
                          //   height: (50 / MediaQuery.of(context).size.height) *
                          //       MediaQuery.of(context).size.height,
                          //   child: ListView.builder(
                          //     scrollDirection: Axis.horizontal,
                          //     itemCount: networkImg.length,
                          //     itemBuilder: (context, index) {
                          //       return number(index, networkImg[index],
                          //           networkNumber[index]);
                          //     },
                          //   ),
                          // ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.04),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: TextFormField(
                                    controller: phoneNumberController,
                                    focusNode: _phoneNumberFocusNode,
                                    decoration: InputDecoration(
                                      labelText: 'Mobile Number',
                                      labelStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Inter',
                                        fontSize: 16.0,
                                        decoration: TextDecoration.none,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                          width: 3,
                                          color: Color(0xFF02AA03),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                          width: 2,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: IconButton(
                                        icon: const Icon(
                                          Icons.contact_phone,
                                          color: Colors.grey,
                                        ),
                                        onPressed: _showContacts,
                                      ),
                                      counterText: '',
                                    ),
                                    maxLength:
                                        11, // Limit to 11 digits for Nigeria
                                    keyboardType: TextInputType.phone,
                                    onChanged: (value) {
                                      setState(() {
                                        phoneNumber = value;

                                        // Ensure the phone number is 11 digits long
                                        if (phoneNumber.length > 11) {
                                          phoneNumber = phoneNumber.substring(
                                              phoneNumber.length - 11);
                                        }

                                        // Check for MTN
                                        if (mtnPrefixes.any((prefix) =>
                                                phoneNumber
                                                    .startsWith(prefix)) &&
                                            currentNetwork == 0) {
                                          networkErrorMessage =
                                              ""; // Valid MTN number
                                        } else {
                                          if (currentNetwork == 0) {
                                            networkErrorMessage =
                                                'Please enter a valid MTN number.';
                                          }
                                        }

                                        // Check for Glo
                                        if (gloPrefixes.any((prefix) =>
                                            phoneNumber.startsWith(prefix))) {
                                          if (currentNetwork == 2) {
                                            networkErrorMessage =
                                                ""; // Valid Glo number
                                          }
                                        } else {
                                          if (currentNetwork == 2) {
                                            networkErrorMessage =
                                                'Please enter a valid Glo number.';
                                          }
                                        }

                                        // Check for Airtel
                                        if (airtelPrefixes.any((prefix) =>
                                            phoneNumber.startsWith(prefix))) {
                                          if (currentNetwork == 1) {
                                            networkErrorMessage =
                                                ""; // Valid Airtel number
                                          }
                                        } else {
                                          if (currentNetwork == 1) {
                                            networkErrorMessage =
                                                'Please enter a valid Airtel number.';
                                          }
                                        }

                                        // Check for 9Mobile
                                        if (nineMobilePrefixes.any((prefix) =>
                                            phoneNumber.startsWith(prefix))) {
                                          if (currentNetwork == 3) {
                                            networkErrorMessage =
                                                ""; // Valid 9Mobile number
                                          }
                                        } else {
                                          if (currentNetwork == 3) {
                                            networkErrorMessage =
                                                'Please enter a valid 9Mobile number.';
                                          }
                                        }
                                      });
                                      validateForm();
                                    },
                                    validator: (value) {
                                      // Validate the phone number length for Nigeria
                                      if (value == null || value.length != 11) {
                                        return 'Please enter a valid 11-digit mobile number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                if (networkErrorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 20.0),
                                    child: Text(
                                      networkErrorMessage,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 14.0),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.04),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              controller: amountController,
                              focusNode: _amountFocusNode,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Input Amount',
                                labelStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
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
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.grey),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              cursorColor: const Color(0xFF02AA03),
                              keyboardType: TextInputType
                                  .number, // This allows only numeric input
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter
                                    .digitsOnly, // This will filter out non-numeric input
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an amount';
                                }
                                return null; // Return null if the input is valid
                              },
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.04),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Container(
                            width: double.infinity,
                            height: (60 / MediaQuery.of(context).size.height) *
                                MediaQuery.of(context).size.height,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: ElevatedButton(
                              onPressed:
                                  isButtonEnabled // Enable or disable the button
                                      ? () {
                                          setState(() {
                                            paymentSectionAirtimeOpen =
                                                true; // Proceed if valid
                                          });
                                        }
                                      : null, // Disable button if conditions are not met
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors
                                          .white; // Change color when pressed
                                    }
                                    return isButtonEnabled // Check if button should be enabled
                                        ? const Color(
                                            0xFF02AA03) // Active color
                                        : Colors.grey; // Inactive color
                                  },
                                ),
                                foregroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    return isButtonEnabled // Check if button should be enabled
                                        ? (states.contains(WidgetState.pressed)
                                            ? const Color(
                                                0xFF02AA03) // Change text color when pressed
                                            : Colors
                                                .white) // Default text color
                                        : Colors
                                            .white; // Text color when inactive
                                  },
                                ),
                                elevation: WidgetStateProperty.all<double>(4.0),
                                shape: WidgetStateProperty.resolveWith<
                                    RoundedRectangleBorder>(
                                  (Set<WidgetState> states) {
                                    return RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 3,
                                        color: isButtonEnabled
                                            ? const Color(0xFF02AA03)
                                            : Colors.grey,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                    );
                                  },
                                ),
                              ),
                              child: const Text(
                                'Purchase',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      // Overlay to close the payment section when tapped
                      if (paymentSectionAirtimeOpen)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              paymentSectionAirtimeOpen = false;
                            });
                          },
                          child: Container(
                            // Make the overlay fill the screen and slightly transparent
                            color: Colors.black.withOpacity(0.4),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          ),
                        ),
                      if (paymentSectionAirtimeOpen == true)
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(children: [
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
                                            setState(() {
                                              paymentSectionAirtimeOpen = false;
                                            });
                                          },
                                          child: Image.asset(
                                            'images/CloseBut.png',
                                            height: 25,
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'images/NairaImg.png',
                                        height: 15,
                                      ),
                                      Text(
                                        NumberFormat('#,###.##').format(
                                            double.parse(amountController.text
                                                    .trim()
                                                    .replaceAll(',', '')) -
                                                10),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'images/NairaImg.png',
                                        height: 15,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        NumberFormat('#,###.##').format(
                                            double.parse(amountController.text
                                                .trim()
                                                .replaceAll(',', ''))),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Expanded(
                                        flex: 5,
                                        child: Text(
                                          'Network',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Inter',
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      if (currentNetwork == 0)
                                        network("images/MTNImg.png", "MTN"),
                                      if (currentNetwork == 1)
                                        network(
                                            "images/AirtelImg.png", "AIRTEL"),
                                      if (currentNetwork == 2)
                                        network("images/GloImg.png", "GLO"),
                                      if (currentNetwork == 3)
                                        network(
                                            "images/9MobileImg.png", "9MOBILE"),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Expanded(
                                        flex: 5,
                                        child: Text(
                                          'Phone Number',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Inter',
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          phoneNumberController.text.trim(),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Inter',
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Expanded(
                                        flex: 5,
                                        child: Text(
                                          'Amount to pay',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Inter',
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Expanded(
                                        flex: 5,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Image.asset(
                                              'images/NairaImg.png',
                                              height: 15,
                                            ),
                                            Text(
                                              amountController.text.trim(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Inter',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Expanded(
                                        flex: 5,
                                        child: Text(
                                          'Discount',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Inter',
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Expanded(
                                        flex: 5,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Image.asset(
                                              'images/NairaImg.png',
                                              height: 15,
                                            ),
                                            const Text(
                                              '-10.00',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Inter',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "images/icons/AppIcon.png",
                                        fit: BoxFit.contain,
                                        width: 40,
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
                                            const Text(
                                              "Balance",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'images/NairaImg.png',
                                                  height: 15,
                                                ),
                                                if (userBalance != null)
                                                  Text(
                                                    double.tryParse(
                                                                userBalance!) !=
                                                            null
                                                        ? "(${double.parse(userBalance!).toStringAsFixed(2)})"
                                                        : "(0.00)",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 16.0,
                                                    ),
                                                  )
                                                else
                                                  const Text(
                                                    "(0.00)",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 16.0,
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
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
                                        setState(() {
                                          paymentSectionAirtimeOpen = false;
                                          // inputPin = true;
                                          _showPinInputBottomSheet(context);
                                        });
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
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                ]),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (paymentSuccessful)
                    Stack(
                      children: [
                        ModalBarrier(
                          dismissible: false,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        PopScope(
                          canPop: false,
                          onPopInvokedWithResult: (didPop, dynamic result) {
                            if (!didPop) {
                              setState(() {
                                paymentSuccessful = false;
                              });
                            }
                          },
                          child: Center(
                            child: SingleChildScrollView(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0), // Centered padding
                                padding: const EdgeInsets.all(
                                    16.0), // Inner padding for content
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Expands only as needed
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Close button
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            paymentSuccessful = false;
                                          });
                                        },
                                        child: Image.asset(
                                          'images/CloseBut.png',
                                          height: 25,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),

                                    // Receipt title and content
                                    const Text(
                                      'Payment Successful',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'images/NairaImg.png',
                                          height: 20,
                                        ),
                                        Text(
                                          NumberFormat('#,###.##').format(
                                              double.parse(amountController.text
                                                      .trim()
                                                      .replaceAll(',', '')) -
                                                  10),
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    const Text(
                                      'The recipient phone number will receive it within 1 minute',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                        color: Color(0xFF02AA03),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 12.0),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFDAF3DB),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15.0),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                'images/ShareReceipt.png',
                                                height: 20,
                                              ),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02),
                                              const Text(
                                                'Share Receipt',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 12.0),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFDAF3DB),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15.0),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                'images/Download.png',
                                                height: 20,
                                              ),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02),
                                              const Text(
                                                'View Receipt',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14.0,
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
                          ),
                        ),
                      ],
                    ),
                  if (inputPin)
                    Stack(
                      children: [
                        ModalBarrier(
                          dismissible: false,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        PopScope(
                          canPop: false,
                          onPopInvokedWithResult: (didPop, dynamic result) {
                            if (!didPop) {
                              setState(() {
                                inputPin = false;
                                pin = '';
                              });
                            }
                          },
                          child: GestureDetector(
                            onTap: () {
                              // Dismiss the keyboard when tapping outside
                              FocusScope.of(context).unfocus();
                            },
                            child: Center(
                              child: SingleChildScrollView(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20.0), // Centered padding
                                  padding: const EdgeInsets.all(
                                      16.0), // Inner padding for content
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25.0),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize
                                        .min, // Expands only as needed
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03),
                                      const Text(
                                        'Input PIN',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      PinInput(pin: pin, length: 4),
                                      const SizedBox(height: 20),
                                      // Custom Keyboard
                                      CustomKeyboard(
                                        onNumberPressed: (String number) {
                                          setState(() {
                                            if (pin.length < 4) {
                                              pin += number;
                                            }
                                            if (pin.length == 4) {
                                              handlePinInputComplete(pin);
                                            }
                                          });
                                        },
                                        onFingerprintPressed: () async {
                                          await authenticateWithFingerprint();
                                        },
                                        onBackspacePressed: () {
                                          setState(() {
                                            if (pin.isNotEmpty) {
                                              pin = pin.substring(
                                                  0, pin.length - 1);
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  Widget number(int currentNetworkIndex, String img, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: InkWell(
        onTap: () {
          setState(() {
            currentNetwork = currentNetworkIndex;
            phoneNumberController.text = text;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            border: currentNetwork == currentNetworkIndex &&
                    phoneNumberController.text == text
                ? Border.all(width: 2, color: const Color(0xFF02AA03))
                : Border.all(width: 0, color: Colors.transparent),
          ),
          child: SizedBox(
            width: (150 / MediaQuery.of(context).size.width) *
                MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(55),
                  child: SizedBox(
                    width: (30 / MediaQuery.of(context).size.width) *
                        MediaQuery.of(context).size.width,
                    height: (30 / MediaQuery.of(context).size.height) *
                        MediaQuery.of(context).size.height,
                    child: Image.asset(
                      img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Flexible(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget network(String img, String text) {
    return Expanded(
      flex: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(55),
            child: SizedBox(
              width: (30 / MediaQuery.of(context).size.width) *
                  MediaQuery.of(context).size.width,
              height: (30 / MediaQuery.of(context).size.height) *
                  MediaQuery.of(context).size.height,
              child: Image.asset(
                img,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Inter',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class PinInput extends StatelessWidget {
  final String pin;
  final int length;

  const PinInput({
    Key? key,
    required this.pin,
    required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: pin.length > index
                ? const Color(0xFF02AA03)
                : Colors.transparent,
            border: Border.all(
              color: Colors.black, // Set the border color
              width: 2, // Set the border width
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            pin.length > index ? pin[index] : '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }
}

class CustomKeyboard extends StatefulWidget {
  final Function(String) onNumberPressed;
  final Function onFingerprintPressed;
  final Function onBackspacePressed;

  const CustomKeyboard({
    super.key,
    required this.onNumberPressed,
    required this.onFingerprintPressed,
    required this.onBackspacePressed,
  });

  @override
  _CustomKeyboardState createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  List<bool> _isPressed =
      List.generate(12, (index) => false); // Track button press state

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 1.6,
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (int i = 1; i <= 9; i++)
          GestureDetector(
            onTapDown: (_) => _setPressed(i - 1, true),
            onTapUp: (_) {
              _setPressed(i - 1, false);
              widget.onNumberPressed(i.toString());
            },
            onTapCancel: () => _setPressed(i - 1, false),
            child: _buildKey(i.toString(), i - 1),
          ),
        GestureDetector(
          onTapDown: (_) => _setPressed(9, true),
          onTapUp: (_) {
            _setPressed(9, false);
            widget.onNumberPressed('0');
          },
          onTapCancel: () => _setPressed(9, false),
          child: _buildKey('0', 9),
        ),
        GestureDetector(
          onTapDown: (_) => _setPressed(10, true),
          onTapUp: (_) {
            _setPressed(10, false);
            widget.onBackspacePressed();
          },
          onTapCancel: () => _setPressed(10, false),
          child: _buildKey('Backspace', 10, isIcon: true),
        ),
        GestureDetector(
          onTapDown: (_) => _setPressed(11, true),
          onTapUp: (_) {
            _setPressed(11, false);
            widget.onFingerprintPressed();
          },
          onTapCancel: () => _setPressed(11, false),
          child: _buildKey('Fingerprint', 11, isIcon: true),
        ),
      ],
    );
  }

  void _setPressed(int index, bool isPressed) {
    setState(() {
      _isPressed[index] = isPressed;
    });
  }

  Widget _buildKey(String label, int index, {bool isIcon = false}) {
    return Container(
      margin: const EdgeInsets.all(4.0), // Reduced margin
      alignment: Alignment.center,
      width: 60, // Set a smaller width for keys
      height: 60, // Set a smaller height for keys
      decoration: BoxDecoration(
        color: _isPressed[index] ? Colors.green[300] : Colors.grey[200],
        borderRadius:
            BorderRadius.circular(8), // Slightly smaller border radius
      ),
      child: isIcon
          ? Icon(
              label == 'Backspace' ? Icons.backspace : Icons.fingerprint,
              size: 30, // Reduced icon size
              color:
                  label == 'Backspace' ? Colors.black : const Color(0xFF02AA03),
            )
          : Text(
              label,
              style: const TextStyle(fontSize: 18), // Reduced font size
            ),
    );
  }
}
