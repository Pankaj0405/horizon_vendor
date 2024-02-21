import 'package:flutter/material.dart';
import 'package:horizon_vendor/add_volunteers.dart';
import 'package:horizon_vendor/home.dart';
import 'package:horizon_vendor/new_event.dart';
import 'package:horizon_vendor/profile.dart';


class Home1 extends StatefulWidget {
  const Home1({super.key});

  @override
  State<Home1> createState() => _Home1State();
}



class _Home1State extends State<Home1> {
  int _selectedIndex = 0;

  void _navigateBottomeBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [
    const HomePage(),
    const AddNewEvent(),
    const AddVolunteer(),
    const Profile(),
  ];

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomeBar,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alert_outlined),
            label: "Add Event",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.group_add_outlined,
            ),
            label: "Add Volunteer",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_2_outlined,
            ),
            label: "Profile",
          ),
        ],
        iconSize: 25,
        elevation: 30,
      ),
    );
  }
}
