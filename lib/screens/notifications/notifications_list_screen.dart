import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackweaving/controllers/notifications_controller.dart';
import 'package:trackweaving/screens/notifications/widgets/notification_card.dart';

class NotificationsListScreen extends StatefulWidget {
  const NotificationsListScreen({super.key});

  @override
  State<NotificationsListScreen> createState() =>
      _NotificationsListScreenState();
}

class _NotificationsListScreenState extends State<NotificationsListScreen> {
  final NotificationController notificationController = Get.find();

  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    notificationController.getNotifications(isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Column(
        children: [
          Divider(height: 1, thickness: 0.2),
          SizedBox(height: 1),
          Expanded(
            child: Obx(() {
              if (notificationController.isLoading.value &&
                  notificationController.notificationsList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // if (notificationController.isLoading.value) {
              //   return const Center(child: CircularProgressIndicator());
              // } else if (notificationController.notificationsList.isEmpty) {
              //   return const Center(child: Text('No notifications available.'));
              // } else {
              //   return ListView.builder(
              //     itemCount: notificationController.notificationsList.length,
              //     itemBuilder: (context, index) {
              //       final notification =
              //           notificationController.notificationsList[index];
              //       return NotificationCard(notification: notification);
              //     },
              //   );

              return ListView(
                controller: _scrollController, // Attach the scroll controller
                padding: const EdgeInsets.only(
                  top: 12,
                  bottom: 80,
                ), // Add padding for FAB
                children: [
                  // Machine Group Card

                  // List of machine parts
                  if (notificationController.notificationsList.isEmpty)
                    // Show 'No Data' message if list is empty after loading
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text('No Notifications Found'),
                      ),
                    )
                  else
                    // Use Column or List.generate to build items inside the main ListView
                    ...List.generate(
                      notificationController.notificationsList.length,
                      (index) {
                        final notification =
                            notificationController.notificationsList[index];
                        return NotificationCard(notification: notification);
                      },
                    ),

                  // Pagination Loader (only visible when fetching next page)
                  if (notificationController.isPaginating.value)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),

                  // End of list message
                  if (!notificationController.hasNextPage.value &&
                      notificationController.notificationsList.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text('You have reached the end of the list.'),
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    // Check if the scroll is near the bottom (e.g., within 200 pixels)
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Check if there are more pages AND not currently fetching another page
      if (notificationController.hasNextPage.value &&
          !notificationController.isPaginating.value) {
        // Trigger the next page load
        notificationController.getNotifications();
      }
    }
  }
}
