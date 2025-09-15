import 'package:flutter_texmunimx/controllers/dashboard_controller.dart';
import 'package:flutter_texmunimx/controllers/home_controller.dart';
import 'package:flutter_texmunimx/controllers/localization_controller.dart';
import 'package:flutter_texmunimx/controllers/login_controllers.dart';
import 'package:flutter_texmunimx/controllers/settings_controller.dart';
import 'package:flutter_texmunimx/controllers/splash_controller.dart';
import 'package:flutter_texmunimx/repository/api_client.dart';
import 'package:flutter_texmunimx/repository/dashboard_repo.dart';
import 'package:flutter_texmunimx/repository/login_repo.dart';
import 'package:flutter_texmunimx/repository/settings_repository.dart';
import 'package:flutter_texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  ApiClient apiClient = ApiClient();

  Get.lazyPut(() => Sharedprefs(pref: preferences));

  //repository
  Get.lazyPut(() => LoginRepo(apiClient: apiClient));
  Get.lazyPut(() => DashboardRepo(apiClient: apiClient));
  Get.lazyPut(() => SettingsRepository(apiClient: apiClient));

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

  Get.lazyPut(() => SettingsController(sp: Get.find(), repository: Get.find()));
}
