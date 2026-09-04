import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todoapp/Widgets/taskList_Widget.dart';
import 'package:todoapp/core/servers/preferences_manager.dart';
import 'package:todoapp/models/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<TaskModel> todoTasks = [];
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

    final finalTask = PreferencesManager().getString('tasks');

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        todoTasks = taskAfterDecode
            .map((element) => TaskModel.fromJson(element))
            .where((element) => element.isDone == false)
            .toList();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  // void _deleteTask(int? id) async {
  //   if (id == null) return;
  //   final allData = PreferencesManager().getString('tasks');
  //   if (allData != null) {
  //     List<TaskModel> allDataList = (jsonDecode(allData) as List)
  //         .map((element) => TaskModel.fromJson(element))
  //         .toList();

  //     allDataList.removeWhere((task) => task.id == id);

  //     await PreferencesManager().setString(
  //       'tasks',
  //       jsonEncode(allDataList.map((e) => e.toJson()).toList()),
  //     );
  //     _loadTask();
  //   }
  // }
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
        todoTasks.removeWhere((task) => task.id == id);
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
            'To Do Tasks',
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
                    tasks: todoTasks,
                    emptyMessage: "No Task found",
                    onDelete: _deleteTask,
                    onTap: (bool? value, int? index) async {
                      if (index == null) return;
                      setState(() {
                        todoTasks[index].isDone = value ?? false;
                      });

                      final allData = PreferencesManager().getString('tasks');

                      if (allData != null) {
                        List<TaskModel> allDataList =
                            (jsonDecode(allData) as List)
                                .map((element) => TaskModel.fromJson(element))
                                .toList();

                        final newIndex = allDataList.indexWhere(
                          (e) => e.id == todoTasks[index].id,
                        );

                        if (newIndex != -1) {
                          allDataList[newIndex] = todoTasks[index];

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
