import 'package:trackweaving/controllers/dashboard_controller.dart';
import 'package:trackweaving/controllers/home_controller.dart';
import 'package:trackweaving/controllers/localization_controller.dart';
import 'package:trackweaving/controllers/login_controllers.dart';
import 'package:trackweaving/controllers/machine_controller.dart';
import 'package:trackweaving/controllers/machine_parts_controller.dart';
import 'package:trackweaving/controllers/maintenance_category_controller.dart';
import 'package:trackweaving/controllers/report_controller.dart';
import 'package:trackweaving/controllers/shift_comment_controller.dart';
import 'package:trackweaving/controllers/splash_controller.dart';
import 'package:trackweaving/repository/api_client.dart';
import 'package:trackweaving/repository/dashboard_repo.dart';
import 'package:trackweaving/repository/login_repo.dart';
import 'package:trackweaving/repository/machine_parts_repo.dart';
import 'package:trackweaving/repository/machine_repository.dart';
import 'package:trackweaving/repository/maintenance_repo.dart';
import 'package:trackweaving/repository/report_repository.dart';
import 'package:trackweaving/repository/shift_comment_repository.dart';
import 'package:trackweaving/utils/shared_pref.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  ApiClient apiClient = ApiClient();

  Get.lazyPut(() => Sharedprefs(pref: preferences));

  //repository
  Get.lazyPut(() => LoginRepo(apiClient: apiClient));
  Get.lazyPut(() => DashboardRepo(apiClient: apiClient));
  Get.lazyPut(() => MachineRepository(apiClient: apiClient));
  Get.lazyPut(() => MaintenanceRepo(apiClient, sp: Get.find()));
  Get.lazyPut(
    () => ShiftCommentRepository(apiClient: apiClient, sp: Get.find()),
  );

  Get.lazyPut(() => apiClient);
  Get.lazyPut(() => ReportRepository());
  Get.lazyPut(() => MachinePartsRepo());

  //controllers
  Get.lazyPut(() => LocalizationController(sp: Get.find()));
  Get.lazyPut(
    () => SplashController(sp: Get.find(), dashboardRepo: Get.find()),
  );
  Get.lazyPut(
    () => LoginControllers(
      sp: Get.find<Sharedprefs>(),
      repo: Get.find<LoginRepo>(),
    ),
  );
  Get.lazyPut(() => HomeController(sp: Get.find()));

  Get.lazyPut(
    () => DashBoardController(sp: Get.find(), dashboardRepo: Get.find()),
  );

  Get.lazyPut(() => MachineController(sp: Get.find(), repository: Get.find()));
  Get.lazyPut(
    () => MaintenanceCategoryController(sp: Get.find(), repo: Get.find()),
  );

  Get.lazyPut(() => ShiftCommentController(repository: Get.find()));
  Get.lazyPut(() => ReportController());
  Get.lazyPut(() => MachinePartsController());
}
