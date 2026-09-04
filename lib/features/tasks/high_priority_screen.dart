import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todoapp/Widgets/taskList_Widget.dart';
import 'package:todoapp/core/servers/preferences_manager.dart';
import 'package:todoapp/models/task_model.dart';

class HighPriorityScreen extends StatefulWidget {
  const HighPriorityScreen({super.key});

  @override
  State<HighPriorityScreen> createState() => _HighPriorityScreenState();
}

class _HighPriorityScreenState extends State<HighPriorityScreen> {
  List<TaskModel> highPriorityTasks = [];
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
        highPriorityTasks = taskAfterDecode
            .map((element) => TaskModel.fromJson(element))
            .where((element) => element.isHighpriority)
            .toList()
            .reversed
            .toList();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  // void _deleteTask(int? id) async {
  //   if (id == null) return;
  //   final finalTask = PreferencesManager().getString('tasks');
  //   if (finalTask!= null) {
  //     List<TaskModel> allDataList = (jsonDecode(finalTask) as List)
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
        highPriorityTasks.removeWhere((task) => task.id == id);
      });

      final updatedTask = tasks.map((element) => element.toJson()).toList();
      await PreferencesManager().setString('tasks', jsonEncode(updatedTask));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("High Priority Tasks")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : TasklistWidget(
                tasks: highPriorityTasks,
                emptyMessage: "No Task found",
                onDelete: _deleteTask,
                onTap: (bool? value, int? index) async {
                  if (index == null) return;
                  setState(() {
                    highPriorityTasks[index].isDone = value ?? false;
                  });

                  final allData = PreferencesManager().getString('tasks');

                  if (allData != null) {
                    List<TaskModel> allDataList = (jsonDecode(allData) as List)
                        .map((element) => TaskModel.fromJson(element))
                        .toList();

                    final newIndex = allDataList.indexWhere(
                      (e) => e.id == highPriorityTasks[index].id,
                    );

                    if (newIndex != -1) {
                      allDataList[newIndex] = highPriorityTasks[index];

                      await PreferencesManager().setString(
                        'tasks',
                        jsonEncode(allDataList.map((e) => e.toJson()).toList()),
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
    );
  }
}
