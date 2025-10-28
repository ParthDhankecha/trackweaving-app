import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:trackweaving/controllers/users_controller.dart';
import 'package:trackweaving/screens/settings_screen/users/add_update_user_screen.dart';
import 'package:trackweaving/screens/settings_screen/users/widgets/user_card.dart';
import 'package:trackweaving/utils/app_colors.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UsersController controller = Get.find<UsersController>();

  @override
  void initState() {
    super.initState();
    controller.getUsersList();
    controller.setUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,
      appBar: CustomAppbar(title: 'user_list'.tr),
      floatingActionButton: controller.getUserType() == 1
          ? FloatingActionButton(
              backgroundColor: AppColors.mainColor,
              onPressed: () {
                //controller.clearSelections();
                Get.to(() => const AddUpdateUsersScreen());
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      // 4. Use a single main ListView for the entire body content
      body: Column(
        children: [
          Divider(height: 1, thickness: 0.2),
          Expanded(
            child: Obx(() {
              // Show the main loading indicator while initial data is fetched
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemBuilder: (context, index) {
                  final user = controller.usersList[index];

                  return UserCard(
                    user: user,
                    isCurrentUser: controller.userId.value == user.id,
                    onTap: () {
                      Get.to(
                        () =>
                            AddUpdateUsersScreen(userModel: user, index: index),
                      );
                    },
                    onActiveChanged: (bool isActive) {
                      controller.updateOnlyActive(
                        user: user,
                        isActive: isActive,
                        index: index,
                      );
                    },
                  );
                },
                itemCount: controller.usersList.length,
              );
            }),
          ),
        ],
      ),
    );
  }
}
