import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/custom_progress_btn_.dart';
import 'package:trackweaving/common_widgets/main_btn.dart';
import 'package:get/get.dart';
import 'package:trackweaving/common_widgets/show_error_snackbar.dart';
import 'package:trackweaving/controllers/users_controller.dart';
import 'package:trackweaving/models/login_auth_model.dart';
import 'package:trackweaving/models/users_list_response.dart';
import 'package:trackweaving/screens/settings_screen/shift_comments/widgets/shift_dropdown.dart';
import 'package:trackweaving/screens/settings_screen/users/widgets/user_active_switch.dart';
import 'package:trackweaving/screens/settings_screen/users/widgets/user_shift_dropdown.dart';
import 'package:trackweaving/screens/settings_screen/users/widgets/user_type_dropdown.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:trackweaving/utils/app_const.dart';

class AddUpdateUsersScreen extends StatefulWidget {
  final UserModel? userModel;
  final int index;
  const AddUpdateUsersScreen({super.key, this.userModel, this.index = -1});

  @override
  State<AddUpdateUsersScreen> createState() => _AddUpdateUsersScreenState();
}

class _AddUpdateUsersScreenState extends State<AddUpdateUsersScreen> {
  UsersController controller = Get.find<UsersController>();
  TextEditingController userFullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userMobileController = TextEditingController();
  RxBool isActive = false.obs;
  RxBool ispassword = false.obs;

  GlobalKey<FormState> formKey = GlobalKey();

  int currentUserTypeIndex = 0;

