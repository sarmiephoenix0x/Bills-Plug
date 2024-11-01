import 'package:flutter/material.dart';

class BillsplugChatFAQ extends StatefulWidget {
  const BillsplugChatFAQ({super.key});

  @override
  State<BillsplugChatFAQ> createState() => _BillsplugChatFAQState();
}

class _BillsplugChatFAQState extends State<BillsplugChatFAQ>
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
                            _buildMessageBubble(
                                "Welcome to Billsplug help center we offer a clear understanding of the platform and how to use it.",
                                false),
                            _buildMessageBubble(
                                "1. How do i fund my wallet", true),
                            _buildMessageBubble(
                                "2. Why should I use my BVN/NIN for KYC verification",
                                true),
                            _buildMessageBubble(
                                "3. How do I buy Data/Other product on the app",
                                true),
                            _buildMessageBubble(
                                "4. How do I rectify transaction issue on the app ",
                                true),
                            _buildMessageBubble(
                                "5. How do i earn from refferre", true),
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
