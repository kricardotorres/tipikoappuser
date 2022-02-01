import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tipiko_app_usr/animation/RotationRoute.dart';
import 'package:tipiko_app_usr/animation/ScaleRoute.dart';
import 'package:tipiko_app_usr/api/api.dart';
import 'package:tipiko_app_usr/data/restaurant.dart';
import 'package:tipiko_app_usr/data/u_address.dart';
import 'package:tipiko_app_usr/pages/nearest_location.dart';
import 'package:tipiko_app_usr/widgets/UAdresslistWidget.dart'; 

class  UAddresslistview extends StatefulWidget {

 var user_id;

 UAddresslistview( this.user_id );


  @override
  _UAddresslistviewState createState() => _UAddresslistviewState();
}

class _UAddresslistviewState extends State<UAddresslistview> {

  Future<List<UAddress>>? uaddresses;
  List<UAddress> _uaddresses = [];

  ScrollController _scrollController = new ScrollController();

 

  @override
  void initState() {
    super.initState();
    print("aaaaaaaaaaaaaa");
    print(widget.user_id);
    _getRoutes();

  }
  _getRoutes( ) async {
    setState(() {
      uaddresses= getuaddresses(widget.user_id) as Future<List<UAddress>>;
    });


  }

  Future<List<UAddress>> getuaddresses(int user_d ) async {

    Api.getUAddresses(user_d).then((response) {
      setState(() {
        var json_o = json.decode(response.body);
        if (json_o['Cuerpo'].length > 0) {
          for (int i = 0; i < json_o['Cuerpo'].length; i++) {
            print(json_o['Cuerpo'][i]);
            var ctg= UAddress.fromJson(json_o['Cuerpo'][i]);
            _uaddresses!.add(ctg);

          }
        }
      });
    });
    return _uaddresses;
  }


  @override
  Widget build(BuildContext context) => Scaffold(

  floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(context, ScaleRoute(page:  MapNearest(title: 'Dirección Nueva', passed_Location : ({  "latitude": 20.96664072305195,   'longitude': -89.623675}))));
  },
  child: const Icon(Icons.add,),
  ),
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
        title: Text(
          "Selecciona una dirección",
          style: TextStyle(
              color: Color(0xFF3a3737),
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        brightness: Brightness.light,
        actions: <Widget>[

        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            PopularFoodTitle(),
            Expanded(
              child:  ListView(
                children: <Widget>[
                  UAddresList(uaddresses),

                ],
              ) ,
            )
          ],
        ),
      )
    );
}

 
class PopularFoodTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        ],
      ),
    );
  }
}


