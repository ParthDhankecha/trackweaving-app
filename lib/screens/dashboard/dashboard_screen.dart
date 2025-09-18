import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/controllers/dashboard_controller.dart';
import 'package:flutter_texmunimx/models/get_machinelog_model.dart';
import 'package:flutter_texmunimx/screens/dashboard/widgets/dashboard_card.dart';
import 'package:flutter_texmunimx/screens/dashboard/widgets/refresh_loading_widget.dart';
import 'package:flutter_texmunimx/screens/dashboard/widgets/tab_widget.dart';
import 'package:flutter_texmunimx/screens/dashboard/widgets/top_row_widget.dart';
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
    dashBoardController.getSettings().then((value) {
      dashBoardController.getData();
      dashBoardController.startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('live_tracking'.tr),
        scrolledUnderElevation: 1,
        elevation: 6,
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
              Container(
                color: Colors.deepPurple[50],
                child: Column(children: [TopRowWidget(), SizedBox(height: 8)]),
              ),
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

          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [TabWidget()],
            ),
          ),
        ],
      ),
    );
  }
}
