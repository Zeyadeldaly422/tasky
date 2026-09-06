import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todoapp/core/constans/storage_key.dart';
import 'package:todoapp/core/servers/preferences_manager.dart';
import 'package:todoapp/models/task_model.dart';

class HomeController extends ChangeNotifier {
  List<TaskModel> tasksList = [];

  String? username = "default";
  String? userImagePath;
  List<TaskModel> tasks = [];
  bool isLoading = false;
  int totalTask = 0;
  int totalDoneTasks = 0;
  double percent = 0;

  HomeController() {
    init();
  }

  init() {
    loadUserName();
    loadTask();
  }

  void loadUserName() async {
    username = PreferencesManager().getString(StorageKey.username) ?? '';
    userImagePath = PreferencesManager().getString('user-image') ?? '';
    notifyListeners();
  }

  void loadTask() async {
    isLoading = true;

    final finalTask = PreferencesManager().getString('tasks');
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      tasks = taskAfterDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();
      calculatePercent();
    }

    isLoading = false;
    notifyListeners();
  }

  void calculatePercent() {
    totalTask = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isDone).length;
    percent = totalTask == 0 ? 0 : totalDoneTasks / totalTask;
    notifyListeners();
  }

  void deleteTask(int? id) async {
    if (id == null) return;

    tasks.removeWhere((task) => task.id == id);
    calculatePercent();

    final updatedTask = tasks.map((element) => element.toJson()).toList();
    await PreferencesManager().setString('tasks', jsonEncode(updatedTask));
    notifyListeners();
  }

  void doneTask(bool? value, int? index) async {
    if (index == null) return;

    tasks[index].isDone = value ?? false;
    calculatePercent();

    final updatedTasks = tasks.map((element) => element.toJson()).toList();
    await PreferencesManager().setString('tasks', jsonEncode(updatedTasks));
    notifyListeners();
  }
}
