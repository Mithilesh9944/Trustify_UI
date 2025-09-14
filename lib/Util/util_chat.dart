import 'package:flutter/material.dart';
import 'package:flutter_project/Services/socket_service.dart';
import 'package:flutter_project/Services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String senderUserId;
  final String receiverUserId;
  final String receiverName;

  const ChatPage({
    Key? key,
    required this.senderUserId,
    required this.receiverUserId,
    required this.receiverName,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupSocketListener();
    _loadPreviousMessages();

  }

  /// Load previous messages from backend
  Future<void> _loadPreviousMessages() async {
    try {
      final chatData = await ApiService.getIndividualMessages(
        widget.senderUserId,
        widget.receiverUserId,
      );

      if (!mounted) return;
      setState(() {
        messages = chatData.map((msg) {
          return {
            "senderId": msg["senderId"] ?? "",
            "text": msg["text"] ?? "",
            "timestamp": msg["timestamp"] ?? DateTime.now().toIso8601String(),
          };
        }).toList();
        isLoading = false;
      });

      // Scroll to bottom after loading
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    } catch (e) {
      debugPrint("Error fetching previous messages: $e");
      if (!mounted) return;
      setState(() {
        messages = [];
        isLoading = false;
      });
    }
  }

  /// Listen for incoming socket messages
  void _setupSocketListener() {
    SocketService.setMessageListener((data) {
      if (data["senderId"] == widget.receiverUserId ||
          data["receiverId"] == widget.receiverUserId) {
        setState(() {
          messages.add({
            "senderId": data["senderId"],
            "text": data["text"],
            "timestamp": data["timestamp"] ?? DateTime.now().toIso8601String(),
          });
        });

        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
      }
    });
  }

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;

    String msg = _msgController.text.trim();

    // Send via socket
    SocketService.sendMessage(
      widget.senderUserId,
      widget.receiverUserId,
      msg,
    );

    // Add locally
    setState(() {
      messages.add({
        "senderId": widget.senderUserId,
        "text": msg,
        "timestamp": DateTime.now().toIso8601String(),
      });
    });

    _msgController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  String _formatTime(String rawTime) {
    try {
      DateTime dt = DateTime.parse(rawTime);
      DateTime now = DateTime.now();

      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        return DateFormat('hh:mm a').format(dt);
      } else if (dt.year == now.year &&
          dt.month == now.month &&
          dt.day == now.day - 1) {
        return "Yesterday";
      } else {
        return DateFormat('dd/MM/yyyy').format(dt);
      }
    } catch (e) {
      return rawTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receiverName,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: UtilitiesPages.APP_BAR_COLOR,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      bool isMe = msg["senderId"] == widget.senderUserId;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 14),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[300] : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: isMe
                                  ? const Radius.circular(12)
                                  : const Radius.circular(0),
                              bottomRight: isMe
                                  ? const Radius.circular(0)
                                  : const Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg["text"],
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTime(msg["timestamp"]),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _msgController,
                            decoration: InputDecoration(
                              hintText: "Type a message...",
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        CircleAvatar(
                          backgroundColor: UtilitiesPages.APP_BAR_COLOR,
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: _sendMessage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
