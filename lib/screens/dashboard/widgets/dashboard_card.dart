import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/app_text_styles.dart';
import 'package:flutter_texmunimx/models/get_machinelog_model.dart';
import 'package:flutter_texmunimx/screens/dashboard/widgets/stop_table.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';
import 'package:flutter_texmunimx/utils/app_images.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DashboardCard extends StatelessWidget {
  final MachineLog machineLog;
  const DashboardCard({super.key, required this.machineLog});

  @override
  Widget build(BuildContext context) {
    return _buildCard();
  }

  Container _buildCard() {
    return Container(
      margin: EdgeInsets.only(left: 6, right: 6),

      decoration: BoxDecoration(
        border: Border.all(color: AppColors.successColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _machineTitleRow(),

          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                SizedBox(height: 6),
                _currentStopRow(),
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
                          _picksRow(AppImages.imgFabric1, 'set_picks', '45'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            //progress
                            _progressBar(),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.imgClock,
                                  height: 14,
                                  width: 14,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '02:20',
                                  style: bodyStyle.copyWith(
                                    color: AppColors.mainColor,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('duration'.tr, style: bodyStyle1),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.imgPlayBtn,
                                  height: 14,
                                  width: 14,
                                  fit: BoxFit.cover,
                                  color: AppColors.successColor,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '02:20',
                                  style: bodyStyle.copyWith(
                                    color: AppColors.mainColor,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('runtime'.tr, style: bodyStyle1),
                              ],
                            ),
                            SizedBox(height: 6),
                            _actionButtons('oil_change_due', () {}),
                            _actionButtons('greasing_due', () {}),
                            _actionButtons('grease_and_check_shafts', () {}),
                            _actionButtons('check_and_tight_nuts', () {}),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                StopDataTable(stopsData: machineLog.stopsData),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _progressBar() {
    Color progressColor = Colors.yellow;

    if (machineLog.efficiency >= 90) {
      progressColor = Colors.green;
    } else if (machineLog.efficiency > 80) {
      progressColor = AppColors.secondColor;
    } else {
      progressColor = AppColors.errorColor;
    }

    return Row(
      children: [
        Expanded(
          child: LinearPercentIndicator(
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
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.successColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Text(
            machineLog.machineName,
            style: bodyStyle1.copyWith(color: AppColors.whiteColor),
          ),
          Spacer(),
          Text(
            'Signature',
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
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blackColor, width: 0.75),
      ),
      child: Row(
        children: [
          Text('current_stop'.tr, style: bodyStyle1.copyWith()),
          SizedBox(width: 100),
          Text(
            ' - ',
            style: bodyStyle1.copyWith(
              color: AppColors.errorColor,
              fontSize: 14,
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
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blackColor, width: 0.75),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 24,
            width: 24,
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
                fontSize: 14,
                color: AppColors.mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons(String title, Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 4),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.blackColor, width: 0.75),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title.tr,
              textAlign: TextAlign.center,
              style: bodyStyle.copyWith(
                color: AppColors.errorColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
