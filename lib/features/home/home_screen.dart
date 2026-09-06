import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/core/constans/storage_key.dart';
import 'package:todoapp/features/home/components/achieved_tasks_widget.dart';
import 'package:todoapp/core/servers/preferences_manager.dart';
import 'package:todoapp/core/widgets/custom_svg_picture.dart';
import 'package:todoapp/features/home/components/high_priority_widget.dart';
import 'package:todoapp/features/home/components/sliver_taskList_widget.dart';
import 'package:todoapp/features/home/home_controller.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/features/add_task/addtask_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (context) => HomeController(),
      child: Consumer<HomeController>(
        builder: (BuildContext context, HomeController value, Widget? child) {
          final controller = context.read<HomeController>();
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
                    controller.loadTask();
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
                              backgroundImage: value.userImagePath == null
                                  ? AssetImage("assets/images/person.png")
                                  : FileImage(File(value.userImagePath!)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Good Evening, ${value.username} ",
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
                          totalTask: value.totalTask,
                          totalDoneTasks: value.totalDoneTasks,
                          percent: value.percent,
                        ),
                        const SizedBox(height: 8),
                        HighPriorityWidget(
                          tasks: value.tasks,
                          onTap: (bool? value, int? index) {
                            controller.doneTask(value, index);
                          },
                          refresh: () {
                            controller.loadTask();
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
                  value.isLoading
                      ? const SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        )
                      : SliverTasklistWidget(
                          tasks: value.tasks,
                          onTap: (bool? value, int? index) {
                            controller.doneTask(value, index);
                          },
                          emptyMessage: "No Data",
                          onDelete: (int id) {
                            controller.deleteTask(id);
                          },
                          onEdit: () {
                            controller.loadTask();
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

