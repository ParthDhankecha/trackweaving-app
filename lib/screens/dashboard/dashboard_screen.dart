import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/show_error_snackbar.dart';
import 'package:trackweaving/controllers/dashboard_controller.dart';
import 'package:trackweaving/models/get_machinelog_model.dart';
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

  @override
  void initState() {
    super.initState();

    print('Init state called');
    dashBoardController.getSettings().then((value) {
      dashBoardController.getData();
      dashBoardController.startTimer();
    });
  }

  @override
  void dispose() {
    super.dispose();
    print('Dispose called');
    dashBoardController.stopTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('live_tracking'.tr),
        scrolledUnderElevation: 1,

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
              Column(children: [TopRowWidget(), SizedBox(height: 8)]),
              SizedBox(height: 10),
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
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Positioned(
          //   bottom: 8,
          //   left: 0,
          //   right: 0,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [TabWidget()],
          //   ),
          // ),
        ],
      ),
    );
  }
}
