import 'package:flutter/material.dart';
import 'package:rentalcar/screens/homescreen.dart';
import 'package:rentalcar/screens/ridesbookedscreen.dart';

class BottomScreen extends StatefulWidget {
  
  const BottomScreen({Key? key}) : super(key:key);

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomeScreen(),
      HomeScreen(),
      HomeScreen(),
      HomeScreen(),
      RidesBookedScreen(),
      
    ];
    void onPageTapped (index) {
      setState(() {
        _selectedIndex = index;
      });
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
           
            icon: Icon(Icons.home, color: Colors.grey,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.grey,),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, color: Colors.grey,),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: Colors.grey,),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark ,color: Colors.grey,),
            label: 'Rides Booked',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: onPageTapped,
      ),
    );
  }
}