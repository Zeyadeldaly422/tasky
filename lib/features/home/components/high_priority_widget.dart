import 'package:flutter/material.dart';
import 'package:todoapp/core/theme/theme_controller.dart';
import 'package:todoapp/core/widgets/custom_checkbox.dart';
import 'package:todoapp/core/widgets/custom_svg_picture.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/features/tasks/high_priority_screen.dart';

class HighPriorityWidget extends StatelessWidget {
  const HighPriorityWidget({
    super.key,
    required this.onTap,
    required this.tasks,
    required this.refresh,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "High Priority Tasks",
                    style: TextStyle(color: Color(0xff15B86C), fontSize: 14),
                  ),
                ),
                ...tasks.reversed.where((e) => e.isHighpriority).take(4).map((
                  element,
                ) {
                  return Row(
                    children: [
                      Customcheckbox(
                        value: element.isDone,
                        onChanged: (bool? value) {
                          final index = tasks.indexWhere(
                            (e) => e.id == element.id,
                          );
                          onTap(value, index);
                        },
                      ),
                      Flexible(
                        child: Text(
                          element.taskName,
                          style: element.isDone
                              ? Theme.of(context).textTheme.titleLarge
                              : Theme.of(context).textTheme.titleMedium,

                          maxLines: 1,
                        ),
                      ),
                      if (element.taskDescription.isNotEmpty)
                        Text(
                          element.taskDescription,
                          style: TextStyle(
                            color: Color(0xffC6C6C6),
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HighPriorityScreen();
                  },
                ),
              );
              refresh();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 48,
                height: 56,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ThemeController.isDark()
                        ? Color(0xFF6E6E6E)
                        : Color(0xFFD1DAD6),
                  ),
                ),
                child: CustomSvgPicture(
                  path: "assets/images/arrowhome.svg",
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
