import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with TickerProviderStateMixin {
  late FTabController controller;

  @override
  void initState() {
    super.initState();
    controller = FTabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: const Icon(Icons.arrow_back),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Text(
                  'Tasks',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20),
              ],
            ),
            FTabs(
              controller: controller,
              children: [
                FTabEntry(label: const Text('All'), child: Container()),
                FTabEntry(label: const Text('Today'), child: Container()),
                FTabEntry(label: const Text('Completed'), child: Container()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
