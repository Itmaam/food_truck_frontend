import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/api/app_api.dart';
import 'package:food_truck_finder_user_app/api/models/notification.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<NotificationModel>> _notificationsFuture;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _fetchNotifications();
  }

  Future<List<NotificationModel>> _fetchNotifications() async {
    try {
      final response = await AppApi.notificationApi.getNotifications();
      setState(() => _unreadCount = response['unread_count']);
      return response['notifications'];
    } catch (e, s) {
      print(s);
      //throw Exception('Failed to load notifications');
      return [];
    }
  }

  Future<void> _markAsRead(String id) async {
    try {
      // await AppApi.notificationApi.markAsRead(id);
      setState(() => _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to mark notification as read')),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      //  await AppApi.notificationApi.markAllAsRead();
      setState(() => _unreadCount = 0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to mark all notifications as read'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(S.of(context).notifications),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                S.of(context).markAllRead,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
        ],
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.data!.isEmpty) {
            return Center(child: Text(S.of(context).noNotifications));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final notification = snapshot.data![index];
              return NotificationItem(
                notification: notification,
                onTap: () => _markAsRead(notification.id.toString()),
              );
            },
          );
        },
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color:
          notification.readAt == null
              ? Theme.of(context).colorScheme.surfaceVariant
              : null,
      child: ListTile(
        leading: const Icon(Icons.notifications),
        title: Text(notification.data['title'] ?? 'Notification'),
        subtitle: Text(notification.data['body'] ?? ''),
        trailing: Text(
          notification.createdAt.toString(),
          style: Theme.of(context).textTheme.labelSmall,
        ),
        onTap: onTap,
      ),
    );
  }
}
