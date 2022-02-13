
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tipiko_app_usr/animation/RotationRoute.dart';
import 'package:tipiko_app_usr/animation/ScaleRoute.dart';
import 'package:tipiko_app_usr/api/api.dart';
import 'package:tipiko_app_usr/data/u_orders.dart';
import 'package:tipiko_app_usr/pages/nearest_location.dart';
import 'package:tipiko_app_usr/widgets/UOrderslistWidget.dart';

class  UOrderslistview extends StatefulWidget {

  var user_id;

  UOrderslistview( this.user_id );


  @override
  _UOrderslistviewState createState() => _UOrderslistviewState();
}

class _UOrderslistviewState extends State<UOrderslistview> {

  Future<List<UOrder>>? uOrderses;
  List<UOrder> _uOrderses = [];

  ScrollController _scrollController = new ScrollController();



  @override
  void initState() {
    super.initState();

    _getRoutes();

  }
  _getRoutes( ) async {
    setState(() {
      uOrderses= getuOrderses(widget.user_id) as Future<List<UOrder>>;
    });


  }

  Future<List<UOrder>> getuOrderses(int user_d ) async {

    Api.getUOrderses(user_d).then((response) {
      setState(() {
        var json_o = json.decode(response.body);
        if (json_o['Cuerpo'].length > 0) {
          for (int i = 0; i < json_o['Cuerpo'].length; i++) {

            var ctg= UOrder.fromJson(json_o['Cuerpo'][i]);
            _uOrderses!.add(ctg);

          }
        }
      });
    });
    return _uOrderses;
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF3a3737),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Mis pedidos anteriores",
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
                  UOrdersList(uOrderses),

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


