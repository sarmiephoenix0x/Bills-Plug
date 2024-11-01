import 'package:flutter/material.dart';

class BillsplugChatLive extends StatefulWidget {
  const BillsplugChatLive({super.key});

  @override
  State<BillsplugChatLive> createState() => _BillsplugChatLiveState();
}

class _BillsplugChatLiveState extends State<BillsplugChatLive>
    with TickerProviderStateMixin {
  String? profileImg;
  TextEditingController _messageController = TextEditingController();

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
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: _buildTextField(),
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

  Widget _buildTextField() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Type a message",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            _buildAnimatedButton(
              Icons.send,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedButton(IconData icon) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDarkMode ? const Color(0xFF02AA03) : const Color(0xFF02AA03),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
