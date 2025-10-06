import 'package:blinker/blinker.dart';
import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/app_text_styles.dart';
import 'package:trackweaving/controllers/dashboard_controller.dart';
import 'package:trackweaving/models/get_machinelog_model.dart';
import 'package:trackweaving/screens/dashboard/widgets/stop_table2.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:trackweaving/utils/app_images.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DashboardCard extends StatelessWidget {
  final MachineLog machineLog;
  DashboardCard({super.key, required this.machineLog});

  final DashBoardController controller = Get.find<DashBoardController>();

  @override
  Widget build(BuildContext context) {
    return _buildCard();
  }

  Container _buildCard() {
    return Container(
      margin: EdgeInsets.only(left: 6, right: 6),

      decoration: BoxDecoration(
        border: Border.all(
          color: machineLog.currentStop == 0
              ? AppColors.successColor
              : Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _machineTitleRow(),

          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              children: [
                SizedBox(height: 4),
                _currentStopRow(),
                SizedBox(height: 2),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _picksRow(
                            AppImages.imgFabric1,
                            'picks',
                            '${machineLog.picks}',
                          ),
                          _picksRow(
                            AppImages.imgSpeedometer,
                            'speed',
                            '${machineLog.speed}',
                          ),
                          _picksRow(
                            AppImages.imgFabricRoll,
                            'mtrs',
                            '${machineLog.pieceLengthM}',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        children: [
                          _picksRow(
                            AppImages.imgStopNtn,
                            'stops',
                            '${machineLog.stops}',
                          ),
                          _picksRow(
                            AppImages.imgYarn,
                            'beam_left',
                            '${machineLog.beamLeft}',
                            isRotated: true,
                          ),
                          _picksRow(
                            AppImages.imgFabric1,
                            'set_picks',
                            '${machineLog.setPicks}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                _progressBar(),
                SizedBox(height: 2),
                StopDataTable2(stopsData: machineLog.stopsData),
                SizedBox(height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _progressBar() {
    Color progressColor = Colors.yellow;

    if (machineLog.efficiency >= controller.efficiencyGoodPer) {
      progressColor = Colors.green;
    } else if (machineLog.efficiency > controller.efficiencyAveragePer) {
      progressColor = AppColors.secondColor;
    } else {
      progressColor = AppColors.errorColor;
    }

    return Row(
      children: [
        Expanded(
          child: LinearPercentIndicator(
            padding: EdgeInsets.symmetric(horizontal: 8),
            percent: machineLog.efficiency / 100,
            progressColor: progressColor,
            lineHeight: 20,
            barRadius: Radius.circular(20),
            center: Text(
              '${machineLog.efficiency}%',
              style: bodyStyle1.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _machineTitleRow() {
    return Container(
      padding: EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
      decoration: BoxDecoration(
        color: machineLog.currentStop == 0
            ? AppColors.successColor
            : Colors.grey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        border: Border.all(
          width: 2,
          color: machineLog.currentStop == 0
              ? AppColors.successColor
              : Colors.grey,
        ),
      ),
      child: Row(
        children: [
          Text(
            machineLog.machineCode,
            style: bodyStyle1.copyWith(color: AppColors.whiteColor),
          ),
          Spacer(),
          Text(
            machineLog.machineName.capitalizeFirst!,
            style: bodyStyle1.copyWith(color: AppColors.whiteColor),
          ),
          Spacer(),
          Icon(Icons.play_arrow_outlined, color: Colors.white, size: 16),
          SizedBox(width: 6),
          Text(
            machineLog.totalDuration,
            style: bodyStyle1.copyWith(color: AppColors.whiteColor),
          ),
        ],
      ),
    );
  }

  Widget _currentStopRow() {
    return machineLog.currentStop != 0
        ? Stack(
            children: [
              Blinker.fade(
                startColor: Colors.red[200],
                endColor: Colors.red[50],
                duration: Duration(seconds: 1),

                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.blackColor),
                    color: Colors.red,
                  ),
                  child: Row(
                    children: [
                      Text('current_stop'.tr, style: bodyStyle1.copyWith()),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.blackColor, width: 0),
                ),
                child: Row(
                  children: [
                    Text(
                      'current_stop'.tr,
                      style: bodyStyle1.copyWith(color: Colors.black),
                    ),
                    SizedBox(width: 100),
                    Text(
                      machineLog.stopReason,
                      style: bodyStyle1.copyWith(
                        color: AppColors.blackColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.blackColor, width: 0.75),
            ),
            child: Row(
              children: [
                Text('current_stop'.tr, style: bodyStyle1.copyWith()),
                SizedBox(width: 100),
                Text(
                  machineLog.stopReason,
                  style: bodyStyle1.copyWith(
                    color: AppColors.errorColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
  }

  Widget _picksRow(
    String image,
    String title,
    String value, {
    bool isRotated = false,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blackColor, width: 0.75),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 14,
            width: 14,
            child: isRotated
                ? RotatedBox(
                    quarterTurns: 1,
                    child: Image.asset(image, fit: BoxFit.cover),
                  )
                : Image.asset(image, fit: BoxFit.cover),
          ),
          SizedBox(width: 6),

          Expanded(
            child: Text(
              title.tr,
              style: bodyStyle1,
              textAlign: TextAlign.start,
            ),
          ),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: bodyStyle1.copyWith(
                fontSize: 12,
                color: AppColors.mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
