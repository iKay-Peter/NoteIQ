import 'package:flutter/material.dart';

enum Priority { low, medium, high }

extension PriorityExtension on Priority {
  String get label => switch (this) {
    Priority.low => 'Low',
    Priority.medium => 'Medium',
    Priority.high => 'High',
  };

  Color get color => switch (this) {
    Priority.low => Colors.green,
    Priority.medium => Colors.orange,
    Priority.high => Colors.red,
  };
}
