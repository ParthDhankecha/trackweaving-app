import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/controllers/home_controller.dart';
import 'package:flutter_texmunimx/utils/app_colors.dart';
import 'package:flutter_texmunimx/utils/app_images.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.find();

  @override
  void initState() {
    super.initState();
    homeController.showToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Column(children: [_buildDashboardCard()]),
    );
  }

  _buildDashboardCard() {
    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(
              0.5,
            ), // Color of the shadow with opacity
            spreadRadius: 5, // How much the shadow spreads
            blurRadius: 7, // How blurry the shadow is
            offset: Offset(0, 3), // Offset of the shadow (x, y)
          ),
        ],
      ),
      child: Column(
        children: [
          //system name
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.mainColor.withAlpha(100),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'System Name:',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '[Name]',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mainColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Stop:',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '--',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14),
                //progress indications
                Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 26,
                        onPercentValue: (value) {},
                        percent: 0.60,
                        center: Text(
                          '60%',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        progressColor: Colors.green,
                        backgroundColor: Colors.grey[300],
                        barRadius: Radius.circular(14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                //duration and runtime
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRowWithIcon(
                        icon: Icons.timer_outlined,
                        title: 'Duration ',
                        value: '1 : 59',
                      ),

                      _buildRowWithIcon(
                        icon: Icons.play_arrow,
                        title: 'Runtime ',
                        value: '1 : 56',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14),
              ],
            ),
          ),
          Divider(),
          //list of data picks . speed and etc.,
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildRowWithIcon2(
                        img: AppImages.imgSpeedometer,
                        title: 'Picks : ',
                        value: '43791',
                      ),
                      SizedBox(height: 8),
                      _buildRowWithIcon2(
                        img: AppImages.imgSpeedometer,
                        title: 'Speed : ',
                        value: '320',
                      ),
                      SizedBox(height: 8),
                      _buildRowWithIcon2(
                        img: AppImages.imgSpeedometer,
                        title: 'Mtrs : ',
                        value: '7.63',
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                Container(height: 100, child: VerticalDivider(width: 1)),
                SizedBox(width: 12),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildRowWithIcon2(
                        img: AppImages.imgSpeedometer,
                        title: 'Stops:',
                        value: '43791',
                      ),
                      SizedBox(height: 8),
                      _buildRowWithIcon2(
                        img: AppImages.imgSpeedometer,
                        title: 'Beam Left:',
                        value: '45000',
                      ),
                      SizedBox(height: 8),
                      _buildRowWithIcon2(
                        img: AppImages.imgSpeedometer,
                        title: 'Set Picks:',
                        value: '7.63',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildRowWithIcon({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.mainColor.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.mainColor),
        ),
        SizedBox(width: 8),
        Text(
          '$title: ',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.mainColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  //for pick,speed and etc
  Widget _buildRowWithIcon2({
    required String img,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 34,
              width: 34,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.mainColor.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(img, color: AppColors.mainColor),
            ),
            SizedBox(width: 8),

            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.mainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
