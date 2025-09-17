import 'package:flutter/material.dart';

class ChatWithUsView extends StatefulWidget {
  const ChatWithUsView({super.key});

  @override
  State<ChatWithUsView> createState() => _ChatWithUsViewState();
}

class _ChatWithUsViewState extends State<ChatWithUsView> {
  final messages = [
    ChatMessage(
      text:
          "Hi Aman, Let me know if you need help and you can ask us any questions.",
      time: "08:20 AM",
      isSender: false,
      avatarUrl:
          "https://cdn-icons-png.flaticon.com/512/4140/4140048.png", // female avatar
    ),
    ChatMessage(
      text: "How to check approvals from my university?",
      time: "08:21 AM",
      isSender: true,
      avatarUrl:
          "https://cdn-icons-png.flaticon.com/512/4333/4333609.png", // male avatar
    ),
    ChatMessage(
      text:
          "Open Education tab from My Profile and you can check your pending approvals there. Hope this helped!",
      time: "08:22 AM",
      isSender: false,
      avatarUrl:
          "https://cdn-icons-png.flaticon.com/512/4333/4333609.png", // male avatar
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Support',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  'How can we help you?',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return ChatBubble(message: message);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: const Color(0xFF002D72), // Dark blue
          child: Row(
            children: [
              /// Camera icon
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.camera_alt_outlined,
                    color: Colors.white, size: 26),
              ),

              /// Text input
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), // light overlay
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Write a comment",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              /// Send button
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          message.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: message.isSender
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isSender)
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(message.avatarUrl),
              ),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color:
                      message.isSender ? Colors.red : const Color(0xFF002D72),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(message.isSender ? 16 : 0),
                    bottomRight: Radius.circular(message.isSender ? 0 : 16),
                  ),
                ),
                child: Text(
                  message.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (message.isSender)
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(message.avatarUrl),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.only(
              left: message.isSender ? 0 : 46,
              right: message.isSender ? 46 : 0),
          child: Text(
            message.time,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class ChatMessage {
  final String text;
  final String time;
  final bool isSender; // true = red bubble, false = blue bubble
  final String avatarUrl;

  ChatMessage({
    required this.text,
    required this.time,
    required this.isSender,
    required this.avatarUrl,
  });
}
