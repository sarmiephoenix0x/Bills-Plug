import 'package:flutter/material.dart';
import 'package:bills_plug/create_new_password.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  // ignore: library_private_types_in_public_api
  VerifyEmailState createState() => VerifyEmailState();
}

class VerifyEmailState extends State<VerifyEmail>
    with SingleTickerProviderStateMixin {
  String otpCode = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleOtpInputComplete(String code) {
    setState(() {
      otpCode = code;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateNewPassword(
          key: UniqueKey(),
        ),
      ),
    );
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
                                    'Verify Email Address',
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
                                    "A verification code has been sent to this Email test*****@gmail.com.",
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
                                  OtpTextField(
                                    numberOfFields: 4,
                                    fieldWidth: (50 /
                                            MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                    focusedBorderColor: const Color(
                                        0xFF02AA03), // Border color when focused
                                    enabledBorderColor: Colors.grey,
                                    borderColor: Colors.grey,
                                    showFieldAsBox: true,
                                    onCodeChanged: (String code) {
                                      // Handle real-time OTP input changes
                                    },
                                    onSubmit: (String code) =>
                                        handleOtpInputComplete(code),
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
                                  // Container(
                                  //   width: double.infinity,
                                  //   height: (60 /
                                  //           MediaQuery.of(context)
                                  //               .size
                                  //               .height) *
                                  //       MediaQuery.of(context).size.height,
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 20.0),
                                  //   child: ElevatedButton(
                                  //     onPressed: () {

                                  //     },
                                  //     style: ButtonStyle(
                                  //       backgroundColor: WidgetStateProperty
                                  //           .resolveWith<Color>(
                                  //         (Set<WidgetState> states) {
                                  //           if (states.contains(
                                  //               WidgetState.pressed)) {
                                  //             return Colors.white;
                                  //           }
                                  //           return const Color(0xFF02AA03);
                                  //         },
                                  //       ),
                                  //       foregroundColor: WidgetStateProperty
                                  //           .resolveWith<Color>(
                                  //         (Set<WidgetState> states) {
                                  //           if (states.contains(
                                  //               WidgetState.pressed)) {
                                  //             return const Color(0xFF02AA03);
                                  //           }
                                  //           return Colors.white;
                                  //         },
                                  //       ),
                                  //       elevation:
                                  //           WidgetStateProperty.all<double>(
                                  //               4.0),
                                  //       shape: WidgetStateProperty.all<
                                  //           RoundedRectangleBorder>(
                                  //         const RoundedRectangleBorder(
                                  //           borderRadius: BorderRadius.all(
                                  //               Radius.circular(15)),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     child: const Text(
                                  //       'Confirm',
                                  //       style: TextStyle(
                                  //         fontFamily: 'Inter',
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
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
