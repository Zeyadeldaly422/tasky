import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todoapp/features/tasks/complete_tasks_screen.dart';
import 'package:todoapp/features/tasks/tasks_screen.dart';
import 'package:todoapp/features/home/home_screen.dart';
import 'package:todoapp/features/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> screens = [
    HomeScreen(),
    TasksScreen(),
    CompletedTasks(),
    ProfileScreen(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int? index) {
          setState(() {
            _currentIndex = index ?? 0;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _bulidSvgPicture("assets/images/Home.svg",0),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: _bulidSvgPicture("assets/images/to_do.svg",1),
            label: 'To Do',
          ),

          BottomNavigationBarItem(
            icon: _bulidSvgPicture("assets/images/com.svg",2),
            label: 'Completed',
          ),

          BottomNavigationBarItem(
            icon: _bulidSvgPicture("assets/images/prof.svg",3),
            label: 'Profile',
          ),
        ],
      ),

      body: SafeArea(child: screens[_currentIndex]),
    );
  }

  SvgPicture _bulidSvgPicture(String path,int index) {
    return SvgPicture.asset(
      path,
      colorFilter: ColorFilter.mode(
        _currentIndex == index ? const Color(0xff15B86C) : const Color(0xffc6c6c6),
        BlendMode.srcIn,
      ),
    );
  }
}
