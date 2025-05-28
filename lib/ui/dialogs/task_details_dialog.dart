import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:notiq/app/theme/app_theme.dart';
import 'package:notiq/app/utils/action_handler.dart';
import 'package:notiq/app/utils/priority.dart';
import 'package:notiq/app/utils/user_session_helper.dart';
import 'package:notiq/models/task.model.dart' hide Priority;
import 'package:provider/provider.dart';
import 'package:notiq/data/providers/task_provider.dart';

class TaskDetailsDialog extends StatefulWidget {
  final TextEditingController taskController;
  final VoidCallback onClose;

  const TaskDetailsDialog({
    Key? key,
    required this.taskController,
    required this.onClose,
  }) : super(key: key);

  @override
  State<TaskDetailsDialog> createState() => _TaskDetailsDialogState();
}

class _TaskDetailsDialogState extends State<TaskDetailsDialog> {
  late final FSelectMenuTileController<Priority> _priorityController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedTag;
  bool _isRecurring = false;
  Duration? _recurrenceInterval;

  bool get _isDateTimeSelected =>
      _selectedDate != null && _selectedTime != null;

  @override
  void initState() {
    super.initState();
    _priorityController = FSelectMenuTileController<Priority>.radio();
  }

  @override
  void dispose() {
    _priorityController.dispose();
    super.dispose();
  }

  void _resetTaskDetails() {
    setState(() {
      _selectedDate = null;
      _selectedTime = null;
      _selectedTag = null;
      _isRecurring = false;
      _recurrenceInterval = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Apptheme.lightTheme;

    return AlertDialog(
      title: Text('Task Details', style: theme.textTheme.titleMedium),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                FDateField(
                  label: Text('Due Date', style: theme.textTheme.labelMedium),
                  description: Text(
                    'Select a due date for your task',
                    style: theme.textTheme.displaySmall!.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  initialDate: _selectedDate ?? DateTime.now(),
                  onChange: (date) => setState(() => _selectedDate = date),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Time Picker
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                FTimeField.picker(
                  label: Text('Due Time', style: theme.textTheme.labelMedium),
                  description: Text(
                    'Select a time for your task',
                    style: theme.textTheme.displaySmall!.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  initialTime: _selectedTime != null
                      ? FTime(_selectedTime!.hour, _selectedTime!.minute)
                      : FTime(TimeOfDay.now().hour, TimeOfDay.now().minute),
                  onChange: (time) {
                    if (time != null) {
                      setState(
                        () => _selectedTime = TimeOfDay(
                          hour: time.hour,
                          minute: time.minute,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Category Selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Category',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: ['Work', 'Personal', 'Shopping', 'Health'].map((
                        tag,
                      ) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            showCheckmark: false,
                            backgroundColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide.none,
                            ),
                            selectedColor: Apptheme.orange,
                            label: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            selected: _selectedTag == tag,
                            onSelected: (selected) {
                              setState(() {
                                _selectedTag = selected ? tag : null;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Recurring Task Switch
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Repeat', style: theme.textTheme.labelMedium),
              trailing: Switch(
                value: _isRecurring,
                activeColor: Apptheme.orange,
                onChanged: (value) {
                  setState(() => _isRecurring = value);
                },
              ),
            ),

            // Recurrence Interval
            if (_isRecurring) ...[
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Repeat Every', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<Duration>(
                    value: _recurrenceInterval,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 15,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    hint: const Text('Select interval'),
                    items:
                        [
                          const Duration(days: 1),
                          const Duration(days: 7),
                          const Duration(days: 30),
                          const Duration(days: 365),
                        ].map((duration) {
                          String label = 'Daily';
                          if (duration.inDays == 7) label = 'Weekly';
                          if (duration.inDays == 30) label = 'Monthly';
                          if (duration.inDays == 365) label = 'Yearly';

                          return DropdownMenuItem(
                            value: duration,
                            child: Text(label),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() => _recurrenceInterval = value);
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _resetTaskDetails();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isDateTimeSelected
              ? () {
                  final DateTime dueDateTime = DateTime(
                    _selectedDate!.year,
                    _selectedDate!.month,
                    _selectedDate!.day,
                    _selectedTime!.hour,
                    _selectedTime!.minute,
                  );

                  final selectedPriority =
                      _priorityController.value.firstOrNull;

                  final task = Task(
                    user_id: UserSession().getUser!.id,
                    title: widget.taskController.text.trim(),
                    dueDate: dueDateTime,
                    priority: selectedPriority?.name.toLowerCase(),
                    tag: _selectedTag,
                    isRecurring: _isRecurring,
                    recurrenceInterval: _recurrenceInterval,
                  );

                  handleAction(
                    context: context,
                    call: () {
                      return Provider.of<TaskProvider>(
                        context,
                        listen: false,
                      ).addTask(task);
                    },
                    onSuccess: (data) {
                      _resetTaskDetails();
                      widget.onClose();
                      Navigator.pop(context);
                    },
                  );
                }
              : null,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
