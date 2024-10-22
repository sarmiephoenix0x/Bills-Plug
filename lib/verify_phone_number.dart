import 'package:flutter/material.dart';

class VerifyPhoneNumber extends StatefulWidget {
  const VerifyPhoneNumber({super.key});

  @override
  // ignore: library_private_types_in_public_api
  VerifyPhoneNumberState createState() => VerifyPhoneNumberState();
}

class VerifyPhoneNumberState extends State<VerifyPhoneNumber>
    with SingleTickerProviderStateMixin {
  final int _numberOfFields = 4;
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];
  List<String> inputs = List.generate(4, (index) => '');

  @override
  void initState() {
    super.initState();
    controllers =
        List.generate(_numberOfFields, (index) => TextEditingController());
    focusNodes = List.generate(_numberOfFields, (index) => FocusNode());
    focusNodes[0].requestFocus(); // Focus on the first field initially

    // for (var i = 0; i < _numberOfFields; i++) {
    //   controllers[i].addListener(() => onKeyPressed(controllers[i].text, i));
    // }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void onKeyPressed(String value, int index) {
    setState(() {
      if (value.isEmpty) {
        // Handle backspace
        for (int i = inputs.length - 1; i >= 0; i--) {
          if (inputs[i].isNotEmpty) {
            inputs[i] = '';
            if (i > 0) {
              FocusScope.of(context).requestFocus(focusNodes[i - 1]);
            }
            controllers[i].selection =
                TextSelection.collapsed(offset: controllers[i].text.length);
            break;
          }
        }
      } else if (index != -1) {
        // Handle text input
        inputs[index] = value;
        controllers[index].selection =
            TextSelection.collapsed(offset: controllers[index].text.length);

        if (index < _numberOfFields - 1) {
          // Move focus to the next field
          FocusScope.of(context).requestFocus(focusNodes[index + 1]);
        }

        bool allFieldsFilled = inputs.every((element) => element.isNotEmpty);
        if (allFieldsFilled) {
          // Handle all fields filled case
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => CreateAccount_Profile_Page(
          //         key: UniqueKey(), isLoadedFromFirstPage: "false"),
          //   ),
          // );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                                const Spacer(),
                              ],
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.06),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                  const Text(
                                    'Verify Mobile Number',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Text(
                                    "A verification code has been sent to this Number +234*****59546.",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children:
                                        List.generate(_numberOfFields, (index) {
                                      return SizedBox(
                                        width: 50,
                                        child: TextFormField(
                                          controller: controllers[index],
                                          focusNode: focusNodes[index],
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          maxLength: 1,
                                          decoration: InputDecoration(
                                            counterText: '',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                color: Color(0xFF02AA03),
                                              ),
                                            ),
                                          ),
                                          cursorColor: const Color(0xFF02AA03),
                                          enabled: index == 0 ||
                                              controllers[index - 1]
                                                  .text
                                                  .isNotEmpty,
                                          onChanged: (value) {
                                            if (value.length == 1) {
                                              onKeyPressed(value, index);
                                            } else if (value.isEmpty) {
                                              onKeyPressed(value, index);
                                            }
                                          },
                                          onFieldSubmitted: (value) {
                                            if (value.isNotEmpty) {
                                              onKeyPressed(value, index);
                                            }
                                          },
                                        ),
                                      );
                                    }),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05),
                                  const Center(
                                    child: Text(
                                      "Didn't receive code?",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  const Center(
                                    child: Text(
                                      "Resend it",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF02AA03),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                      onPressed: () {},
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Confirm',
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
                        ],
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

  Widget verify(IconData icon, String value) {
    return Row(
      children: [
        IconButton(
          icon: Icon(icon, color: const Color(0xFF02AA03)),
          onPressed: () {},
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.03),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
