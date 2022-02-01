import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tipiko_app_usr/animation/ScaleRoute.dart';
import 'package:tipiko_app_usr/pages/food_order_page.dart';
import 'package:tipiko_app_usr/pages/nearest_location.dart';
import 'package:tipiko_app_usr/views/UAdresslist.dart';
import 'package:tipiko_app_usr/views/homepage.dart';

class BottomNavBarWidget extends StatefulWidget {
  var user_id;
  BottomNavBarWidget({required this.user_id   });

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

        //if (index == 1) {Navigator.push(context, ScaleRoute(page:  MapNearest(title: 'Ruta cercana', passed_Location : ({  "latitude": 20.96664072305195,   'longitude': -89.623675}))));};
        if (index == 1) {if(widget.user_id==0){

        }else{
          Navigator.push(context, ScaleRoute(page: UAddresslistview(widget.user_id)));
        }

        };
        if (index == 2) Navigator.push(context, ScaleRoute(page:FoodOrderPage()
        ));
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
            'Direcciones',
            style: TextStyle(color: Color(0xFF2c2b2b)),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          title: Text(
            'Carrito',
            style: TextStyle(color: Color(0xFF2c2b2b)),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.user),
          title: Text(
            'Mi cuenta',
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
