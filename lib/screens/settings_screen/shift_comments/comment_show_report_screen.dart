import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/main_btn.dart';
import 'package:trackweaving/controllers/shift_comment_controller.dart';
import 'package:trackweaving/models/shift_comment_model.dart';
import 'package:trackweaving/screens/settings_screen/shift_comments/widgets/shift_comment_list_item.dart';
import 'package:trackweaving/utils/app_colors.dart';
import 'package:get/get.dart';

class CommentShowReportScreen extends StatefulWidget {
  const CommentShowReportScreen({super.key});

  @override
  State<CommentShowReportScreen> createState() =>
      _CommentShowReportScreenState();
}

class _CommentShowReportScreenState extends State<CommentShowReportScreen> {
  ShiftCommentController shiftCommentController = Get.find();

  // Map to store a controller for each comment
  final Map<String, TextEditingController> _dayCommentControllers = {};
  final Map<String, TextEditingController> _nightCommentControllers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,

      appBar: AppBar(title: Text('Show Report')),
      body: Column(
        children: [
          Divider(height: 1, thickness: 0.2),
          Obx(
            () => shiftCommentController.shiftCommentList.isEmpty
                ? SizedBox()
                : Expanded(
                    child: ListView.builder(
                      itemCount: shiftCommentController.shiftCommentList.length,
                      itemBuilder: (context, index) {
                        ShiftCommentModel comment =
                            shiftCommentController.shiftCommentList[index];

                        String commentDay = shiftCommentController.getComment(
                          comment.machineId,
                          comment.shiftTime,
                          'day',
                        );

                        String commentNight = shiftCommentController.getComment(
                          comment.machineId,
                          comment.shiftTime,
                          'night',
                        );
                        // Initialize controllers if they don't exist
                        if (!_dayCommentControllers.containsKey(comment.id)) {
                          _dayCommentControllers['${comment.machineId}_day_${comment.shiftTime}'] =
                              TextEditingController(text: commentDay);
                        } else {
                          _dayCommentControllers['${comment.machineId}_day_${comment.shiftTime}']!
                                  .text =
                              commentDay;
                        }
                        if (!_nightCommentControllers.containsKey(comment.id)) {
                          _nightCommentControllers['${comment.machineId}_night_${comment.shiftTime}'] =
                              TextEditingController(text: commentNight);
                        } else {
                          _nightCommentControllers['${comment.machineId}_night_${comment.shiftTime}']!
                                  .text =
                              commentNight;
                        }
                        return ShiftCommentListItem(
                          comment: comment,

                          dayComment:
                              _dayCommentControllers['${comment.machineId}_day_${comment.shiftTime}'],
                          onDayCommentChanged: (value) {
                            shiftCommentController
                                    .shiftCommentList[index]
                                    .dayComment =
                                value;
                          },
                          nightComment:
                              _nightCommentControllers['${comment.machineId}_night_${comment.shiftTime}'],
                          onNightCommentChanged: (value) {
                            shiftCommentController
                                    .shiftCommentList[index]
                                    .nightComment =
                                value;
                          },
                        );
                      },
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                MainBtn(
                  label: 'save'.tr,
                  onTap: () async {
                    List<Map<String, dynamic>> commentsList = [];
                    for (var comment
                        in shiftCommentController.shiftCommentList) {
                      final dayComment =
                          _dayCommentControllers['${comment.machineId}_day_${comment.shiftTime}']
                              ?.text;
                      final nightComment =
                          _nightCommentControllers['${comment.machineId}_night_${comment.shiftTime}']
                              ?.text;

                      // Conditionally build the list based on shift type
                      if (comment.shiftType == 'all' ||
                          comment.shiftType == 'day') {
                        if (dayComment != null && dayComment.isNotEmpty) {
                          commentsList.add({
                            "machineId": comment.machineId,
                            "date": comment.shiftTime,
                            "shift": "day",
                            "comment": dayComment,
                          });
                        }
                      }

                      if (comment.shiftType == 'all' ||
                          comment.shiftType == 'night') {
                        if (nightComment != null && nightComment.isNotEmpty) {
                          commentsList.add({
                            "machineId": comment.machineId,
                            "date": comment.shiftTime,
                            "shift": "night",
                            "comment": nightComment,
                          });
                        }
                      }
                    }

                    // Now you can send `commentsList` to your backend API
                    var payload = {"list": commentsList};

                    await shiftCommentController.updateShiftComment(payload);
                    await shiftCommentController.getComments().then((value) {
                      FocusScope.of(Get.context!).unfocus(
                        disposition: UnfocusDisposition.previouslyFocusedChild,
                      );
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
