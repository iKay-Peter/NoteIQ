import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:notiq/app/theme/app_theme.dart';
import 'package:notiq/app/utils/action_handler.dart';
import 'package:notiq/app/utils/priority.dart';
import 'package:notiq/data/providers/task_provider.dart';
import 'package:notiq/models/task.model.dart';
import 'package:provider/provider.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TextEditingController _titleController;
  late FSelectMenuTileController<Priority> _priorityController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedTag;
  bool _isRecurring = false;
  Duration? _recurrenceInterval;
  bool _isEditing = false;

  final _dateFormatter = DateFormat('MMM d, y');
  final _timeFormatter = DateFormat('h:mm a');

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _priorityController = FSelectMenuTileController<Priority>.radio();
    _loadTaskDetails();
  }

  void _loadTaskDetails() {
    final task = Provider.of<TaskProvider>(
      context,
      listen: false,
    ).tasks.firstWhere((t) => t.id == widget.taskId);

    _titleController.text = task.title;
    if (task.priority != null) {
      final priority = Priority.values.firstWhere(
        (p) => p.name.toLowerCase() == task.priority!.toLowerCase(),
        orElse: () => Priority.medium,
      );
      _priorityController.value = {priority};
    }
    _selectedDate = task.dueDate;
    _selectedTime = task.dueDate != null
        ? TimeOfDay(hour: task.dueDate!.hour, minute: task.dueDate!.minute)
        : null;
    _selectedTag = task.tag;
    _isRecurring = task.isRecurring;
    _recurrenceInterval = task.recurrenceInterval;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _deleteTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              handleAction(
                context: context,
                call: () => Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).deleteTask(widget.taskId),
                onSuccess: (_) {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to previous screen
                },
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    final task = Provider.of<TaskProvider>(
      context,
      listen: false,
    ).tasks.firstWhere((t) => t.id == widget.taskId);

    DateTime? dueDateTime;
    if (_selectedDate != null && _selectedTime != null) {
      dueDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
    }

    final updatedTask = task.copyWith(
      title: _titleController.text,
      dueDate: dueDateTime,
      priority: _priorityController.value.firstOrNull,
      tag: _selectedTag,
      isRecurring: _isRecurring,
      recurrenceInterval: _recurrenceInterval,
    );

    handleAction(
      context: context,
      call: () => Provider.of<TaskProvider>(
        context,
        listen: false,
      ).updateTask(updatedTask),
      onSuccess: (_) {
        _toggleEdit();
      },
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'No due date';
    return '${_dateFormatter.format(dateTime)} at ${_timeFormatter.format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Apptheme.lightTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Task Details',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              onPressed: _toggleEdit,
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit Task',
            )
          else
            IconButton(
              onPressed: _saveChanges,
              icon: const Icon(Icons.check_rounded),
              tooltip: 'Save Changes',
            ),
          IconButton(
            onPressed: _deleteTask,
            icon: const Icon(Icons.delete_outline),
            color: theme.colorScheme.error,
            tooltip: 'Delete Task',
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          final task = provider.tasks.firstWhere((t) => t.id == widget.taskId);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isEditing)
                  TextFormField(
                    controller: _titleController,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Task Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Apptheme.orange),
                      ),
                    ),
                  )
                else
                  Text(
                    task.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                const SizedBox(height: 32),
                if (_isEditing) ...[
                  FDateField(
                    label: Text(
                      'Due Date',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    description: Text(
                      'Select a due date for your task',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    initialDate: _selectedDate,
                    onChange: (date) => setState(() => _selectedDate = date),
                  ),
                  const SizedBox(height: 24),
                  FTimeField.picker(
                    label: Text(
                      'Due Time',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    description: Text(
                      'Select a time for your task',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    initialTime: _selectedTime != null
                        ? FTime(_selectedTime!.hour, _selectedTime!.minute)
                        : null,
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
                  const SizedBox(height: 24),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: FSelectMenuTile<Priority>(
                      selectController: _priorityController,
                      autoHide: true,
                      title: Text(
                        'Priority',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Set task priority',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      details: ListenableBuilder(
                        listenable: _priorityController,
                        builder: (context, _) => Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color:
                                    _priorityController
                                        .value
                                        .firstOrNull
                                        ?.color ??
                                    Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              margin: const EdgeInsets.only(right: 8),
                            ),
                            Text(
                              _priorityController.value.firstOrNull?.label ??
                                  'None',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      menu: [
                        for (final priority in Priority.values)
                          FSelectTile(
                            title: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: priority.color,
                                    shape: BoxShape.circle,
                                  ),
                                  margin: const EdgeInsets.only(right: 8),
                                ),
                                Text(
                                  priority.label,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            value: priority,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: ['Work', 'Personal', 'Shopping', 'Health']
                                .map(
                                  (tag) => Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ChoiceChip(
                                      showCheckmark: false,
                                      backgroundColor: Colors.grey.shade50,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color: _selectedTag == tag
                                              ? Apptheme.orange
                                              : Colors.grey.shade200,
                                        ),
                                      ),
                                      selectedColor: Apptheme.orange
                                          .withOpacity(0.1),
                                      label: Text(
                                        tag,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: _selectedTag == tag
                                                  ? Apptheme.orange
                                                  : Colors.grey.shade700,
                                              fontWeight: _selectedTag == tag
                                                  ? FontWeight.w500
                                                  : FontWeight.normal,
                                            ),
                                      ),
                                      selected: _selectedTag == tag,
                                      onSelected: (selected) {
                                        setState(() {
                                          _selectedTag = selected ? tag : null;
                                        });
                                      },
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: Text(
                        'Repeat',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Switch(
                        value: _isRecurring,
                        activeColor: Apptheme.orange,
                        onChanged: (value) {
                          setState(() => _isRecurring = value);
                        },
                      ),
                    ),
                  ),
                  if (_isRecurring) ...[
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Repeat Every',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<Duration>(
                          value: _recurrenceInterval,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade50,
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
                              borderSide: BorderSide(color: Apptheme.orange),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          hint: Text(
                            'Select interval',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
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
                                  child: Text(
                                    label,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() => _recurrenceInterval = value);
                          },
                        ),
                      ],
                    ),
                  ],
                ] else ...[
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _DetailItem(
                            icon: Icons.calendar_today_outlined,
                            title: 'Due Date',
                            value: _formatDateTime(task.dueDate),
                            color: Colors.grey.shade700,
                          ),
                          if (task.priority != null) ...[
                            const Divider(height: 24),
                            _DetailItem(
                              icon: Icons.flag_outlined,
                              title: 'Priority',
                              value: task.priorityValue?.label ?? 'None',
                              color: task.priorityValue?.color,
                            ),
                          ],
                          if (task.tag != null) ...[
                            const Divider(height: 24),
                            _DetailItem(
                              icon: Icons.label_outline,
                              title: 'Category',
                              value: task.tag!,
                              color: Colors.grey.shade700,
                            ),
                          ],
                          if (task.isRecurring) ...[
                            const Divider(height: 24),
                            _DetailItem(
                              icon: Icons.repeat,
                              title: 'Repeats',
                              value: _getRecurrenceText(
                                task.recurrenceInterval,
                              ),
                              color: Colors.grey.shade700,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _getRecurrenceText(Duration? interval) {
    if (interval == null) return 'No';
    if (interval.inDays == 1) return 'Daily';
    if (interval.inDays == 7) return 'Weekly';
    if (interval.inDays == 30) return 'Monthly';
    if (interval.inDays == 365) return 'Yearly';
    return 'Custom';
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? color;

  const _DetailItem({
    required this.icon,
    required this.title,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: color ?? Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
