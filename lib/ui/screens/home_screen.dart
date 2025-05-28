import 'package:flutter/material.dart';
import 'package:notiq/app/config/routes/app_routes.dart';
import 'package:notiq/app/theme/app_theme.dart';
import 'package:notiq/app/utils/action_handler.dart';
import 'package:notiq/data/providers/registration_provider.dart';
import 'package:notiq/data/providers/task_provider.dart';
import 'package:notiq/data/repositories/task_repository.dart';
import 'package:notiq/ui/widgets/task_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleAction(
        context: context,
        call: Provider.of<TaskProvider>(context, listen: false).fetchTasks,
        showErrorNotification: false,
        showSuccessNotification: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<RegistrationProvider>(
      context,
      listen: false,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi there,',
                        style: TextStyle(fontSize: 14, height: 0),
                      ),
                      Text(
                        authProvider.user.name!,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Apptheme.lightRed,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            // GridView(
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     childAspectRatio: 1.7,
            //     crossAxisSpacing: 5,
            //     mainAxisSpacing: 5,
            //   ),
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   children: [
            //     TaskButtons(
            //       title: 'Tasks',
            //       description: 'View your tasks',
            //       icon: Icons.check_circle_outline_rounded,
            //       color: Colors.blue,
            //       onPressed: () {
            //         Navigator.of(context).pushNamed(AppRoutes.task);
            //       },
            //     ),
            //     TaskButtons(
            //       title: 'Reminders',
            //       description: 'For all your reminders',
            //       icon: Icons.add_alarm_sharp,
            //       color: Colors.purple,
            //       onPressed: () {},
            //     ),
            //     TaskButtons(
            //       title: 'Alarms',
            //       description: 'For all alarms',
            //       icon: Icons.notifications_active,
            //       color: Colors.orange,
            //       onPressed: () {},
            //     ),
            //     TaskButtons(
            //       title: 'Self Chat',
            //       description: 'Chat notes',
            //       icon: Icons.chat,
            //       color: Colors.green,
            //       onPressed: () {},
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 20),
            // Text(
            //   "Projects",
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 10),
            // SizedBox(
            //   height: 100,
            //   child: Scrollbar(
            //     child: ListView(
            //       primary: true,
            //       scrollDirection: Axis.horizontal,
            //       physics: AlwaysScrollableScrollPhysics(),
            //       children: [
            //         ProjectCards(
            //           tasks: 10,
            //           title: "Mobile App",
            //           icon: Icons.mobile_friendly,
            //           color: Apptheme.liteBlue,
            //         ),
            //         ProjectCards(
            //           tasks: 12,
            //           title: "Web Design",
            //           icon: Icons.web,
            //           color: Apptheme.darkGreen,
            //         ),
            //         ProjectCards(
            //           tasks: 15,
            //           title: "UI/UX Design",
            //           icon: Icons.design_services,
            //           color: Apptheme.lightRed,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),
            Text(
              "Today's Tasks",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Due Today",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.allTasks);
                  },
                  child: const Text(
                    "View All",
                    style: TextStyle(
                      fontSize: 14,
                      color: Apptheme.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  // Filter out completed tasks
                  final uncompletedTasks = taskProvider.tasks
                      .where((task) => !task.isCompleted)
                      .toList();

                  if (uncompletedTasks.isEmpty) {
                    return Center(
                      child: Text(
                        "No pending tasks",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: uncompletedTasks.length,
                    itemBuilder: (context, index) {
                      final task = uncompletedTasks[index];
                      return TaskCard(
                        title: task.title,
                        time: task.dueDate != null
                            ? task.dueDate!.toIso8601String().substring(11, 16)
                            : "No time set",
                        isCompleted: task.isCompleted,
                        onChanged: (bool? value) async {
                          if (value != null) {
                            await Future.delayed(
                              const Duration(milliseconds: 500),
                            );
                            if (context.mounted) {
                              taskProvider.updateTaskCompletion(task.id, value);
                            }
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
