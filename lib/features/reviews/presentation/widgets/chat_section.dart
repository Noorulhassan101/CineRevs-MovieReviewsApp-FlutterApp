import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/utils/adaptive_colors.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../auth/data/auth_repository.dart';
import '../../data/messaging_repository.dart';
import '../../domain/chat_message_model.dart';

part 'chat_section.g.dart';

@riverpod
Stream<List<ChatMessage>> communityMessages(CommunityMessagesRef ref, String communityId) {
  return ref.watch(messagingRepositoryProvider).watchCommunityMessages(communityId);
}

class ChatSection extends ConsumerStatefulWidget {
  final String communityId;
  final bool isMember;

  const ChatSection({
    super.key,
    required this.communityId,
    required this.isMember,
  });

  @override
  ConsumerState<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends ConsumerState<ChatSection> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  String? _editingMessageId;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    final text = _messageController.text.trim();
    _messageController.clear();

    try {
      if (_editingMessageId != null) {
        // Edit mode
        await ref.read(messagingRepositoryProvider).editMessage(
          widget.communityId,
          _editingMessageId!,
          text,
        );
        setState(() => _editingMessageId = null);
      } else {
        // Send new message
        await ref.read(messagingRepositoryProvider).sendMessage(
          widget.communityId,
          user.uid,
          user.email?.split('@').first ?? 'User',
          null, // TODO: Add user photo URL from profile
          text,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(communityMessagesProvider(widget.communityId));
    final user = ref.watch(authRepositoryProvider).currentUser;

    return Column(
      children: [
        // Messages List
        Expanded(
          child: messagesAsync.when(
            data: (messages) {
              if (messages.isEmpty) {
                return Center(
                  child: Text(
                    'NO MESSAGES YET. START THE CONVERSATION!',
                    style: TextStyle(color: context.adaptiveWhite24, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              // Reverse to show newest at bottom
              final sortedMessages = messages.reversed.toList();

              return ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: sortedMessages.length,
                itemBuilder: (context, index) {
                  final message = sortedMessages[index];
                  final isOwnMessage = user?.uid == message.userId;

                  return _MessageBubble(
                    message: message,
                    isOwnMessage: isOwnMessage,
                    onEdit: isOwnMessage
                        ? () {
                            _editingMessageId = message.id;
                            _messageController.text = message.text;
                          }
                        : null,
                    onDelete: isOwnMessage
                        ? () {
                            ref.read(messagingRepositoryProvider).deleteMessage(
                              widget.communityId,
                              message.id,
                            );
                          }
                        : null,
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error loading messages: $e')),
          ),
        ),

        // Message Input
        if (widget.isMember)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: context.adaptiveWhite12),
              ),
            ),
            child: Column(
              children: [
                if (_editingMessageId != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primaryAccent.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'EDITING MESSAGE',
                            style: TextStyle(
                              color: AppColors.primaryAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _editingMessageId = null;
                              _messageController.clear();
                            });
                          },
                          child: Icon(Icons.close, size: 16, color: AppColors.primaryAccent),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  children: [
                    Expanded(
                      child: GlassContainer(
                        borderRadius: 24,
                        opacity: 0.05,
                        child: TextField(
                          controller: _messageController,
                          style: TextStyle(color: context.adaptiveWhite),
                          minLines: 1,
                          maxLines: 3,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: InputDecoration(
                            hintText: 'TYPE YOUR MESSAGE...',
                            hintStyle: TextStyle(color: context.adaptiveWhite24, fontSize: 11),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          _editingMessageId != null ? Icons.check : Icons.send,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              'JOIN THIS COMMUNITY TO PARTICIPATE IN CHAT',
              style: TextStyle(color: context.adaptiveWhite54, fontSize: 11, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isOwnMessage;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _MessageBubble({
    required this.message,
    required this.isOwnMessage,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final messageTime = timeFormat.format(message.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onLongPress: isOwnMessage ? () => _showMessageOptions(context) : null,
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isOwnMessage ? AppColors.primaryAccent.withOpacity(0.2) : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isOwnMessage ? 16 : 4),
                bottomRight: Radius.circular(isOwnMessage ? 4 : 16),
              ),
              border: Border.all(
                color: isOwnMessage ? AppColors.primaryAccent.withOpacity(0.3) : Colors.white.withOpacity(0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isOwnMessage) ...[
                  Text(
                    message.userName.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.secondaryAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  message.text,
                  style: TextStyle(color: context.adaptiveWhite, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      messageTime,
                      style: TextStyle(color: context.adaptiveWhite54, fontSize: 9),
                    ),
                    if (message.isEdited) ...[
                      const SizedBox(width: 4),
                      Text(
                        '(edited)',
                        style: TextStyle(color: context.adaptiveWhite54, fontSize: 9, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMessageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        borderRadius: 20,
        blur: 20,
        opacity: 0.1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (onEdit != null)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    onEdit!();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, color: AppColors.primaryAccent, size: 24),
                      const SizedBox(height: 8),
                      const Text('EDIT', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              if (onDelete != null)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDelete(context);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.delete, color: Colors.red, size: 24),
                      const SizedBox(height: 8),
                      const Text('DELETE', style: TextStyle(fontSize: 10, color: Colors.red)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('DELETE MESSAGE'),
        content: const Text('Are you sure? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
