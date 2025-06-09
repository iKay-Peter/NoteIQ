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
  final Map<String, bool> _isExpanded = {
    'Tasks without due date': true,
    'Upcoming Tasks': true,
    'Overdue Tasks': true,
    'Completed Tasks': false,
  };

  ThemeData get theme => Theme.of(context);

  Widget _buildTaskGroup(
    String title,
    List<Task> tasks,
    TaskProvider provider,
  ) {
    final isOverdue = title == "Overdue Tasks";
    final isCompleted = title == "Completed Tasks";

    // Define colors based on task group type
    final Color bgColor = isOverdue
        ? Apptheme.lightRed.withOpacity(0.1)
        : isCompleted
        ? Colors.grey[100]!
        : Apptheme.orange.withOpacity(0.1);

    final Color iconColor = isOverdue
        ? Apptheme.lightRed
        : isCompleted
        ? Colors.grey[600]!
        : Apptheme.orange;

    final Color titleColor = isOverdue
        ? Apptheme.lightRed
        : isCompleted
        ? Colors.grey[600]!
        : Colors.grey[850]!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(
              () => _isExpanded[title] = !(_isExpanded[title] ?? true),
            ),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isOverdue
                          ? Icons.warning_rounded
                          : isCompleted
                          ? Icons.check_circle_outline
                          : Icons.schedule,
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: titleColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${tasks.length} ${tasks.length == 1 ? 'task' : 'tasks'}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: (_isExpanded[title] ?? true) ? 0.5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey[400],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: (_isExpanded[title] ?? true)
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                const Divider(height: 1),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskCard(
                      key: ValueKey(task.id),
                      task: task,
                      onChanged: (bool? value) async {
                        if (value != null) {
                          await provider.updateTaskCompletion(task.id, value);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            secondChild: const SizedBox(height: 0),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 237),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'All Tasks',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
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

          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.task_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "No tasks found",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add a task to get started",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              if (futureTasks.isNotEmpty) ...[
                _buildTaskGroup("Upcoming Tasks", futureTasks, taskProvider),
                const SizedBox(height: 24),
              ],
              if (tasksWithoutDates.isNotEmpty) ...[
                _buildTaskGroup(
                  "Tasks without due date",
                  tasksWithoutDates,
                  taskProvider,
                ),
                const SizedBox(height: 24),
              ],
              if (pastTasks.isNotEmpty) ...[
                _buildTaskGroup("Overdue Tasks", pastTasks, taskProvider),
                const SizedBox(height: 24),
              ],
              if (completedTasks.isNotEmpty)
                _buildTaskGroup(
                  "Completed Tasks",
                  completedTasks,
                  taskProvider,
                ),
            ],
          );
        },
      ),
    );
  }
}