  @override
  void initState() {
    super.initState();
    currentUserTypeIndex = controller.getUserType();
    if (widget.userModel != null) {
      userFullNameController.text = widget.userModel?.fullname ?? '';
      userNameController.text = widget.userModel?.userName ?? '';
      userEmailController.text = widget.userModel?.email ?? '';
      userMobileController.text = widget.userModel?.mobile ?? '';
      isActive.value = widget.userModel?.isActive ?? false;
      log('Editing User type: ${widget.userModel?.userType}');
      controller.selectedUserTypeIndex.value =
          widget.userModel?.userType == AppConst.masterUser ? 1 : 0;

      if (widget.userModel?.shift == 'day') {
        controller.changeShiftType(controller.shiftTypeList[1]);
      } else if (widget.userModel?.shift == 'night') {
        controller.changeShiftType(controller.shiftTypeList[2]);
      } else {
        controller.changeShiftType(controller.shiftTypeList.first);
      }
    } else {
      controller.changeShiftType(controller.shiftTypeList.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,

      appBar: AppBar(
        title: Text(
          widget.userModel != null ? 'edit_user'.tr : 'create_user'.tr,
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Divider(height: 1, thickness: 0.2),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildInputField(
                        title: '${'user_full_name'.tr} *',
                        hintText: 'user_full_name'.tr,
                        controller: userFullNameController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Name Field can not Empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      if (currentUserTypeIndex != AppConst.masterUser)
                        Column(
                          children: [
                            Obx(
                              () => controller.userTypes.isEmpty
                                  ? SizedBox.shrink()
                                  : UserTypeDropdown(
                                      title: 'user_type'.tr,
                                      items: controller.userTypes,
                                      onChanged: (value) {
                                        if (value != null) {
                                          log('Selected User Type: $value');
                                          int selectedIndex = controller
                                              .userTypes
                                              .indexOf(value);
                                          if (selectedIndex < 0) {
                                            selectedIndex = 0;
                                          }
                                          controller
                                                  .selectedUserTypeIndex
                                                  .value =
                                              selectedIndex;

                                          log(
                                            'User Role Type: ${controller.getUserRoleType()}',
                                          );
                                        }
                                      },
                                      selectedValue:
                                          controller.userTypes[controller
                                              .selectedUserTypeIndex
                                              .value],
                                    ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),

                      UserShiftDropdown(
                        title: 'shift'.tr,
                        items: controller.shiftTypeList,
                        selectedValue: controller.selectedShiftType.value,
                        onChanged: (value) {
                          controller.changeShiftType(value);
                        },
                      ),
                      SizedBox(height: 10),

                      _buildPhoneField(
                        title: "${'user_name'.tr} *",
                        hintText: 'user_name'.tr,
                        controller: userNameController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'UserName Field can not Empty';
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 10),

                      Obx(
                        () => _buildInputField(
                          title: 'password'.tr,
                          hintText: 'password'.tr,
                          controller: userPasswordController,
                          ispassword: true,
                          showPassword: ispassword.value,

                          onPasswordTap: () {
                            ispassword.value = !ispassword.value;
                          },
                          validator: (String? value) {
                            if (widget.userModel == null &&
                                (value == null || value.isEmpty)) {
                              return 'Password Field can not Empty';
                            }

                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildPhoneField(
                        title: 'mobile'.tr,
                        hintText: 'mobile'.tr,
                        controller: userMobileController,
                        validator: (String? value) {
                          if (value!.isNotEmpty) {
                            if (value.length != 10) {
                              return 'Phone must be 10 Digit Number';
                            }
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      _buildInputField(
                        title: 'email'.tr,
                        hintText: 'email'.tr,
                        controller: userEmailController,
                        inputType: TextInputType.emailAddress,
                        validator: (String? value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => controller.userId.value == widget.userModel?.id
                            ? SizedBox.shrink()
                            : UserActiveSwitch(
                                isActive: isActive.value,
                                onChanged: (value) {
                                  isActive.value = value;
                                },
                              ),
                      ),
                      SizedBox(height: 14),
                      Row(
                        children: [
                          Obx(
                            () => controller.isLoading.value
                                ? CustomProgressBtn()
                                : MainBtn(
                                    label: widget.userModel == null
                                        ? 'save'.tr
                                        : 'update'.tr,
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        onSaveOrUpdate();
                                      }
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSaveOrUpdate() {
    if (controller.selectedShiftType.value.type == 'select') {
      showErrorSnackbar('Please select a valid shift type');
      return;
    }

    int userType = controller
        .getUserRoleType(); // Get user type from controller
    if (widget.userModel == null) {
      // Create new user

      int shiftType = controller.selectedShiftType.value.type == 'day'
          ? AppConst.dayShift
          : AppConst.nightShift; // Get shift type from
      controller
          .createUser(
            fullname: userFullNameController.text.trim(),
            userName: userNameController.text.trim(),
            password: userPasswordController.text.trim(),
            email: userEmailController.text.trim(),
            mobile: userMobileController.text.trim(),
            shiftType: shiftType,
            userType: userType,
            isActive: isActive.value,
          )
          .then((success) {
            log('User creation success: $success');
            if (success) {
              Get.back();
              clearData();
            }
          });
    } else {
      controller
          .updateUser(
            id: widget.userModel?.id ?? '',
            fullname: userFullNameController.text.trim(),
            userName: userNameController.text.trim(),
            password: userPasswordController.text.trim(),
            email: userEmailController.text.trim(),
            mobile: userMobileController.text.trim(),
            isActive: isActive.value,
            userType: userType,
            shiftType: controller.selectedShiftType.value.type == 'day'
                ? AppConst.dayShift
                : AppConst.nightShift,
          )
          .then((success) {
            log('User update success: $success');
            if (success) {
              Get.back();
              clearData();
            }
          });
    }
  }

  void clearData() {
    userFullNameController.clear();
    userNameController.clear();
    userPasswordController.clear();
    userEmailController.clear();
    userMobileController.clear();
    isActive.value = false;
  }

  Widget _buildInputField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String? value) validator,
    Function()? onPasswordTap,
    TextInputType inputType = TextInputType.text,
    bool ispassword = false,
    bool showPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        TextFormField(
          keyboardType: inputType,
          controller: controller,
          validator: validator,
          obscureText: showPassword,

          decoration: InputDecoration(
            // labelText: title,
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffix: ispassword
                ? GestureDetector(
                    onTap: () {
                      onPasswordTap?.call();
                    },
                    child: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String? value) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        TextFormField(
          keyboardType: TextInputType.phone,
          controller: controller,
          validator: validator,
          maxLength: 10,

          decoration: InputDecoration(
            counter: SizedBox.shrink(),
            // labelText: title,
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
