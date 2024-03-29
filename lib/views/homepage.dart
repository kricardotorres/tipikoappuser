import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipiko_app_usr/animation/ScaleRoute.dart';
import 'package:tipiko_app_usr/api/api.dart';
import 'package:tipiko_app_usr/data/category.dart';
import 'package:tipiko_app_usr/data/product.dart';
import 'package:tipiko_app_usr/data/restaurant.dart';
import 'package:tipiko_app_usr/views/homepage_2.dart';
import 'package:tipiko_app_usr/widgets/BottomNavBarWidget.dart';
import 'package:tipiko_app_usr/widgets/PopularFoodsWidget.dart';
import 'package:tipiko_app_usr/widgets/TopMenus.dart';

import 'UAdresslist.dart';
import 'json_restful_api.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  var currentLocation;


  var cliend_dir_id;
  var client_id;
  String client_direccion=" ";
  late bool _testValue=false;
  Location location = Location();
  @override
  void initState() {
    super.initState();


    bool _testValueAddress=false;
    var sharedPreferences;
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      String client_address = 'client_address';
      String client_direccion_ = 'client_direccion';
      String uuid =  'uuid';

      cliend_dir_id= sharedPreferences.get(client_address).toString();
      client_id= sharedPreferences.get(uuid).toString();
      client_direccion= sharedPreferences.get(client_direccion_).toString();

      if(cliend_dir_id== "null"&&client_id!="null"){
        Navigator.push(context, ScaleRoute(page: UAddresslistview(int.parse(client_id))));
      }

      if (client_id  == "null") {
        _testValue = false;
      }else {_testValue = true;}
      setState(() {});
    });

    location.onLocationChanged.listen((value) {
      setState(() {
        currentLocation = value  ;
      });
    });
    _getRoutes();

  }
  _getRoutes( ) async {
    setState(() {
      categories= getcategories() as Future<List<Category>>;
      productos_promotion= getproductos_promotion() as Future<List<Product>>;
    });


  }

  late Future<List<Restaurant?>>   restaurants ;
  List<Restaurant?> _restaurants = [];
  TextEditingController controller_destiny = TextEditingController();
  Future<List<Category>>? categories;
  List<Category> _categories = [];
  Future<List<Product>>? productos_promotion;
  List<Product> _productos_promotion = [];

  ScrollController _scrollController = new ScrollController();

  var json_o;
  Future<List<Restaurant?>> getProducts(String name) async {

    Api.getRestaurants_search(name).then((response) {
      setState(() {
        _restaurants.clear();
        json_o = json.decode(response.body);
        if (json_o['Cuerpo'].length > 0) {
          for (int i = 0; i < json_o['Cuerpo'].length; i++) {
               _restaurants.add(Restaurant.fromJson(json_o['Cuerpo'][i]));

          }
        }
      });
    });

     return _restaurants;
  }
  _HomePageState() {
    controller_destiny.addListener(() {
      if (controller_destiny.text.isEmpty) {
        restaurants = getProducts("" );
      } else {

        setState(() {

          _restaurants.clear();

          restaurants = getProducts(controller_destiny.text);
        });
      }
    });}


  Future<List<Category>> getcategories( ) async {

    Api.getCategories().then((response) {
      setState(() {
        var json_o = json.decode(response.body);
        if (json_o['Cuerpo'].length > 0) {
          for (int i = 0; i < json_o['Cuerpo'].length; i++) {
            var ctg= Category.fromJson(json_o['Cuerpo'][i]);
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
            _productos_promotion!.add(ctg);

          }
        }
      });
    });
    return _productos_promotion;
  }

  Future<List<Restaurant?>> getproductos_search( )   {

    return Future.delayed(
      Duration(seconds: 2),
          () => restaurants,
    );

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
        title: Text(
          "Bienvenido!",
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
                  onPressed: () { })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
        Padding(
        padding: EdgeInsets.only(left: 10,top: 5,right: 10,bottom: 5),
        child:    TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller:   controller_destiny,

            style: TextStyle(color:  Color(0xFF3a3737), fontWeight: FontWeight.w300, decorationColor: Colors.white, ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: Icon(Icons.backspace,
                    color: Colors.orange,),
                  onPressed: () {
                    controller_destiny.text='';
                  }) ,
              prefixIcon:  Icon(Icons.flag,
                color: Colors.orange,),
              border: OutlineInputBorder(),

             ),
          ),
          suggestionsCallback: (pattern) async {


            return  getproductos_search( );
            // ;
          },
          itemBuilder: (context, suggestion) {
            var current  =  suggestion ;

            return ListTile(
              leading: Icon(Icons.location_on),
              title: Text( (suggestion as Restaurant).Nombres.toString()),
              subtitle: Text( (suggestion as Restaurant).Direccion.toString()),
            );
          },
            onSuggestionSelected: (suggestion) {
              _testValue?
              Navigator.push(context, ScaleRoute(page: HomePageCategory(  (suggestion as Restaurant)))):
              Navigator.pushReplacement(context, ScaleRoute(page: LoginWithRestfulApi() ));

            },
        ),
          /*TextField(

          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                width: 0,
                color: Color(0xFFfb3132),
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xFFfb3132),
            ),
            fillColor: Color(0xFFFAFAFA),
            suffixIcon: Icon(Icons.sort,color: Color(0xFFfb3132),),
            hintStyle: new TextStyle(color: Color(0xFFd0cece), fontSize: 18),
            hintText: "What would your like to buy?",
          ),
        )*/


      ),
            TopMenus(categories ,_scrollController,_testValue),
            PopularFoodsWidget(productos_promotion ,_scrollController,0,_testValue),

            //FoodsWidget(productos_promotion  ),

          ],
        ),
      ),
      bottomNavigationBar:  client_id==("null") ? Text( ""):BottomNavBarWidget(user_id: int.parse(client_id), testValue: _testValue,)
      ,
    );
  }
}