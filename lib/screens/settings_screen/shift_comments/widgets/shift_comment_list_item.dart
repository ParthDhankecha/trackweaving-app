import 'package:flutter/material.dart';
import 'package:trackweaving/common_widgets/app_text_styles.dart';
import 'package:trackweaving/models/shift_comment_model.dart';

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
                        Text('Day Shift'),
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

                        Text('Night Shift'),
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
