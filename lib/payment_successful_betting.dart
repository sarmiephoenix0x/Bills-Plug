import 'package:flutter/material.dart';

class PaymentSuccessfulBetting extends StatefulWidget {
  final int id;
  final String betId;
  final String type;
  final String amount;
  final String timeStamp;
  const PaymentSuccessfulBetting(
      {super.key,
      required this.id,
      required this.type,
      required this.amount,
      required this.timeStamp,
      required this.betId});

  @override
  State<PaymentSuccessfulBetting> createState() =>
      _PaymentSuccessfulBettingState();
}

class _PaymentSuccessfulBettingState extends State<PaymentSuccessfulBetting>
    with TickerProviderStateMixin {
  String? profileImg;
  bool network = true;

  String _formatValue(String value) {
    // Try to parse the value as a number
    final number = double.tryParse(value);

    // Check if the value has a decimal part and format only if it does
    if (number != null) {
      return number % 1 != 0
          ? number.toStringAsFixed(2)
          : number.toStringAsFixed(0);
    }

    // Return the original value if it's not a number
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ListView(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 20.0,
                                  bottom: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Image.asset(
                                          'images/BackButton_White.png',
                                          height: 40,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "images/Tick.png",
                                        fit: BoxFit.contain,
                                        width: 80,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Payment Successful!',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          color: Color(0xFF02AA03),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 0.0),
                                    decoration: const BoxDecoration(
                                      color: Color(0x1A32FF33),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 12.0),
                                          child: basicInfo3("Transaction ID",
                                              widget.id.toString(), false,
                                              img: "images/CopyImg.png"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 12.0),
                                          child: basicInfo4(
                                              "Amount", widget.amount, true),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 0.0),
                                    decoration: const BoxDecoration(
                                      color: Color(0x1A32FF33),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 12.0),
                                          child: basicInfo("Betting ID",
                                              widget.betId.toString(), false),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 12.0),
                                          child: basicInfo("Selected Type",
                                              widget.type, false,
                                              img: "images/SportyBet.png"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 12.0),
                                          child: basicInfo(
                                              "Date", widget.timeStamp, false),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 12.0),
                                          child: basicInfo2(
                                              "Message",
                                              "Your Airtime Pin wil l be sent to your mobile number within 1 hour",
                                              false),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: (50 /
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        MediaQuery.of(context).size.height,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.pressed)) {
                                              return const Color(0xFF02AA03);
                                            }
                                            return const Color(0xFFE9FFEF);
                                          },
                                        ),
                                        foregroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.pressed)) {
                                              return const Color(0xFFE9FFEF);
                                            }
                                            return const Color(0xFF02AA03);
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
                                                Radius.circular(35)),
                                          ),
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Text(
                                            'Complete',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    height: (50 /
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        MediaQuery.of(context).size.height,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.pressed)) {
                                              return const Color(0xFFE9FFEF);
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
                                            return const Color(0xFFE9FFEF);
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
                                                Radius.circular(35)),
                                          ),
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Text(
                                            'TopUP Again',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
        );
      },
    );
  }

  Widget basicInfo(String title, String value, bool amount, {String img = ""}) {
    return Column(children: [
      Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (img != "") ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      width: (35 / MediaQuery.of(context).size.width) *
                          MediaQuery.of(context).size.width,
                      height: (35 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      child: Image.asset(
                        img,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                ],
                if (amount == true)
                  Image.asset(
                    'images/NairaImg.png',
                    height: 15,
                  ),
                if (value != "")
                  Flexible(
                    child: Text(
                      _formatValue(value),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }

  Widget basicInfo2(String title, String value, bool amount,
      {String img = ""}) {
    return Column(children: [
      Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (value != "")
                  Flexible(
                    child: Text(
                      _formatValue(value),
                      softWrap: true,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }

  Widget basicInfo3(String title, String value, bool amount,
      {String img = ""}) {
    return Column(children: [
      Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (amount == true)
                  Image.asset(
                    'images/NairaImg.png',
                    height: 15,
                  ),
                if (value != "")
                  Flexible(
                    child: Text(
                      _formatValue(value),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                if (img != "") ...[
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      width: (25 / MediaQuery.of(context).size.width) *
                          MediaQuery.of(context).size.width,
                      height: (25 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      child: Image.asset(
                        img,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ]);
  }

  Widget basicInfo4(String title, String value, bool amount,
      {String img = ""}) {
    return Column(children: [
      Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (img != "") ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      width: (35 / MediaQuery.of(context).size.width) *
                          MediaQuery.of(context).size.width,
                      height: (35 / MediaQuery.of(context).size.height) *
                          MediaQuery.of(context).size.height,
                      child: Image.asset(
                        img,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                ],
                if (amount == true)
                  Image.asset(
                    'images/NairaImg.png',
                    height: 15,
                  ),
                if (value != "")
                  Flexible(
                    child: Text(
                      _formatValue(value),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
