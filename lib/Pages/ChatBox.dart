import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';
import '../Services/socket_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ChatBox extends StatefulWidget {
  final String token;
  final String partnerMobile;
  final String partnerName;

  const ChatBox({
    Key? key,
    required this.token,
    required this.partnerMobile,
    required this.partnerName,
  }) : super(key: key);

  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  bool isLoading = true;
  String? myMobile;

  @override
  void initState() {
    super.initState();
    _initializeSocket();
    _loadMessages();
  }

  void _initializeSocket() {
    // Decode token to get user's mobile number
    Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
    myMobile = decodedToken['mobileNo'];

    // Initialize socket connection
    socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': widget.token}
    });

    socket.connect();

    // Listen for incoming messages
    socket.on('message', (data) {
      if (data['from'] == widget.partnerMobile || data['to'] == widget.partnerMobile) {
        setState(() {
          messages.add({
            'message': data['message'],
            'senderMobile': data['from'],
            'timestamp': data['timestamp'],
          });
        });
      }
    });

    socket.onConnect((_) {
      print('Connected to socket server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket server');
    });

    socket.onError((err) {
      print('Socket error: $err');
    });
  }

  Future<void> _loadMessages() async {
    setState(() => isLoading = true);
    
    try {
      final loadedMessages = await SocketService.getMessages(
        token: widget.token,
        mobile1: myMobile!,
        mobile2: widget.partnerMobile,
      );
      
      setState(() {
        messages = loadedMessages;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading messages: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    _messageController.clear();

    try {
      // Save message to backend
      final success = await SocketService.saveMessage(
        token: widget.token,
        senderMobile: myMobile!,
        receiverMobile: widget.partnerMobile,
        message: message,
      );

      if (success) {
        // Emit message through socket
        socket.emit('message', {
          'from': myMobile,
          'to': widget.partnerMobile,
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message')),
      );
    }
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('MMM d, h:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.partnerName),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      final isMe = message['senderMobile'] == myMobile;

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['message'],
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _formatTimestamp(message['timestamp']),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

