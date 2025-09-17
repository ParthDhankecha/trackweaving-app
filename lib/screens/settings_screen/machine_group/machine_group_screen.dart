import 'package:flutter/material.dart';
import 'package:flutter_texmunimx/common_widgets/app_text_styles.dart';
import 'package:flutter_texmunimx/common_widgets/my_text_widget.dart';
import 'package:flutter_texmunimx/controllers/machine_controller.dart';
import 'package:flutter_texmunimx/models/machine_group_response_model.dart';
import 'package:flutter_texmunimx/screens/settings_screen/machine_group/create_machine_group.dart';
import 'package:flutter_texmunimx/screens/settings_screen/machine_group/machin_group_card.dart';
import 'package:get/get.dart';

class MachineGroupScreen extends StatefulWidget {
  const MachineGroupScreen({super.key});

  @override
  State<MachineGroupScreen> createState() => _MachineGroupScreenState();
}

class _MachineGroupScreenState extends State<MachineGroupScreen> {
  MachineController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('machine_group'.tr)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => CreateMachineGroup(
              onSave: (String name) {
                controller.createMachineGroup(name);
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          //machine group card
          Container(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: Colors.grey, width: 0.75),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.only(left: 10, right: 10),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextWidget(text: 'sr_no', textStyle: bodyStyle1),
                  ),
                  Expanded(
                    flex: 4,
                    child: MyTextWidget(
                      textAlign: TextAlign.left,
                      text: 'group_name',
                      textStyle: bodyStyle1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.machineGroupList.length,
                      itemBuilder: (context, index) {
                        MachineGroup machineGroup =
                            controller.machineGroupList[index];
                        controller.setSelectedMachineId(machineGroup.id);
                        return MachineGroupCard(
                          machineGroup: machineGroup,
                          index: index,
                          onEdit: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => CreateMachineGroup(
                                initialName: machineGroup.groupName,
                                onSave: (String name) {
                                  controller.updateMachineGroup(name);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
