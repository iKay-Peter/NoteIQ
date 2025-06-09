import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notiq/app/theme/app_theme.dart';
import 'package:notiq/app/utils/datetime_extension.dart';
import 'package:notiq/models/task.model.dart';
import 'package:notiq/ui/screens/task_details_screen.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final Function(bool?) onChanged;

  const TaskCard({super.key, required this.task, required this.onChanged});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.task.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    var task = widget.task;
    final isOverdue = task.dueDate?.isOverdue ?? false;
    final isDueToday = task.dueDate?.isDueToday ?? false;
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isOverdue && !task.isCompleted
              ? Colors.red.shade200
              : isDueToday && !task.isCompleted
              ? Apptheme.orange.withOpacity(0.5)
              : Colors.grey.shade200,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailsScreen(taskId: task.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) async {
                    if (value != null) {
                      setState(() => _isChecked = value);
                      widget.onChanged(value);
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                  activeColor: Apptheme.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: isOverdue && !task.isCompleted
                            ? Colors.red.shade700
                            : null,
                      ),
                    ),
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isOverdue && !task.isCompleted
                                ? Icons.warning_rounded
                                : Icons.schedule,
                            size: 16,
                            color: isOverdue && !task.isCompleted
                                ? Colors.red.shade400
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getTimeDisplay(task.dueDate!),
                            style: TextStyle(
                              fontSize: 12,
                              color: isOverdue && !task.isCompleted
                                  ? Colors.red.shade400
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeDisplay(DateTime dueDate) {
    if (dueDate.isOverdue) {
      return 'Overdue - ${DateFormat('MMM d').format(dueDate)}';
    }
    if (dueDate.isDueToday) {
      return 'Due today - ${DateFormat('h:mm a').format(dueDate)}';
    }
    return DateFormat('MMM d, h:mm a').format(dueDate);
  }
}
