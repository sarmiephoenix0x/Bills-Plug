import 'package:flutter/material.dart';

class TransactionDetails extends StatefulWidget {
  final int id;
  final String type;
  final String amount;
  final String timeStamp;
  const TransactionDetails(
      {super.key,
      required this.id,
      required this.type,
      required this.amount,
      required this.timeStamp});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails>
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
                              decoration: const BoxDecoration(
                                color: Color(0xFF02AA03),
                              ),
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
                                        ),
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                      const Expanded(
                                        flex: 10,
                                        child: Text(
                                          'Transaction Details',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.headset_mic,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
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
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 0.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Image.asset(
                                          "images/AppLogo.png",
                                          fit: BoxFit.contain,
                                          width: 100,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Transaction Successful!',
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: const Divider(
                                          color: Colors.grey,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 12.0),
                                      child: basicInfo("Transaction ID",
                                          widget.id.toString(), false),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 12.0),
                                      child: basicInfo(
                                          "Amount", widget.amount, true),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 12.0),
                                      child: basicInfo(
                                          "Number", "+234905479938", false),
                                    ),
                                    if (network) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 12.0),
                                        child: basicInfo("Network", "", false,
                                            img: "images/MTNImg.png"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 12.0),
                                        child: basicInfo(
                                            "Data Type", widget.type, false),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 12.0),
                                        child: basicInfo(
                                            "Data Plan", "10.0GB", false),
                                      ),
                                    ] else if (network == false) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 12.0),
                                        child: basicInfo("Subscription Type",
                                            "Renew", false),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 12.0),
                                        child: basicInfo("Subscription Plan",
                                            "GOTV Supa Plus", false),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 12.0),
                                        child: basicInfo("Decoder", "", false,
                                            img: "images/GoTVImg.png"),
                                      ),
                                    ],
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 12.0),
                                      child: basicInfo(
                                          "Date", widget.timeStamp, false),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: (50 /
                                          MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return const Color(0xFF02AA03);
                                          }
                                          return const Color(0xFFE9FFEF);
                                        },
                                      ),
                                      foregroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return const Color(0xFFE9FFEF);
                                          }
                                          return const Color(0xFF02AA03);
                                        },
                                      ),
                                      elevation:
                                          WidgetStateProperty.all<double>(4.0),
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
                                          'Report an issue',
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
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02),
                                SizedBox(
                                  height: (50 /
                                          MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return const Color(0xFFE9FFEF);
                                          }
                                          return const Color(0xFF02AA03);
                                        },
                                      ),
                                      foregroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return const Color(0xFF02AA03);
                                          }
                                          return const Color(0xFFE9FFEF);
                                        },
                                      ),
                                      elevation:
                                          WidgetStateProperty.all<double>(4.0),
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
                                          'Share Receipt',
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
          if (img != "")
            ClipRRect(
              borderRadius: BorderRadius.circular(55),
              child: SizedBox(
                width: (55 / MediaQuery.of(context).size.width) *
                    MediaQuery.of(context).size.width,
                height: (55 / MediaQuery.of(context).size.height) *
                    MediaQuery.of(context).size.height,
                child: Image.asset(
                  img,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Divider(
          color: Colors.grey,
          height: 20,
        ),
      ),
    ]);
  }
}
