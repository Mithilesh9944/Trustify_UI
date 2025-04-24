import 'package:flutter/material.dart';
import 'package:flutter_project/Util/chatModel.dart';
import 'package:flutter_project/Pages/ChatBox.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  // Sample chat list data
  List<ChatModel> chats = [
    ChatModel(
      username: 'John Doe',
      lastMessage: 'Hey, how are you?',
      time: '2:30 PM',
      profilePicUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
    ),
    ChatModel(
      username: 'Jane Smith',
      lastMessage: 'Let\'s catch up soon!',
      time: '1:15 PM',
      profilePicUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
    ),
    // You can add more chat data here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chat.profilePicUrl),
            ),
            title: Text(chat.username),
            subtitle: Text(chat.lastMessage),
            trailing: Text(chat.time),
            onTap: () {
              // Navigate to ChatPage and pass the username
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatBox(
                    user1: 'Me', // You can replace this with the actual user if needed
                    user2: chat.username,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // Add a new chat dynamically (just for demonstration)
            chats.add(ChatModel(
              username: 'New User',
              lastMessage: 'This is a new message.',
              time: 'Now',
              profilePicUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
            ));
          });
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChatListPage(),
  ));
}
