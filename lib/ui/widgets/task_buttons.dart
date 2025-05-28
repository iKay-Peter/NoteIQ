import 'package:flutter/material.dart';

class TaskButtons extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Function()? onPressed;

  const TaskButtons({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(description, style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
