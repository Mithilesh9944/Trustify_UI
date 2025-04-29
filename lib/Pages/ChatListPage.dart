import 'package:flutter/material.dart';
import 'package:flutter_project/Services/socket_service.dart';
import 'package:flutter_project/Security/TokenManager.dart'; // Secure storage here too
import 'ChatBox.dart';
import 'package:intl/intl.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late List<Map<String, dynamic>> chats = [];
  late String? token;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    token = await TokenManager.getToken();

    if (token == null) {
      print('❌ Token not found.');
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      List<Map<String, dynamic>> chatHistory = await SocketService.getChatHistory(
        token: token!,
      );

      if (mounted) {
        setState(() {
          chats = chatHistory;
          isLoading = false;
        });
      }
    } catch (error) {
      print('❌ Error loading chats: $error');
      if (mounted) {
        setState(() {
          chats = [];
          isLoading = false;
        });
      }
    }
  }

  Future<void> _openChat(String receiverMobile, String receiverName) async {
    token = await TokenManager.getToken();

    if (token == null) {
      print('❌ Token not found.');
      return;
    }

    try {
      List<Map<String, dynamic>> history = await SocketService.getChatHistory(
        token: token!,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatBox(
              receiverMobile: receiverMobile,
              receiverName: receiverName,
              initialMessages: history,
            ),
          ),
        );
      }
    } catch (error) {
      print('❌ Error fetching chat history: $error');
    }
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) {
      return '';
    }
    
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      // If less than 24 hours, show time
      if (difference.inHours < 24) {
        return DateFormat('h:mm a').format(dateTime);
      } 
      // If less than 7 days, show day of week
      else if (difference.inDays < 7) {
        return DateFormat('E').format(dateTime);
      } 
      // Otherwise show date
      else {
        return DateFormat('MMM d').format(dateTime);
      }
    } catch (e) {
      print('Error formatting timestamp: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadChats,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : chats.isEmpty
              ? const Center(
                  child: Text(
                    "No Chats Yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final lastMessage = chat['message'] ?? 'No message';
                    final timestamp = chat['timestamp'] ?? '';
                    final senderMobile = chat['senderMobile'] ?? '';
                    final formattedTime = _formatTimestamp(timestamp);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            senderMobile.isNotEmpty 
                                ? senderMobile.substring(0, 1).toUpperCase() 
                                : '?',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          senderMobile,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          formattedTime,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () => _openChat(senderMobile, senderMobile),
                      ),
                    );
                  },
                ),
    );
  }
}
