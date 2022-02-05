import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:tipiko_app_usr/animation/ScaleRoute.dart';
import 'package:tipiko_app_usr/api/api.dart';
import 'package:tipiko_app_usr/data/category.dart';
import 'package:tipiko_app_usr/data/product.dart';
import 'package:tipiko_app_usr/data/restaurant.dart';
import 'package:tipiko_app_usr/widgets/BestFoodWidget.dart';
import 'package:tipiko_app_usr/widgets/BottomNavBarWidget.dart';
import 'package:tipiko_app_usr/widgets/FoodlistWidget.dart';
import 'package:tipiko_app_usr/widgets/PopularFoodsWidget.dart';
import 'package:tipiko_app_usr/widgets/RestaurantlistWidget.dart';
import 'package:tipiko_app_usr/widgets/TopMenus.dart';

import '../cart_bloc.dart';
import 'json_restful_api.dart';


class HomePageCategoryStores extends StatefulWidget {

   int  ? category_id;


  HomePageCategoryStores( this.category_id  );

  @override
  _HomePageCategoryStoresState createState() => _HomePageCategoryStoresState();
}
class _HomePageCategoryStoresState extends State<HomePageCategoryStores> {

  List<Product> ? _stproducts = [];
  @override
  void initState() {
    super.initState();
    _getRoutes();

  }
  _getRoutes( ) async {
    setState(() {


      categories= getcategoriesRestaurants();

    });


  }

  Future<List<Restaurant>> getcategoriesRestaurants( ) async {

    Api.getCategoriesRestaurants(widget.category_id).then((response) {
      setState(() {
        var json_o = json.decode(response.body);

        if (json_o['Cuerpo'].length > 0) {
          for (int i = 0; i < json_o['Cuerpo'].length; i++) {

            var ctg= Restaurant.fromJson2(json_o['Cuerpo'][i]);
            _categories!.add(ctg);

          }
        }
      });
    });

    return _categories;
  }
  Future<List<Restaurant>>? categories;
  List<Restaurant> _categories = [];

  var json_o;





  @override
  Widget build(BuildContext context) {


    final bloc = Provider.of<Cart>(context, listen: false);
    if (bloc.itemCount>0){
      bloc.clear();}
    return Scaffold(
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
          "Menu de categoría",
          style: TextStyle(
              color: Color(0xFF3a3737),
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        brightness: Brightness.light,
        actions: <Widget>[

        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            RestaurantsFoodsWidget(_categories   ),


          ],
        ),
      ),
    );
  }
}