import 'package:flutter/material.dart';
import 'package:flutter_project/Util/util_chat.dart';

class ChatCard extends StatelessWidget {
  final String userId;        // current user (sender)
  final String receiverId;    // other user
  final String receiverName;
  final String lastMessage;   // optional, for preview
  final String time;          // optional, for preview

  const ChatCard({
    Key? key,
    required this.userId,
    required this.receiverId,
    required this.receiverName,
    this.lastMessage = "",
    this.time = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(receiverName[0].toUpperCase()), // First letter avatar
        ),
        title: Text(receiverName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(time, style: const TextStyle(fontSize: 12)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                senderUserId: userId,
                receiverUserId: receiverId,
                receiverName: receiverName,
              ),
            ),
          );
        },
      ),
    );
  }
}
