import 'package:bills_plug/billsplug_chat2.dart';
import 'package:bills_plug/billsplug_chat3.dart';
import 'package:flutter/material.dart';

class BillsplugChat extends StatefulWidget {
  const BillsplugChat({super.key});

  @override
  State<BillsplugChat> createState() => _BillsplugChatState();
}

class _BillsplugChatState extends State<BillsplugChat>
    with TickerProviderStateMixin {
  String? profileImg;

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
                  ListView(
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
                                              0.2),
                                      const Text(
                                        'Billsplug Chat',
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
                                ],
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
                            Column(
                              children: [
                                _buildMessageBubble(
                                    "Welcome to Billsplug help center we offer a clear understanding of the platform and how to use it.",
                                    false),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: (40 /
                                                MediaQuery.of(context)
                                                    .size
                                                    .height) *
                                            MediaQuery.of(context).size.height,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BillsplugChatLive(
                                                  key: UniqueKey(),
                                                ),
                                              ),
                                            );
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty
                                                .resolveWith<Color>(
                                              (Set<WidgetState> states) {
                                                if (states.contains(
                                                    WidgetState.pressed)) {
                                                  return const Color(
                                                      0xFFE9FFEF);
                                                }
                                                return const Color(0xFF02AA03);
                                              },
                                            ),
                                            foregroundColor: WidgetStateProperty
                                                .resolveWith<Color>(
                                              (Set<WidgetState> states) {
                                                if (states.contains(
                                                    WidgetState.pressed)) {
                                                  return const Color(
                                                      0xFF02AA03);
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
                                                'Live Chat',
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      SizedBox(
                                        height: (40 /
                                                MediaQuery.of(context)
                                                    .size
                                                    .height) *
                                            MediaQuery.of(context).size.height,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BillsplugChatFAQ(
                                                  key: UniqueKey(),
                                                ),
                                              ),
                                            );
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty
                                                .resolveWith<Color>(
                                              (Set<WidgetState> states) {
                                                if (states.contains(
                                                    WidgetState.pressed)) {
                                                  return const Color(
                                                      0xFFE9FFEF);
                                                }
                                                return const Color(0xFF02AA03);
                                              },
                                            ),
                                            foregroundColor: WidgetStateProperty
                                                .resolveWith<Color>(
                                              (Set<WidgetState> states) {
                                                if (states.contains(
                                                    WidgetState.pressed)) {
                                                  return const Color(
                                                      0xFF02AA03);
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
                                                'FAQ',
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

  Widget _buildMessageBubble(String message, bool isSentByMe) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define colors for sender (right) and receiver (left)
    Color senderBubbleColor =
        isDarkMode ? const Color(0xFF02AA03) : const Color(0xFF02AA03);
    Color receiverBubbleColor =
        isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;

    Color senderTextColor = Colors.white;
    Color receiverTextColor = isDarkMode ? Colors.white : Colors.black87;

    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
        decoration: BoxDecoration(
          color: isSentByMe ? senderBubbleColor : receiverBubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isSentByMe ? const Radius.circular(15) : Radius.zero,
            bottomRight: isSentByMe ? Radius.zero : const Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Audio message handling
            // if (message['audioUrl'] != null)
            //   Row(
            //     children: [
            //       IconButton(
            //         icon: Icon(
            //           _isPlaying &&
            //                   _currentPlayingFilePath ==
            //                       _getAudioPath(message['audioUrl'])
            //               ? Icons.pause
            //               : Icons.play_arrow,
            //         ),
            //         onPressed: () =>
            //             _togglePlayPause(_getAudioPath(message['audioUrl'])),
            //       ),
            //       const Text(
            //         'Voice Note',
            //         style: TextStyle(
            //           fontSize: 17,
            //           fontFamily: 'Inter',
            //         ),
            //       ),
            //     ],
            //   ),

            // Image message handling (can be multiple images)
            // if (message['imageUrls'] != null && message['imageUrls'].isNotEmpty)
            //   Column(
            //     children: message['imageUrls'].map<Widget>((imageUrl) {
            //       return imageUrl.startsWith('http')
            //           ? Image.network(
            //               '$imageUrl/download?project=66e4476900275deffed4',
            //               fit: BoxFit.cover,
            //             )
            //           : Image.file(
            //               File(imageUrl),
            //               fit: BoxFit.cover,
            //             );
            //     }).toList(),
            //   ),

            // Text message handling
            // if (message['text'] != null && message['text'].isNotEmpty)
            Text(
              message,
              style: TextStyle(
                color: isSentByMe ? senderTextColor : receiverTextColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
