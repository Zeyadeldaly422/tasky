import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todoapp/Widgets/Achieved_tasks_widget.dart';
import 'package:todoapp/core/servers/preferences_manager.dart';
import 'package:todoapp/core/widgets/custom_svg_picture.dart';
import 'package:todoapp/widgets/high_Priority_widget.dart';
import 'package:todoapp/Widgets/sliver_taskList_Widget.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/screens/AddTask_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username = "default";
  String? userImagePath;
  List<TaskModel> tasks = [];
  bool isLoading = false;
  int totalTask = 0;
  int totalDoneTasks = 0;
  double percent = 0;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadTask();
  }

  void _loadUserName() async {
    setState(() {
      username = PreferencesManager().getString('username');
      userImagePath = PreferencesManager().getString('user-image') ?? '';
    });
  }

  void _loadTask() async {
    setState(() {
      isLoading = true;
    });

    final finalTask = PreferencesManager().getString('tasks');
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        tasks = taskAfterDecode
            .map((element) => TaskModel.fromJson(element))
            .toList();
        _calculatePercent();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void _calculatePercent() {
    totalTask = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isDone).length;
    percent = totalTask == 0 ? 0 : totalDoneTasks / totalTask;
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
    setState(() {
      tasks.removeWhere((task) => task.id == id);
      _calculatePercent();
    });

    final updatedTask = tasks.map((element) => element.toJson()).toList();
    await PreferencesManager().setString('tasks', jsonEncode(updatedTask));
  }

  void _doneTask(bool? value, int? index) async {
    if (index == null) return;
    setState(() {
      tasks[index].isDone = value ?? false;
      _calculatePercent();
    });
    final updatedTasks = tasks.map((element) => element.toJson()).toList();
    await PreferencesManager().setString('tasks', jsonEncode(updatedTasks));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 44,
        child: FloatingActionButton.extended(
          onPressed: () async {
            final bool? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const AddTask();
                },
              ),
            );
            if (result != null && result) {
              _loadTask();
            }
          },
          icon: const Icon(Icons.add),
          label: const Text("Add New Task"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: userImagePath == null
                            ? AssetImage("assets/images/person.png")
                            : FileImage(File(userImagePath!)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Good Evening, $username ",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              "One task at a time. One step closer.",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Yuhuu ,Your work Is ",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Row(
                    children: [
                      Text(
                        "almost done !  ",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const CustomSvgPicture(
                        path: "assets/images/wavinghand.svg",
                        withcolorfilter: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AchievedTasksWidget(
                    totalTask: totalTask,
                    totalDoneTasks: totalDoneTasks,
                    percent: percent,
                  ),
                  const SizedBox(height: 8),
                  HighPriorityWidget(
                    tasks: tasks,
                    onTap: (bool? value, int? index) {
                      _doneTask(value, index);
                    },
                    refresh: () {
                      _loadTask();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 16),
                    child: Text(
                      "My Tasks",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                : SliverTasklistWidget(
                    tasks: tasks,
                    onTap: (bool? value, int? index) {
                      _doneTask(value, index);
                    },
                    emptyMessage: "No Data",
                    onDelete: (int id) {
                      _deleteTask(id);
                    },
                    onEdit: () {
                      _loadTask();
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
