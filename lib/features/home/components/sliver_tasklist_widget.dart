import 'package:flutter/material.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/widgets/task_item_widget.dart';

class SliverTasklistWidget extends StatelessWidget {
  const SliverTasklistWidget({
    super.key,
    required this.tasks,
    required this.onTap,
    required this.emptyMessage,
    required this.onDelete,
    required this.onEdit,
  });

  final List<TaskModel> tasks;
  final void Function(bool? value, int? index) onTap;
  final void Function(int id) onDelete;
  final void Function() onEdit;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? SliverToBoxAdapter(
            child: Center(
              child: Text(
                emptyMessage,
                style: const TextStyle(color: Color(0xffFFFCFC), fontSize: 24),
              ),
            ),
          )
        : SliverPadding(
            padding: const EdgeInsets.only(bottom: 80),
            sliver: SliverList.separated(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskItemWidget(
                  model: tasks[index],
                  onChanged: (bool? value) => onTap(value, index),
                  onDelete: onDelete, onEdit: (){onEdit();},
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
            ),
          );
  }
}
