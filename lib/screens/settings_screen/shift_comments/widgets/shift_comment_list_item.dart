import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:trackweaving/common_widgets/app_text_styles.dart';
import 'package:trackweaving/models/shift_comment_model.dart';
import 'package:trackweaving/utils/app_colors.dart';

class ShiftCommentListItem extends StatelessWidget {
  const ShiftCommentListItem({
    super.key,
    required this.comment,
    this.dayComment,
    this.nightComment,
  });

  final ShiftCommentModel comment;
  final TextEditingController? dayComment;
  final TextEditingController? nightComment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
      child: Card(
        color: AppColors.whiteColor,
        elevation: 2,
        child: Container(
          margin: EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(comment.machineCode, style: bodyStyle),
                  Text(
                    comment.shiftTime,
                    textAlign: TextAlign.start,
                    style: bodyStyle1,
                  ),
                ],
              ),
              SizedBox(height: 12),
              comment.shiftType == 'all'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text('day_shift'.tr),
                        SizedBox(height: 10),

                        TextFormField(
                          controller: dayComment,

                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Comments',
                            hintStyle: TextStyle(fontSize: 14),

                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide(color: Colors.grey),
                            ),

                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                          ),
                        ),
                        SizedBox(height: 14),

                        Text('night_shift'.tr),
                        SizedBox(height: 10),

                        TextFormField(
                          controller: nightComment,
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Comments',
                            hintStyle: TextStyle(fontSize: 14),

                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide(color: Colors.grey),
                            ),

                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.shiftType == 'night'
                              ? 'Night Shift'
                              : 'Day Shift',
                        ),
                        SizedBox(height: 10),

                        TextFormField(
                          controller: comment.shiftType == 'night'
                              ? nightComment
                              : dayComment,
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Comments',
                            hintStyle: TextStyle(fontSize: 14),

                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide(color: Colors.grey),
                            ),

                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
