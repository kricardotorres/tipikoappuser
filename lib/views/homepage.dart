import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tipiko_app_usr/animation/ScaleRoute.dart';
import 'package:tipiko_app_usr/api/api.dart';
import 'package:tipiko_app_usr/data/category.dart';
import 'package:tipiko_app_usr/data/product.dart';
import 'package:tipiko_app_usr/widgets/BestFoodWidget.dart';
import 'package:tipiko_app_usr/widgets/BottomNavBarWidget.dart';
import 'package:tipiko_app_usr/widgets/PopularFoodsWidget.dart';
import 'package:tipiko_app_usr/widgets/SearchWidget.dart';
import 'package:tipiko_app_usr/widgets/TopMenus.dart';

import 'json_restful_api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    _getRoutes();
  }
  _getRoutes( ) async {
    setState(() {
      categories= getcategories() as Future<List<Category>>;
      productos_promotion= getproductos_promotion() as Future<List<Product>>;

    });


  }
  Future<List<Category>>? categories;
  List<Category> _categories = [];
  Future<List<Product>>? productos_promotion;
  List<Product> _productos_promotion = [];

  ScrollController _scrollController = new ScrollController();
  Future<List<Category>> getcategories( ) async {

    Api.getCategories().then((response) {
      setState(() {
        var json_o = json.decode(response.body);
        if (json_o['Cuerpo'].length > 0) {
          for (int i = 0; i < json_o['Cuerpo'].length; i++) {
            var ctg= Category.fromJson(json_o['Cuerpo'][i]);
            print(json_o['Cuerpo'][i]['UrlImagen']);
            print('aaaaaaaaaaaaaaaaaaaaaaa');
              _categories!.add(ctg);

          }
        }
      });
    });
    return _categories;
  }
  Future<List<Product>> getproductos_promotion( ) async {

    Api.getProductosEnPromocion().then((response) {
      setState(() {
        var json_o = json.decode(response.body);
        if (json_o['Cuerpo'].length > 0) {
          for (int i = 0; i < json_o['Cuerpo'].length; i++) {
            var ctg= Product.fromJson(json_o['Cuerpo'][i]);
            print(json_o['Cuerpo'][i]);
            _productos_promotion!.add(ctg);

          }
        }
      });
    });
    return _productos_promotion;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
        title: Text(
          "What would you like to eat?",
          style: TextStyle(
              color: Color(0xFF3a3737),
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        brightness: Brightness.light,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Color(0xFF3a3737),
              ),
                  onPressed: () {Navigator.push(context, ScaleRoute(page: LoginWithRestfulApi()));})
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SearchWidget(),
            TopMenus(categories ,_scrollController),
             PopularFoodsWidget(productos_promotion ,_scrollController),
            BestFoodWidget(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarWidget(),
    );
  }
}