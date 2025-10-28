import 'dart:developer';

import 'package:get/get.dart';
import 'package:trackweaving/models/users_list_response.dart';
import 'package:trackweaving/repository/api_exception.dart';
import 'package:trackweaving/repository/users_repository.dart';
import 'package:trackweaving/screens/auth_screens/login_screen.dart';
import 'package:trackweaving/utils/shared_pref.dart';

class UsersController extends GetxController implements GetxService {
  UsersRepository repository = Get.find<UsersRepository>();
  Sharedprefs sp = Get.find<Sharedprefs>();
  RxBool isLoading = false.obs;

  RxList<UserModel> usersList = RxList();

  RxString userId = ''.obs;

  getUserType() {
    log('User Type: ${sp.userType}');
    return sp.userType;
  }

  setUserId() {
    userId.value = sp.currentLoginId;
    log('Current User ID: ${userId.value}');
  }

  // Add methods to fetch, add, update, and delete users as needed.
  getUsersList() async {
    try {
      isLoading.value = true;
      var data = await repository.getUsers();
      usersList.value = data;
    } on ApiException catch (e) {
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
  }

  //create user
  Future<bool> createUser({
    required String fullname,
    required String userName,
    required String password,
    required String email,
    required String mobile,
    required bool isActive,
  }) async {
    try {
      isLoading.value = true;
      var isCreated = await repository.createUser(
        fullname: fullname,
        userName: userName,
        password: password,
        email: email,
        mobile: mobile,
        isActive: isActive,
      );
      if (isCreated) {
        getUsersList(); // Refresh the list after creation
      }
    } on ApiException catch (e) {
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  //update user
  Future<bool> updateUser({
    required String id,
    required String fullname,
    required String userName,
    required String password,
    required String email,
    required String mobile,
    required bool isActive,
  }) async {
    try {
      isLoading.value = true;
      var isCreated = await repository.updateUser(
        id: id,
        fullname: fullname,
        userName: userName,
        password: password,
        email: email,
        mobile: mobile,
        isActive: isActive,
      );
      if (isCreated) {
        getUsersList(); // Refresh the list after creation
      }
    } on ApiException catch (e) {
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  updateOnlyActive({
    required UserModel user,
    required bool isActive,
    required int index,
  }) async {
    try {
      usersList[index].isActive = isActive;
      usersList.refresh();
      var isUpdated = await repository.updateUser(
        id: user.id,
        isActive: isActive,
        fullname: user.fullname,
        userName: user.userName,
      );
      if (isUpdated) {}
    } on ApiException catch (e) {
      log('Error updating user active status: $e');
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {}
  }
}
