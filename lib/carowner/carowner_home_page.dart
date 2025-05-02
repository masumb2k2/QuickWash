import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practice/BookingDetailsPage.dart';
import '../carwasher/carwasher_chatlist_page.dart';
import '../carwasher/carwasher_list_page.dart';
import '../ProfilePage.dart';
 // <- Import your BookingDetailsPage

class CarownerHomePage extends StatefulWidget {
  const CarownerHomePage({super.key});

  @override
  State<CarownerHomePage> createState() => _CarownerHomePageState();
}

class _CarownerHomePageState extends State<CarownerHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _children = [
    CarwasherListPage(),
    CarwasherChatlistPage(),
    BookingDetailsPage(), // <- Your Booking page
    ProfilePage(),
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
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  SystemNavigator.pop();
                },
                child: const Text('Yes')),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWilPop,
      child: Scaffold(
        body: _children.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xff006AFA),
          unselectedItemColor: const Color(0xffBEBEBE),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Booking'), // <- New Item
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItmTapped,
          type: BottomNavigationBarType.fixed, // Important when more than 3 items
        ),
      ),
    );
  }
}