

import 'dart:js';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipiko_app_usr/animation/RotationRoute.dart';
import 'package:tipiko_app_usr/animation/ScaleRoute.dart';

import 'package:tipiko_app_usr/data/u_address.dart';
import 'package:tipiko_app_usr/pages/food_details_page.dart';


class  UAddresList extends StatefulWidget {

  var   uaddress;


  UAddresList( this.uaddress );



  @override
  _UAddresListState createState() => _UAddresListState();
}

class _UAddresListState extends State<UAddresList> {


  ScrollController _scrollController = new ScrollController();

  list() {


    return  FutureBuilder<List>(
      future: widget.uaddress,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {

          return Text("Espere");
        }
        if (snapshot.hasData) {
          return dataTable(List<UAddress>.from(snapshot.data!)   );
        }


        return Text("Espere");
      },
    );

    return dataTable(widget.uaddress);

  }
  SingleChildScrollView dataTable(List<UAddress> ? uaddress) {
    return SingleChildScrollView(
      child: ListView.builder(shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: uaddress!.length,
          itemBuilder: (context, index) {
            return  PopularFoodTiles(name: uaddress[index].direccion, imageUrl: "", rating: "",
                numberOfRating: "",
                price: uaddress[index].direccion,
                slug: "",
                Uaddress: uaddress[index]
            );



          }),




      controller:  _scrollController ,

    );
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          PopularFoodTitle(),
          Expanded(
            child:  ListView(
              children: <Widget>[
                list(),

              ],
            ) ,
          )
        ],
      ),
    );
  }
}

class PopularFoodTiles extends StatelessWidget {
  String name;
  String imageUrl;
  String rating;
  String numberOfRating;
  String price;
  String slug;
  UAddress Uaddress;

  PopularFoodTiles(
      {
        required this.name,
        required this.imageUrl,
        required this.rating,
        required this.numberOfRating,
        required this.price,
        required this.slug,

        required this.Uaddress})
  ;
  set_route_id(int uaddres_id, BuildContext context)  async {
    final prefs = await SharedPreferences.getInstance();

    final client = 'client_address';
    final client_latitud = 'client_latitud';
    final client_longitud = 'client_longitud';
    final client_direccion = 'client_direccion';
    prefs.setString(client, uaddres_id.toString());
    prefs.setString(client_latitud, Uaddress.latitud);
    prefs.setString(client_longitud, Uaddress.longitud);
    prefs.setString(client_direccion, Uaddress.direccion);

    _showSnackBar("Dirección guardada!",context);
  }


  void _showSnackBar(String text,BuildContext context) {

    ScaffoldMessenger.of( context).showSnackBar(SnackBar(
      content:   Text(text),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          Navigator.of( context).pop();},
      ),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async {set_route_id(Uaddress.id_direccion, context);


      //  Navigator.push(context, ScaleRoute(page: FoodDetailsPage( UAddress : UAddress  )));
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color(0xFFfae3e2),
                blurRadius: 15.0,
                offset: Offset(0, 0.75),
              ),
            ]),
            child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(2.0),
                  ),
                ),
                child: Container(
                  width: 308,
                  height: 108,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 5, top: 5),
                            child: Text(Uaddress.calle,
                                style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 5, top: 5),
                            child: Text(Uaddress.numInteriro,
                                style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Container(
                              width: 200,
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 5, top: 5),
                            child: Text(Uaddress.direccion , overflow: TextOverflow.ellipsis, maxLines: 10)
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
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


