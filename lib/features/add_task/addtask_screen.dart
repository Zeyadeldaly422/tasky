import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todoapp/core/servers/preferences_manager.dart';
import 'package:todoapp/core/widgets/custom_text_form_field.dart';
import 'package:todoapp/models/task_model.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();
  bool isHighpriority = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Task")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextTormField(
                          title: "Task Name",
                          controller: taskNameController,
                          hintText: 'Finish UI design for login screen',
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return "please Enter Your task Name";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        CustomTextTormField(
                          title: "Task Description",
                          controller: taskDescriptionController,
                          maxLines: 5,
                          hintText:
                              'Finish onboarding UI and hand off to devs by Thursday.',
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "High Priority  ",
                              style:Theme.of(context).textTheme.titleMedium,
                            ),
                            Switch(
                              value: isHighpriority,
                              onChanged: (bool value) {
                                setState(() {
                                  isHighpriority = value;
                                });
                              },
                              // activeTrackColor: Color(0xFF15B86C),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_key.currentState?.validate() ?? false) {
                      final taskJson = PreferencesManager().getString("tasks");

                      List<dynamic> listTasks = [];
                      if (taskJson != null) {
                        listTasks = jsonDecode(taskJson);
                      }

                      TaskModel model = TaskModel(
                        id: listTasks.length + 1,
                        taskName: taskNameController.text,
                        taskDescription: taskDescriptionController.text,
                        isHighpriority: isHighpriority,
                      );

                      listTasks.add(model.toJson());
                      final taskEncode = jsonEncode(listTasks);

                      await PreferencesManager().setString("tasks", taskEncode);
                      Navigator.of(context).pop(true);
                    }
                  },
                  label: Text("Add Task"),
                  icon: Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 40),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
