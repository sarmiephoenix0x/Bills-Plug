import 'package:bills_plug/add_money_new_users2.dart';
import 'package:bills_plug/notification.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddMoneyNewUsers extends StatefulWidget {
  const AddMoneyNewUsers({super.key});

  @override
  State<AddMoneyNewUsers> createState() => _AddMoneyNewUsersState();
}

class _AddMoneyNewUsersState extends State<AddMoneyNewUsers>
    with TickerProviderStateMixin {
  String? profileImg;
  String? _type = 'type1';
  final FocusNode _detailsFocusNode = FocusNode();
  final FocusNode _dobFocusNode = FocusNode();

  final TextEditingController detailsController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
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

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 20.0, bottom: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF02AA03),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (profileImg == null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(55),
                              child: Container(
                                width:
                                    (60 / MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                height:
                                    (60 / MediaQuery.of(context).size.height) *
                                        MediaQuery.of(context).size.height,
                                color: Colors.grey,
                                child: Image.asset(
                                  'images/ProfilePic.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          else if (profileImg != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(55),
                              child: Container(
                                width:
                                    (60 / MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                height:
                                    (60 / MediaQuery.of(context).size.height) *
                                        MediaQuery.of(context).size.height,
                                color: Colors.grey,
                                child: Image.network(
                                  profileImg!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02),
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
                    ],
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
                                'Dear customer, in line with CBN circular in accordance to virtual account, you are to update your BVN/NIN information and regenerate a new virtual account number. Be rest assured that the process is easy and 100% secure. We do not store your BVN/NIN on our servers nor do we have access to your BVN/NIN information. Your information is strictly for verification purpose',
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
                        Text(
                          'Select Type',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        _typeDropdown(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Text(
                          'Input your details',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        TextFormField(
                          controller: detailsController,
                          focusNode: _detailsFocusNode,
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
                            floatingLabelBehavior: FloatingLabelBehavior.never,
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
                            suffix: const Text(
                              '(Required)',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.red,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          cursorColor: const Color(0xFF02AA03),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null; // No validation error
                          },
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Text(
                          'Date of Birth',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.0,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        GestureDetector(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                // Format the date in dd/MM/yyyy format before updating the controller
                                dobController.text = _formatDate(picked);
                              });
                            }
                          },
                          child: AbsorbPointer(
                            // Prevent TextFormField from opening keyboard
                            child: TextFormField(
                              controller: dobController,
                              focusNode: _dobFocusNode,
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
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      width: 3, color: Color(0xFF02AA03)),
                                ),
                              ),
                              cursorColor: const Color(0xFF02AA03),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        Container(
                          width: double.infinity,
                          height: (60 / MediaQuery.of(context).size.height) *
                              MediaQuery.of(context).size.height,
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddMoneyNewUsers2(key: UniqueKey()),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return const Color(0xFFE9FFEF);
                                  }
                                  return const Color(0xFF02AA03);
                                },
                              ),
                              foregroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return const Color(0xFF02AA03);
                                  }
                                  return const Color(0xFFE9FFEF);
                                },
                              ),
                              elevation: WidgetStateProperty.all<double>(4.0),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 3, color: Color(0xFF02AA03)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35)),
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
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'If you want a one-time payment account details click the link below',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.0,
                      color: Color(0xFFFF2626),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: DropdownButtonFormField<String>(
        value: _type,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 16,
        isExpanded: true,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          labelText: '',
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Inter',
            fontSize: 12.0,
            decoration: TextDecoration.none,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: InputBorder.none, // Remove default border
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 3, color: Color(0xFF02AA03)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 0, color: Colors.grey),
          ),
        ),
        onChanged: (String? newValue) {
          setState(() {
            _type = newValue;
          });
        },
        hint: const Text('Select Type'),
        items: <String>['type1', 'type2', 'type3']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          );
        }).toList(),
      ),
    );
  }
}
