import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tipiko_app_usr/animation/ScaleRoute.dart';
import 'package:tipiko_app_usr/pages/food_order_page.dart';
import 'package:tipiko_app_usr/views/homepage.dart';

class BottomNavBarWidget extends StatefulWidget {
  @override
  _BottomNavBarWidgetState createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;

        print("aaaaaaaaaaaaaaaaaaaa-----------");
        print(index);
        if (index == 1) Navigator.push(context, ScaleRoute(page: FoodOrderPage()));
        if (index == 2) Navigator.push(context, ScaleRoute(page: FoodOrderPage()));
        if (index == 3) Navigator.push(context, ScaleRoute(page: FoodOrderPage()));




      });
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text(
            'Home',
            style: TextStyle(color: Color(0xFF2c2b2b)),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.near_me),
          title: Text(
            'Near By',
            style: TextStyle(color: Color(0xFF2c2b2b)),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          title: Text(
            'Cart',
            style: TextStyle(color: Color(0xFF2c2b2b)),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.user),
          title: Text(
            'Account',
            style: TextStyle(color: Color(0xFF2c2b2b)),
          ),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Color(0xFFfd5352),
      onTap: _onItemTapped,
    );
  }
}
