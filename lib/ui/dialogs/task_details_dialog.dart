import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:notiq/app/theme/app_theme.dart';
import 'package:notiq/app/utils/priority.dart';
import 'package:notiq/data/providers/task_provider.dart';
import 'package:provider/provider.dart';

class TaskDetailsDialog extends StatefulWidget {
  const TaskDetailsDialog({super.key});

  @override
  State<TaskDetailsDialog> createState() => _TaskDetailsDialogState();
}

class _TaskDetailsDialogState extends State<TaskDetailsDialog> {
  late final FSelectMenuTileController<Priority> _priorityController;

  @override
  void initState() {
    super.initState();
    _priorityController = FSelectMenuTileController<Priority>.radio();

    // Set initial controller value if priority exists
    final provider = context.read<TaskProvider>();
    if (provider.taskDetails.priority != null) {
      final priority = Priority.values.firstWhere(
        (p) =>
            p.name.toLowerCase() ==
            provider.taskDetails.priority!.toLowerCase(),
        orElse: () => Priority.medium,
      );
      _priorityController.value = {priority};
    }
  }

  @override
  void dispose() {
    _priorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final details = provider.taskDetails;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Task Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Picker
                FDateField(
                  label: Text(
                    'Due Date',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  description: Text(
                    'Select a due date for your task',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  initialDate: details.dueDate,
                  onChange: (date) {
                    provider.updateTaskDetails(dueDate: date);
                  },
                ),
                const SizedBox(height: 24),

                // Time Picker
                FTimeField.picker(
                  label: Text(
                    'Due Time',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  description: Text(
                    'Select a time for your task',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  initialTime: details.dueTime != null
                      ? FTime(details.dueTime!.hour, details.dueTime!.minute)
                      : null,
                  onChange: (time) {
                    if (time != null) {
                      provider.updateTaskDetails(
                        dueTime: TimeOfDay(
                          hour: time.hour,
                          minute: time.minute,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Category Selection
                Text(
                  'Category',
                  style: theme.textTheme.titleSmall?.copyWith(
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
                                    color: details.tag == tag
                                        ? Apptheme.orange
                                        : Colors.grey.shade200,
                                  ),
                                ),
                                selectedColor: Apptheme.orange.withOpacity(0.1),
                                label: Text(
                                  tag,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: details.tag == tag
                                        ? Apptheme.orange
                                        : Colors.grey.shade700,
                                    fontWeight: details.tag == tag
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                                ),
                                selected: details.tag == tag,
                                onSelected: (selected) {
                                  provider.updateTaskDetails(
                                    tag: selected ? tag : null,
                                  );
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Priority Selection
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
                      style: theme.textTheme.titleSmall?.copyWith(
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

                // Recurring Task Switch
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
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Switch(
                      value: details.isRecurring,
                      activeColor: Apptheme.orange,
                      onChanged: (value) {
                        provider.updateTaskDetails(isRecurring: value);
                      },
                    ),
                  ),
                ),

                // Recurrence Interval
                if (details.isRecurring) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Repeat Every',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Duration>(
                    value: details.recurrenceInterval,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
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
                      provider.updateTaskDetails(recurrenceInterval: value);
                    },
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                provider.resetTaskDetails();
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Cancel',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                final selectedPriority = _priorityController.value.firstOrNull;
                if (selectedPriority != null) {
                  provider.updateTaskDetails(
                    priority: selectedPriority.name.toLowerCase(),
                  );
                }
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Apptheme.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Done',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        );
      },
    );
  }
}
