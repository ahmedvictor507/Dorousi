import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/app_theme.dart';
import '../../../models/app_models.dart';
import 'package:intl/intl.dart' as intl;

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Conversations
    final List<Conversation> _conversations = [
      Conversation(
        id: '1',
        participantName: 'أ. مروان بناني',
        participantImage: 'https://i.pravatar.cc/150?u=marwan',
        lastMessage: 'هل لديك أي استفسار حول الدرس الأخير؟',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
        unreadCount: 1,
      ),
      Conversation(
        id: '2',
        participantName: 'الدعم الفني',
        participantImage: 'https://i.pravatar.cc/150?u=support',
        lastMessage: 'تم تفعيل الدورة بنجاح. شكراً لك!',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 0,
      ),
      Conversation(
        id: '3',
        participantName: 'أ. نورا القحطاني',
        participantImage: 'https://i.pravatar.cc/150?u=nora',
        lastMessage: 'رابط الحصة المباشرة سيتم إرساله قبل البدء بـ 5 دقائق.',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.messages, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_chat_read_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: _conversations.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                return _ConversationItem(conversation: _conversations[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.chat_bubble_outline_rounded, size: 60, color: AppColors.primaryBlue.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),
          const Text(
            AppStrings.noMessages,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ConversationItem extends StatelessWidget {
  final Conversation conversation;

  const _ConversationItem({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/messages/chat/${conversation.id}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: conversation.unreadCount > 0 ? AppColors.primaryGradient : null,
                    border: conversation.unreadCount == 0 ? Border.all(color: AppColors.divider.withOpacity(0.5)) : null,
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(conversation.participantImage),
                  ),
                ),
                if (conversation.unreadCount > 0)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.emeraldGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation.participantName,
                        style: TextStyle(
                          fontWeight: conversation.unreadCount > 0 ? FontWeight.bold : FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        _formatTime(conversation.lastMessageTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: conversation.unreadCount > 0 ? AppColors.primaryBlue : AppColors.textTertiary,
                          fontWeight: conversation.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            fontWeight: conversation.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (conversation.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${conversation.unreadCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      return intl.DateFormat('hh:mm a').format(time);
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else {
      return intl.DateFormat('dd/MM').format(time);
    }
  }
}
