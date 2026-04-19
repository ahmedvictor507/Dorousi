import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/common_widgets.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  const ChatScreen({super.key, required this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  
  // Mock Messages
  final List<Map<String, dynamic>> _messages = [
    {'text': 'مرحباً، هل يمكنني مساعدتك؟', 'isMe': false, 'time': '10:00 AM'},
    {'text': 'أهلاً يا أستاذ مروان، عندي تساؤل بخصوص درس القواعد.', 'isMe': true, 'time': '10:05 AM'},
    {'text': 'تفضل يا بني، أنا هنا للإجابة.', 'isMe': false, 'time': '10:06 AM'},
  ];

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'text': _msgController.text,
        'isMe': true,
        'time': 'الآن',
      });
      _msgController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=marwan'),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('أ. مروان بناني', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text('متصل الآن', style: TextStyle(fontSize: 10, color: AppColors.emeraldGreen)),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg['text'], msg['isMe'], msg['time']);
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe, String time) {
    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryBlue : (Theme.of(context).cardColor),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? Radius.zero : const Radius.circular(20),
            bottomRight: isMe ? const Radius.circular(20) : Radius.zero,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(color: isMe ? Colors.white : AppColors.textPrimary, height: 1.4),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : AppColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: AppColors.divider.withOpacity(0.3))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: GlassContainer(
                opacity: 0.1,
                blur: 5,
                borderRadius: BorderRadius.circular(25),
                child: TextField(
                  controller: _msgController,
                  decoration: const InputDecoration(
                    hintText: 'اكتب رسالتك...',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
