import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notiq/app/theme/app_theme.dart';
import 'package:notiq/app/utils/action_handler.dart';
import 'package:notiq/data/providers/task_provider.dart';
import 'package:notiq/models/task.model.dart';
import 'package:notiq/services/ai_parser_service.dart';
import 'package:notiq/ui/dialogs/task_details_dialog.dart';
import 'package:notiq/ui/screens/home_screen.dart';
import 'package:notiq/ui/widgets/notification/toastification.dart';
import 'package:provider/provider.dart';

class ParseConfirmationDialog extends StatelessWidget {
  final List<Task> tasks;

  const ParseConfirmationDialog({super.key, required this.tasks});

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'No due date';
    final dateFormatter = DateFormat('MMM d, y');
    final timeFormatter = DateFormat('h:mm a');
    return '${dateFormatter.format(dateTime)} at ${timeFormatter.format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Parsed Tasks'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'The following tasks were parsed:',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ...tasks
                .map(
                  (task) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDateTime(task.dueDate),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          if (task.priority != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.flag,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Priority: ${task.priority}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (task.tag != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.label,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Category: ${task.tag}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(backgroundColor: Apptheme.orange),
          child: const Text('Add Tasks'),
        ),
      ],
    );
  }
}

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  TextEditingController taskController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;

  final List<Widget?> _pages = [
    HomePage(),
    Center(child: Text('Messages')),
    Center(child: Text('Profile')),
  ];

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  void _showTaskDetailsDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => TaskDetailsDialog());
  }

  Future<void> _parseWithAI(
    BuildContext context,
    TaskProvider provider,
    String text,
    void Function(void Function()) setModalState,
  ) async {
    final service = AiParserService();
    try {
      final tasks = await AiParserService.withLoadingDialog(
        context,
        () => service.parseText(text),
      );

      if (context.mounted) {
        // Show confirmation dialog
        final shouldAdd = await showDialog<bool>(
          context: context,
          builder: (context) => ParseConfirmationDialog(tasks: tasks),
        );

        // If user confirmed, add the tasks
        if (shouldAdd == true && context.mounted) {
          for (final task in tasks) {
            provider.setNewTaskTitle(task.title);
            provider.updateTaskDetails(
              dueDate: task.dueDate,
              dueTime: task.dueDate != null
                  ? TimeOfDay.fromDateTime(task.dueDate!)
                  : null,
              priority: task.priority,
              tag: task.tag,
            );
            await provider.addTask();
          }
          taskController.clear();
          setModalState(() {
            taskController.clear();
          });
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (context.mounted) {
        ShowNotification.error(
          context,
          'Error',
          'Failed to parse text: ${e.toString()}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 237),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_new',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Apptheme.orange,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            isScrollControlled: true,
            builder: (context) {
              bool isDisabled = taskController.text.trim().isEmpty;

              return StatefulBuilder(
                builder: (context, setState) {
                  return SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                        left: 24,
                        right: 24,
                        top: 20,
                      ),
                      child: Consumer<TaskProvider>(
                        builder: (context, provider, widget) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Add New Task',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.grey[400],
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Form(
                                key: formKey,
                                child: TextFormField(
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  controller: taskController,
                                  onChanged: (value) {
                                    setState(() {
                                      isDisabled = value.trim().isEmpty;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a task';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade50,
                                    filled: true,
                                    hintText: 'What needs to be done?',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 14,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Apptheme.orange,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  autofocus: true,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (value) {
                                    if (!isDisabled &&
                                        formKey.currentState!.validate()) {
                                      provider.setNewTaskTitle(value.trim());
                                      handleAction(
                                        context: context,
                                        call: provider.addTask,
                                        onSuccess: (data) {
                                          taskController.clear();
                                          setState(() {
                                            isDisabled = true;
                                          });
                                          // Navigator.of(context).pop();
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          TextButton.icon(
                                            onPressed: () {
                                              _showTaskDetailsDialog(context);
                                            },
                                            icon: Icon(
                                              Icons.calendar_month_outlined,
                                              color: Apptheme.orange,
                                              size: 20,
                                            ),
                                            label: Text(
                                              'Add Details',
                                              style: TextStyle(
                                                color: Apptheme.orange,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          TextButton.icon(
                                            onPressed: isDisabled
                                                ? null
                                                : () => _parseWithAI(
                                                    context,
                                                    provider,
                                                    taskController.text,
                                                    setState,
                                                  ),
                                            icon: Icon(
                                              Icons.auto_awesome,
                                              color: isDisabled
                                                  ? Colors.grey.shade400
                                                  : Apptheme.orange,
                                              size: 20,
                                            ),
                                            label: Text(
                                              '',
                                              style: TextStyle(
                                                color: isDisabled
                                                    ? Colors.grey.shade400
                                                    : Apptheme.orange,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  FilledButton.icon(
                                    onPressed: isDisabled
                                        ? null
                                        : () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              provider.setNewTaskTitle(
                                                taskController.text.trim(),
                                              );
                                              handleAction(
                                                context: context,
                                                call: provider.addTask,
                                                onSuccess: (data) {
                                                  taskController.clear();
                                                  setState(() {
                                                    isDisabled = true;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            }
                                          },
                                    style: FilledButton.styleFrom(
                                      backgroundColor: isDisabled
                                          ? Colors.grey.shade300
                                          : Apptheme.orange,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    icon: const Icon(Icons.send, size: 18),
                                    label: const Text('Add Task'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
