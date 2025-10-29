import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trackweaving/controllers/dashboard_controller.dart';
import 'package:trackweaving/models/get_machinelog_model.dart';
import 'package:trackweaving/screens/app_update/app_updates_dialog.dart';
import 'package:trackweaving/screens/dashboard/widgets/dashboard_card.dart';
import 'package:trackweaving/screens/dashboard/widgets/refresh_loading_widget.dart';
import 'package:trackweaving/screens/dashboard/widgets/top_row_widget.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashBoardController dashBoardController = Get.find<DashBoardController>();

  //check for version updates
  checkforVersionUpdate() {
    if (dashBoardController.isUpdateAvailable.value) {
      if (dashBoardController.forceUpdate.value) {
        // Show mandatory update dialog
        Get.dialog(
          barrierDismissible: false,
          PopScope(canPop: false, child: AppUpdatesDialog()),
        );
        return;
      }
      dashBoardController.shouldPromptForUpdate().then((shouldPrompt) {
        log(
          'shouldPrompt: $shouldPrompt and showPopup: ${dashBoardController.showPopup.value}',
        );
        if (shouldPrompt && dashBoardController.showPopup.value) {
          dashBoardController.saveLastUpdatePromptTime(DateTime.now());
          Get.dialog(
            barrierDismissible: true,
            PopScope(canPop: true, child: AppUpdatesDialog()),
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    dashBoardController.getSettings().then((value) {
      dashBoardController.getData();
      dashBoardController.startTimer();
      checkforVersionUpdate();
    });
  }

  @override
  void dispose() {
    super.dispose();
    dashBoardController.stopTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: 52,
          child: Row(
            children: [
              Text('live_tracking'.tr),
              Spacer(),
              Obx(
                () => Text(
                  dashBoardController.currentTimeString.value,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),

        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                dashBoardController.getData();
              },
              icon: dashBoardController.isLoading.value
                  ? RefreshLoadingWidget(
                      isLoading: dashBoardController.isLoading,
                    )
                  : Icon(Icons.refresh),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          Column(
            children: [
              Divider(height: 1, thickness: 0.2),
              SizedBox(height: 8),
              TopRowWidget(),
              SizedBox(height: 8),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    dashBoardController.getData();
                    return Future.delayed(Duration(microseconds: 1));
                  },
                  child: Obx(
                    () => ListView.separated(
                      itemCount: dashBoardController.machineLogList.length,
                      itemBuilder: (context, index) {
                        MachineLog machineLog =
                            dashBoardController.machineLogList[index];
                        return DashboardCard(machineLog: machineLog);
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
