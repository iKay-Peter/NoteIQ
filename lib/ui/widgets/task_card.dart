import 'package:flutter/material.dart';
import 'package:notiq/ui/screens/home_screen.dart';

class TaskCard extends StatefulWidget {
  final String title;
  final String time;
  final bool isCompleted;
  final Function(bool?) onChanged;

  const TaskCard({
    super.key,
    required this.title,
    required this.time,
    required this.isCompleted,
    required this.onChanged,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Row(
          children: [
            Checkbox(
              value: _isChecked,
              onChanged: (bool? value) async {
                if (value != null) {
                  setState(() => _isChecked = value);
                  // Wait for animation
                  await Future.delayed(const Duration(milliseconds: 300));
                  // Call the actual onChanged handler
                  widget.onChanged(value);
                }
              },
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    decoration: _isChecked ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  widget.time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
