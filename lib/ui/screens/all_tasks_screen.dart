import 'package:flutter/material.dart';
import 'package:notiq/app/theme/app_theme.dart';
import 'package:notiq/data/providers/task_provider.dart';
import 'package:notiq/models/task.model.dart';
import 'package:notiq/ui/widgets/task_card.dart';
import 'package:provider/provider.dart';

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({Key? key}) : super(key: key);

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  // Track which groups are expanded
  final Map<String, bool> _isExpanded = {
    'Tasks without due date': true,
    'Upcoming Tasks': true,
    'Overdue Tasks': true,
    'Completed Tasks': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 237),
      appBar: AppBar(
        title: const Text('All Tasks'),
        surfaceTintColor: const Color.fromARGB(255, 255, 249, 237),
        backgroundColor: const Color.fromARGB(255, 255, 249, 237),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasks = taskProvider.tasks;

          // Group tasks
          final completedTasks = tasks
              .where((task) => task.isCompleted)
              .toList();
          final incompleteTasks = tasks
              .where((task) => !task.isCompleted)
              .toList();

          final now = DateTime.now();
          final tasksWithoutDates = incompleteTasks
              .where((task) => task.dueDate == null)
              .toList();
          final futureTasks = incompleteTasks
              .where(
                (task) => task.dueDate != null && task.dueDate!.isAfter(now),
              )
              .toList();
          final pastTasks = incompleteTasks
              .where(
                (task) => task.dueDate != null && task.dueDate!.isBefore(now),
              )
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (tasksWithoutDates.isNotEmpty) ...[
                _buildTaskGroup(
                  "Tasks without due date",
                  tasksWithoutDates,
                  taskProvider,
                ),
                const SizedBox(height: 20),
              ],
              if (futureTasks.isNotEmpty) ...[
                _buildTaskGroup("Upcoming Tasks", futureTasks, taskProvider),
                const SizedBox(height: 20),
              ],
              if (pastTasks.isNotEmpty) ...[
                _buildTaskGroup("Overdue Tasks", pastTasks, taskProvider),
                const SizedBox(height: 20),
              ],
              if (completedTasks.isNotEmpty) ...[
                _buildTaskGroup(
                  "Completed Tasks",
                  completedTasks,
                  taskProvider,
                ),
              ],
              if (tasks.isEmpty)
                const Center(
                  child: Text(
                    "No tasks found",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTaskGroup(
    String title,
    List<Task> tasks,
    TaskProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded[title] = !(_isExpanded[title] ?? true);
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: title == "Overdue Tasks" ? Apptheme.lightRed : null,
                  ),
                ),
                const Spacer(),
                Text(
                  '${tasks.length} ${tasks.length == 1 ? 'task' : 'tasks'}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Icon(
                  _isExpanded[title] ?? true
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded[title] ?? true) ...[
          const SizedBox(height: 8),
          ...tasks
              .map(
                (task) => TaskCard(
                  key: ValueKey(task.id),
                  title: task.title,
                  time: task.dueDate != null
                      ? task.dueDate!.toIso8601String().substring(11, 16)
                      : "No time set",
                  isCompleted: task.isCompleted,
                  onChanged: (bool? value) async {
                    if (value != null) {
                      await provider.updateTaskCompletion(task.id, value);
                    }
                  },
                ),
              )
              .toList(),
        ],
      ],
    );
  }
}
