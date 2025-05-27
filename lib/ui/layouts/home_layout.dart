import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notiq/app/config/routes/app_routes.dart';
import 'package:notiq/app/theme/app_theme.dart';
import 'package:notiq/ui/screens/home_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _selectedIndex = 0;

  final List<Widget?> _pages = [
    HomePage(),
    Center(child: Text('Messages')),
    Center(child: Text('Profile')),
  ];

  void showMenuClicked(context) {
    final button = context.findRenderObject() as RenderBox;
    final position = button.localToGlobal(Offset.zero);
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + 50,
        position.dx + button.size.width,
        50,
      ),
      items: [
        const PopupMenuItem(child: Text('Category 1'), value: 'category_1'),
        const PopupMenuItem(child: Text('Category 2'), value: 'category_2'),
        const PopupMenuItem(child: Text('Add New Category'), value: 'add_new'),
      ],
    ).then((value) {
      if (value == 'add_new') {
        // Handle add new category
        print('Add new category');
      } else if (value != null) {
        // Handle category selection
        print('Selected category: $value');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 237),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_new', // <-- Add unique heroTag
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Apptheme.orange,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            isScrollControlled: true,
            builder:
                (context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
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
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => showMenuClicked(context),
                                child: Text(
                                  'No Category',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.calendar_month,
                                  color: Apptheme.darkGreen,
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
                                selectedColor: Apptheme.darkGreen,
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
                                style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                        Apptheme.darkGreen,
                                      ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.send, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 10,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Apptheme.orange,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: IconButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                  Apptheme.lightRed,
                ),
              ),
              onPressed: () {
                setState(() => _selectedIndex = 1);
              },
              icon: Icon(Icons.add, color: Colors.white),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
