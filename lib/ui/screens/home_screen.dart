import 'package:flutter/material.dart';
import 'package:notiq/app/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                      Text('Hi there,', style: TextStyle(fontSize: 12)),
                      Text(
                        'Peter iKay',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                TaskButtons(
                  title: 'Tasks',
                  description: 'View your tasks',
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: () {},
                ),
                TaskButtons(
                  title: 'Reminders',
                  description: 'For all your reminders',
                  icon: Icons.add_alarm_sharp,
                  onPressed: () {},
                ),
                TaskButtons(
                  title: 'Alarms',
                  description: 'For all alarms',
                  icon: Icons.notifications_active,
                  onPressed: () {},
                ),
                TaskButtons(
                  title: 'Self Chat',
                  description: 'Chat notes',
                  icon: Icons.chat,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Today's Tasks",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text("See All", style: TextStyle(color: Apptheme.orange)),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const TaskCard(
                    title: 'UI Design',
                    time: '09:00 AM - 11:00 AM',
                  ),
                  const TaskCard(
                    title: 'Web Development',
                    time: '11:30 AM - 12:30 PM',
                  ),
                  const TaskCard(
                    title: 'Office Meeting',
                    time: '02:00 PM - 03:00 PM',
                  ),
                  const TaskCard(
                    title: 'Dashboard Design',
                    time: '03:30 PM - 05:00 PM',
                  ),
                  const TaskCard(
                    title: "Meeting with client",
                    time: "10:00 AM - 11:00 AM",
                  ),
                  const TaskCard(
                    title: "Design review",
                    time: "1:00 PM - 2:00 PM",
                  ),
                  const TaskCard(
                    title: "Project deadline",
                    time: "5:00 PM - 6:00 PM",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskButtons extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Function onPressed;
  const TaskButtons({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(description, style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String time;

  const TaskCard({super.key, required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Checkbox(value: false, onChanged: (value) {}),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                time,
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
    );
  }
}
