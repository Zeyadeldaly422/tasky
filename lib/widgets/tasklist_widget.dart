import 'package:flutter/material.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/widgets/task_item_widget.dart';

class TasklistWidget extends StatelessWidget {
  const TasklistWidget({
    super.key,
    required this.tasks,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
    required this.emptyMessage,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;
  final Function(int?) onDelete;
  final Function() onEdit;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
            child: Text(
              emptyMessage,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          )
        : ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: tasks.length,
            padding: EdgeInsets.only(bottom: 60),
            separatorBuilder: (context, index) {
              return SizedBox(height: 8);
            },
            itemBuilder: (context, index) {
              return TaskItemWidget(
                model: tasks[index],
                onChanged: (bool? value) {
                  onTap(value, index);
                },
                onDelete: (int? id) {
                  onDelete(id);
                },
                onEdit: () {
                  onEdit();
                },
              );
            },
          );
  }
}
