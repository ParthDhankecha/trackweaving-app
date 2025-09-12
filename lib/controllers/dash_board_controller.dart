import 'package:flutter_texmunimx/repository/dashboard_repo.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';

class DashBoardController extends GetxController implements GetxService {
  final Sharedprefs sp;
  final DashboardRepo dashboardRepo;

  DashBoardController({required this.sp, required this.dashboardRepo});
}
