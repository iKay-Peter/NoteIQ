import 'package:flutter/material.dart';
import 'package:notiq/app/theme/app_theme.dart';
import 'package:notiq/app/utils/action_handler.dart';
import 'package:notiq/app/utils/user_session_helper.dart';
import 'package:notiq/data/providers/task_provider.dart';
import 'package:notiq/models/task.model.dart';
import 'package:notiq/ui/dialogs/task_details_dialog.dart';
import 'package:notiq/ui/screens/home_screen.dart';
import 'package:provider/provider.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  TextEditingController taskController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;

  final List<Widget?> _pages = [
    HomePage(),
    Center(child: Text('Messages')),
    Center(child: Text('Profile')),
  ];

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  void _showTaskDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TaskDetailsDialog(
        taskController: taskController,
        onClose: () {
          taskController.clear();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 237),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_new',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Apptheme.orange,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            isScrollControlled: true,
            builder: (context) {
              bool isDisabled = taskController.text.trim().isEmpty;

              return StatefulBuilder(
                builder: (context, setState) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 16,
                      right: 16,
                      top: 16,
                    ),
                    child: Consumer<TaskProvider>(
                      builder: (context, provider, widget) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Form(
                              key: formKey,
                              child: TextFormField(
                                style: TextStyle(fontSize: 14),
                                controller: taskController,
                                onChanged: (value) {
                                  setState(() {
                                    isDisabled = value.trim().isEmpty;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a task';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.grey[50],
                                  filled: true,
                                  hintText: 'Input your task here...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                autofocus: true,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _showTaskDetailsDialog(context);
                                      },
                                      icon: Icon(
                                        Icons.calendar_month,
                                        color: Apptheme.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ChoiceChip(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      selectedColor: Apptheme.orange,
                                      label: Text(
                                        'Parse with AI',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      selected: false,
                                    ),
                                    SizedBox(width: 5),
                                    IconButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                              isDisabled
                                                  ? Colors.grey
                                                  : Apptheme.orange,
                                            ),
                                      ),
                                      onPressed: isDisabled
                                          ? null
                                          : () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                var task = Task(
                                                  user_id:
                                                      UserSession().getUser!.id,
                                                  title: taskController.text
                                                      .trim(),
                                                );
                                                handleAction(
                                                  context: context,
                                                  call: () {
                                                    return provider.addTask(
                                                      task,
                                                    );
                                                  },
                                                  onSuccess: (data) {
                                                    taskController.clear();
                                                    setState(
                                                      () => isDisabled = true,
                                                    );
                                                    Navigator.of(context).pop();
                                                  },
                                                );
                                              }
                                            },
                                      icon: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
