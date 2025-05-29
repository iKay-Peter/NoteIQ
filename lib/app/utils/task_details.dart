import 'package:flutter/material.dart';

class TaskDetails {
  DateTime? dueDate;
  TimeOfDay? dueTime;
  String? priority;
  String? tag;
  bool isRecurring;
  Duration? recurrenceInterval;

  TaskDetails({
    this.dueDate,
    this.dueTime,
    this.priority,
    this.tag,
    this.isRecurring = false,
    this.recurrenceInterval,
  });

  void reset() {
    dueDate = null;
    dueTime = null;
    priority = null;
    tag = null;
    isRecurring = false;
    recurrenceInterval = null;
  }

  TaskDetails copyWith({
    DateTime? dueDate,
    TimeOfDay? dueTime,
    String? priority,
    String? tag,
    bool? isRecurring,
    Duration? recurrenceInterval,
  }) {
    return TaskDetails(
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      tag: tag ?? this.tag,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
    );
  }
}
