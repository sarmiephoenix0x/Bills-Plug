import 'package:flutter/material.dart';
import 'package:bills_plug/login_page.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword>
    with SingleTickerProviderStateMixin {
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPasswordVisible2 = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isLoading = false;
  bool isPasswordChanged = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.4, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.05),
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
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(children: [
                            if(isPasswordChanged == false)...[
                              SizedBox(
                                  height:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.03),
                              const Text(
                                'Change Password',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                  height:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.04),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                                child: TextFormField(
                                  controller: passwordController,
                                  focusNode: _passwordFocusNode,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
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
                                        icon: const Icon(
                                          Icons.lock,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {},
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.grey),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible =
                                            !_isPasswordVisible;
                                          });
                                        },
                                      )),
                                  cursorColor: const Color(0xFF02AA03),
                                  obscureText: !_isPasswordVisible,
                                  obscuringCharacter: "*",
                                ),
                              ),
                              SizedBox(
                                  height:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.02),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                                child: TextFormField(
                                  controller: confirmPasswordController,
                                  focusNode: _confirmPasswordFocusNode,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
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
                                        icon: const Icon(
                                          Icons.lock,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {},
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            _isPasswordVisible2
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.grey),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible2 =
                                            !_isPasswordVisible2;
                                          });
                                        },
                                      )),
                                  cursorColor: const Color(0xFF02AA03),
                                  obscureText: !_isPasswordVisible2,
                                  obscuringCharacter: "*",
                                ),
                              ),
                              SizedBox(
                                  height:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.05),
                              Container(
                                width: double.infinity,
                                height:
                                (60 / MediaQuery
                                    .of(context)
                                    .size
                                    .height) *
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .height,
                                padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isPasswordChanged = true;
                                    });
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         SignUpPage(key: UniqueKey()),
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
                                    'Submit',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ] else
                              ...[
                                SizedBox(
                                    height:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.03),
                                const Text(
                                  'Successful!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF02AA03),
                                  ),
                                ),
                                SizedBox(
                                    height:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.04),
                                Container(
                                  width: double.infinity,
                                  height: (60 / MediaQuery
                                      .of(context)
                                      .size
                                      .height) *
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .height,
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LoginPage(key: UniqueKey()),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                          if (states.contains(
                                              WidgetState.pressed)) {
                                            return const Color(0xFFE9FFEF);
                                          }
                                          return const Color(0xFF02AA03);
                                        },
                                      ),
                                      foregroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                          if (states.contains(
                                              WidgetState.pressed)) {
                                            return const Color(0xFF02AA03);
                                          }
                                          return const Color(0xFFE9FFEF);
                                        },
                                      ),
                                      elevation: WidgetStateProperty.all<
                                          double>(4.0),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 3,
                                              color: Color(0xFF02AA03)),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Return',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
