import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todoapp/core/components/tasklist_widget.dart';
import 'package:todoapp/core/servers/preferences_manager.dart';
import 'package:todoapp/models/task_model.dart';

class CompletedTasks extends StatefulWidget {
  const CompletedTasks({super.key});

  @override
  State<CompletedTasks> createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasks> {
  List<TaskModel> completedTask = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  void _loadTask() async {
    setState(() {
      isLoading = true;
    });

    final finalTask = PreferencesManager().getString("tasks");

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        completedTask = taskAfterDecode
            .map((element) => TaskModel.fromJson(element))
            .where((element) => element.isDone)
            .toList();
      });
    }

    setState(() {
      isLoading = false;
    });
  }
  void _deleteTask(int? id) async {
    if (id == null) return;

    final finalTask = PreferencesManager().getString('tasks');
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      final tasks = taskAfterDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();
      tasks.removeWhere((e) => e.id == id);

      setState(() {
        completedTask.removeWhere((task) => task.id == id);
      });

      final updatedTask = tasks.map((element) => element.toJson()).toList();
      await PreferencesManager().setString('tasks', jsonEncode(updatedTask));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            'Completed Tasks',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : TasklistWidget(
                    tasks: completedTask,
                    emptyMessage: "No Task found",
                    onDelete: _deleteTask,
                    onTap: (bool? value, int? index) async {
                      if (index == null) return;

                      setState(() {
                        completedTask[index].isDone = value ?? false;
                      });

                      final allData = PreferencesManager().getString('tasks');

                      if (allData != null) {
                        List<TaskModel> allDataList =
                            (jsonDecode(allData) as List)
                                .map((element) => TaskModel.fromJson(element))
                                .toList();

                        final newIndex = allDataList.indexWhere(
                          (e) => e.id == completedTask[index].id,
                        );

                        if (newIndex != -1) {
                          allDataList[newIndex] = completedTask[index];

                          await PreferencesManager().setString(
                            'tasks',
                            jsonEncode(
                              allDataList.map((e) => e.toJson()).toList(),
                            ),
                          );

                          _loadTask();
                        }
                      }
                    },
                    onEdit: () {
                      _loadTask();
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
