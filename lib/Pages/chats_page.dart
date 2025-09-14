import 'package:flutter/material.dart';
import 'package:flutter_project/Security/TokenManager.dart';
import 'package:flutter_project/Services/api_service.dart';
import 'package:flutter_project/Util/MyRoutes.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:flutter_project/Util/util_chatCard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:intl/intl.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  String? currentUserId;
  List<Map<String, dynamic>> chats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initUserAndChats();
  }

  Future<void> _initUserAndChats() async {
    String? token = await TokenManager.getToken();
    if (token == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, MyRoutes.LoginPage);
      return;
    }

    Map<String, dynamic> jwtDecoded = JwtDecoder.decode(token);
    currentUserId = jwtDecoded['id'];

    await _loadChats();
  }

  Future<void> _loadChats() async {
    if (currentUserId == null) return;

    try {
      final chatData = await ApiService.getChatList(currentUserId!);

      if (!mounted) return;

      setState(() {
        chats = chatData.map((chat) {
          final rawTime = chat["time"] ?? "";
          return {
            "receiverId": chat["receiverId"] ?? "",
            "receiverName": chat["receiverName"] ?? "Unknown",
            "lastMessage": chat["lastMessage"] ?? "",
            "time": _formatTimestamp(rawTime),
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading chats: $e");
      if (!mounted) return;
      setState(() {
        chats = [];
        isLoading = false;
      });
    }
  }

  String _formatTimestamp(String rawTime) {
    try {
      DateTime dt = DateTime.parse(rawTime);
      DateTime now = DateTime.now();

      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        // Today → show HH:mm
        return DateFormat('hh:mm a').format(dt);
      } else if (dt.year == now.year &&
          dt.month == now.month &&
          dt.day == now.day - 1) {
        return "Yesterday";
      } else {
        return DateFormat('dd/MM/yyyy').format(dt);
      }
    } catch (e) {
      return rawTime; // fallback if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null || isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: UtilitiesPages.APP_BAR_COLOR,
      ),
      body: chats.isEmpty
          ? const Center(child: Text("No chats yet"))
          : ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ChatCard(
                  userId: currentUserId!,
                  receiverId: chat["receiverId"] ?? "",
                  receiverName: chat["receiverName"] ?? "Unknown",
                  lastMessage: chat["lastMessage"] ?? "",
                  time: chat["time"] ?? "",
                );
              },
            ),
    );
  }
}
