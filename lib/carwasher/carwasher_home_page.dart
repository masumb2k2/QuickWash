import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:practice/BookingDetailsPage.dart';
import '../ProfilePage.dart';
import 'carwasher_chatlist_page.dart';
import 'carwasher_requests_page.dart';

class CarwasherHomePage extends StatefulWidget {
  const CarwasherHomePage({super.key});

  @override
  State<CarwasherHomePage> createState() => _CarwasherHomePageState();
}

class _CarwasherHomePageState extends State<CarwasherHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _children = [
    CarwasherRequestsPage(),      // Home
    CarwasherChatlistPage(),      // Chat
    BookingDetailsPage(),         // Booking
    ProfilePage(),         // Profile (placeholder for now)
  ];

  void _onItmTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWilPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              SystemNavigator.pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWilPop,
      child: Scaffold(
        body: _children.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Needed for more than 3 items
          backgroundColor: const Color(0xff006AFA),
          unselectedItemColor: const Color(0xffBEBEBE),
          selectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItmTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_online),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
