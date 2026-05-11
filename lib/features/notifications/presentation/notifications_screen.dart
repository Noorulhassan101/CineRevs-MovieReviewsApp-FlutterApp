import 'package:zenthra/shared/utils/adaptive_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/notifications_repository.dart';
import '../domain/notification_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/auth/data/auth_repository.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('NOTIFICATIONS', style: TextStyle(letterSpacing: 2)),
        actions: [
          TextButton(
            onPressed: () {
              final user = ref.read(authRepositoryProvider).currentUser;
              if (user != null) {
                ref.read(notificationsRepositoryProvider).markAllAsRead(user.uid);
              }
            },
            child: const Text('MARK ALL AS READ', style: TextStyle(fontSize: 10, color: AppColors.primaryAccent)),
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Text('NO NEW ALERTS.', style: TextStyle(color: context.adaptiveWhite24, letterSpacing: 1)),
            );
          }
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) => _NotificationTile(notification: notifications[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  final NotificationItem notification;
  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        if (!notification.isRead) {
          final user = ref.read(authRepositoryProvider).currentUser;
          if (user != null) {
            ref.read(notificationsRepositoryProvider).markAsRead(user.uid, notification.id);
          }
        }
      },
      leading: CircleAvatar(
        backgroundColor: notification.isRead ? context.adaptiveWhite10 : AppColors.primaryAccent.withOpacity(0.2),
        child: Icon(
          _getIcon(notification.type),
          color: notification.isRead ? context.adaptiveWhite24 : AppColors.primaryAccent,
          size: 18,
        ),
      ),
      title: Text(
        '${notification.fromUserName.toUpperCase()} ${_getActionText(notification.type)}',
        style: TextStyle(
          fontSize: 13,
          color: notification.isRead ? context.adaptiveWhite38 : context.adaptiveWhite,
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text(
        _getTimeAgo(notification.createdAt),
        style: TextStyle(fontSize: 10, color: context.adaptiveWhite24),
      ),
      trailing: !notification.isRead 
        ? const CircleAvatar(radius: 4, backgroundColor: AppColors.primaryAccent)
        : null,
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'like': return Icons.favorite;
      case 'comment': return Icons.comment;
      case 'follow': return Icons.person_add;
      default: return Icons.notifications;
    }
  }

  String _getActionText(String type) {
    switch (type) {
      case 'like': return 'LIKED YOUR REVIEW';
      case 'comment': return 'COMMENTED ON YOUR REVIEW';
      case 'follow': return 'STARTED FOLLOWING YOU';
      default: return 'NOTIFIED YOU';
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
