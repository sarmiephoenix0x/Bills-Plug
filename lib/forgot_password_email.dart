import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'change_password.dart';
import 'forgot_password_number.dart';

class ForgotPasswordEmail extends StatefulWidget {
  const ForgotPasswordEmail({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ForgotPasswordEmailState createState() => ForgotPasswordEmailState();
}

class ForgotPasswordEmailState extends State<ForgotPasswordEmail>
    with TickerProviderStateMixin {
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
        builder: (context) => ChangePassword(key: UniqueKey()),
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
                              "An Email verification code has been sent to this Email ***********iam@gmail.com.",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPasswordNumber(
                                                  key: UniqueKey()),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Change Email',
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
                                ),
                                const Spacer(),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
                            OtpTextField(
                              numberOfFields: 4,
                              fieldWidth:
                                  (50 / MediaQuery.of(context).size.width) *
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
                                    MediaQuery.of(context).size.height * 0.05),
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
                                    MediaQuery.of(context).size.height * 0.02),
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
                                    MediaQuery.of(context).size.height * 0.05),
                            // Container(
                            //   width: double.infinity,
                            //   height:
                            //       (60 / MediaQuery.of(context).size.height) *
                            //           MediaQuery.of(context).size.height,
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 20.0),
                            //   child: ElevatedButton(
                            //     onPressed: () {
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) =>
                            //               ChangePassword(key: UniqueKey()),
                            //         ),
                            //       );
                            //     },
                            //     style: ButtonStyle(
                            //       backgroundColor:
                            //           WidgetStateProperty.resolveWith<Color>(
                            //         (Set<WidgetState> states) {
                            //           if (states
                            //               .contains(WidgetState.pressed)) {
                            //             return Colors.white;
                            //           }
                            //           return const Color(0xFF02AA03);
                            //         },
                            //       ),
                            //       foregroundColor:
                            //           WidgetStateProperty.resolveWith<Color>(
                            //         (Set<WidgetState> states) {
                            //           if (states
                            //               .contains(WidgetState.pressed)) {
                            //             return const Color(0xFF02AA03);
                            //           }
                            //           return Colors.white;
                            //         },
                            //       ),
                            //       elevation:
                            //           WidgetStateProperty.all<double>(4.0),
                            //       shape: WidgetStateProperty.all<
                            //           RoundedRectangleBorder>(
                            //         const RoundedRectangleBorder(
                            //           borderRadius:
                            //               BorderRadius.all(Radius.circular(15)),
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
