import 'package:trackweaving/utils/shared_pref.dart';
import 'package:get/get.dart';

class HomeController extends GetxController implements GetxService {
  final Sharedprefs sp;

  HomeController({required this.sp});

  RxInt selectedNavIndex = 0.obs;

  void changeNavIndex(int i) {
    selectedNavIndex.value = i;
  }

  void showToken() {
    //print('token : ${sp.userToken}');
  }
}
