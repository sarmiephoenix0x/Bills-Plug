import 'package:flutter/material.dart';

class WithdrawMoneyPage extends StatefulWidget {
  const WithdrawMoneyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  WithdrawMoneyPageState createState() => WithdrawMoneyPageState();
}

class WithdrawMoneyPageState extends State<WithdrawMoneyPage>
    with SingleTickerProviderStateMixin {
  final FocusNode _accountNumberFocusNode = FocusNode();
  final FocusNode _bankFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  bool _showInitialContent = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (_showInitialContent == true) {
                                    Navigator.pop(context);
                                  } else {
                                    setState(() {
                                      _showInitialContent = true;
                                    });
                                  }
                                },
                                child: Image.asset(
                                  'images/BackButton.png',
                                  height: 40,
                                ),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2),
                              const Text(
                                'Withdraw',
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
                            height: MediaQuery.of(context).size.height * 0.05),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          // Animation duration
                          child: _showInitialContent
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
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
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                width: 3,
                                                color: Color(0xFF02AA03)),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        cursorColor: const Color(0xFF02AA03),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: TextFormField(
                                        controller: accountNumberController,
                                        focusNode: _accountNumberFocusNode,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                        ),
                                        decoration: InputDecoration(
                                            labelText:
                                                'Enter 10 digits Account Number',
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
                                                  width: 3, color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                  width: 3,
                                                  color: Color(0xFF02AA03)),
                                            ),
                                            suffixIcon: IconButton(
                                              icon: const Icon(
                                                Icons.cancel,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {},
                                            )),
                                        cursorColor: const Color(0xFF02AA03),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: AbsorbPointer(
                                        // Prevent TextFormField from opening keyboard
                                        child: TextFormField(
                                          controller: bankController,
                                          focusNode: _bankFocusNode,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                          ),
                                          decoration: InputDecoration(
                                              labelText: 'Select Bank',
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
                                              suffixIcon: IconButton(
                                                icon: const Icon(
                                                  Icons.navigate_next,
                                                  color: Colors.grey,
                                                ),
                                                onPressed: () {},
                                              )),
                                          cursorColor: const Color(0xFF02AA03),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        const Spacer(),
                        Container(
                          width: double.infinity,
                          height: (60 / MediaQuery.of(context).size.height) *
                              MediaQuery.of(context).size.height,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showInitialContent = false;
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return Colors.white;
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
                                  return Colors.white;
                                },
                              ),
                              elevation: WidgetStateProperty.all<double>(4.0),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
