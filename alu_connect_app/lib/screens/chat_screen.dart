import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/mock_communities.dart';

class ChatScreen extends StatefulWidget {
  final Community community;

  const ChatScreen({super.key, required this.community});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  // Reads whatever the user types in the message box
  final TextEditingController _messageController = TextEditingController();

  // Lets us auto-scroll to the bottom when a new message is sent
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final String text = _messageController.text.trim();

    // Don't send empty messages
    if (text.isEmpty) return;

    setState(() {
      // Add the new message to this community's message list
      widget.community.messages.add(
        ChatMessage(senderName: 'You', text: text, isMe: true),
      );
    });

    // Clear the input field
    _messageController.clear();

    // Scroll to the bottom after the new message is added
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: Column(
          children: [

            // Header
            Container(
              width: double.infinity,
              color: AppColors.navyBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.community.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Messages list — empty state if no messages
            Expanded(
              child: widget.community.messages.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: AppColors.gray,
                            size: 48,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No messages yet.\nBe the first to say hello!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.community.messages.length,
                      itemBuilder: (context, index) {
                        final message = widget.community.messages[index];
                        return _buildMessageBubble(message);
                      },
                    ),
            ),

            // Input bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.lightGray),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: const TextStyle(
                          color: AppColors.gray,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: AppColors.offWhite,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: AppColors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  // One chat bubble — aligns right and turns red if sent by "You"
  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: message.isMe ? AppColors.red : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(message.isMe ? 14 : 2),
            bottomRight: Radius.circular(message.isMe ? 2 : 14),
          ),
          border: message.isMe ? null : Border.all(color: AppColors.lightGray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show sender name only for other people's messages
            if (!message.isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  message.senderName,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.red,
                  ),
                ),
              ),
            Text(
              message.text,
              style: TextStyle(
                fontSize: 14,
                color: message.isMe ? Colors.white : AppColors.navyBlue,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}