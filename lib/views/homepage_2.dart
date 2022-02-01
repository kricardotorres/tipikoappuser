import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipiko_app_usr/animation/ScaleRoute.dart';
import 'package:tipiko_app_usr/api/api.dart';
import 'package:tipiko_app_usr/data/category.dart';
import 'package:tipiko_app_usr/data/price_scheme.dart';
import 'package:tipiko_app_usr/data/product.dart';
import 'package:tipiko_app_usr/data/restaurant.dart';
import 'package:tipiko_app_usr/widgets/BestFoodWidget.dart';
import 'package:tipiko_app_usr/widgets/BottomNavBarWidget.dart';
import 'package:tipiko_app_usr/widgets/FoodlistWidget.dart';
import 'package:tipiko_app_usr/widgets/PopularFoodsWidget.dart';
import 'package:tipiko_app_usr/widgets/TopMenus.dart';

import '../cart_bloc.dart';
import 'UAdresslist.dart';
import 'json_restful_api.dart';


class HomePageCategory extends StatefulWidget {

   Restaurant  ? restaurant;


  HomePageCategory( this.restaurant  );

  @override
  _HomePageCategoryState createState() => _HomePageCategoryState();
}
class _HomePageCategoryState extends State<HomePageCategory> {

  double totalDistance = 0;
  List<Product> ? _stproducts = [];
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.restaurant!.productos!.length; i++)  {
      var prjson_ooduct=   widget.restaurant!.productos![i];
      _stproducts!.add(Product(   id_producto : prjson_ooduct['id_producto'],
          nombreNegocio : "",
          nombreProducto : prjson_ooduct['NombreProducto'],
          descripcionProducto : prjson_ooduct['DescripcionProducto'],
          urlImagenProducto : prjson_ooduct['UrlImagen'],
          fechaInicioPromocion : "",
          fechaFinPromocion : "",
          Activo:  true,
          Precio :prjson_ooduct['Precio']));

    }


    var sharedPreferences;
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      String client_address = 'client_address';
      String client_direccion_ = 'client_direccion';

      String client_latitud = 'client_latitud';
      String client_longitud = 'client_longitud';
      String uuid =  'uuid';
      print("2------");
      var current_lat=sharedPreferences.get(client_latitud).toString();
      var current_lng=sharedPreferences.get(client_longitud).toString();
      cliend_dir_id= sharedPreferences.get(client_address).toString();
      client_id= sharedPreferences.get(uuid).toString();
      client_direccion= sharedPreferences.get(client_direccion_).toString();
      print(cliend_dir_id+ client_id);
      print("3-----");
      if(cliend_dir_id== "null"&&client_id!="null"){
        Navigator.push(context, ScaleRoute(page: UAddresslistview(int.parse(client_id))));
      }else{
      List<dynamic> data = [
        {
          "lat": double.parse(current_lat),
          "lng": double.parse(current_lng)
        },{
          "lat": double.parse(widget.restaurant!.latitude),
          "lng": double.parse(widget.restaurant!.longitude)
        } ,
      ];
      print(data);
      for(var i = 0; i < data.length-1; i++){
        totalDistance += calculateDistance(data[i]["lat"], data[i]["lng"], data[i+1]["lat"], data[i+1]["lng"]);
      }
      _getRoutes(  (totalDistance*1000).toStringAsFixed(0) );
      print(totalDistance);}
    });





  }
  var cliend_dir_id;
  var client_id;
  String current_esquema="";
  String client_direccion=" ";
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
  late Future<List<Product?>>   products ;
  List<Product?> _products = [];
  TextEditingController controller_destiny = TextEditingController();
  Future<List<Category>>? categories;
  List<Category> _categories = [];
  Future<List<Product>>? productos_promotion;
  List<Product> _productos_promotion = [];

  ScrollController _scrollController = new ScrollController();

  var json_o;

  Future<List<PriceScheme>> getPriceSchemes(String distancia ) async {

    Api.getprecioenvio(distancia).then((response) {
      setState(() {
        var json_o = json.decode(response.body);
        var ctg= PriceScheme.fromJson(json_o['Cuerpo']);
        current_esquema=ctg.precio.toString();
        _priceSchemes!.add(ctg);
      });
    });
    return _priceSchemes;
  }

  _getRoutes(String distancia ) async {
    setState(() {
      priceSchemes= getPriceSchemes(distancia) as Future<List<PriceScheme>>;
    });


  }
  Future<List<PriceScheme>>? priceSchemes;
  List<PriceScheme> _priceSchemes = [];

  Future<List<Product?>> getProducts(String name) async {

    Api.getRestaurants_search(name).then((response) {
      setState(() {
        _products.clear();
        json_o = json.decode(response.body);
        if (json_o['Cuerpo']['Productos'].length > 0) {
          for (int i = 0; i < json_o['Cuerpo']['Productos'].length; i++) {
            if (name!=""&&json_o['Cuerpo']['Productos'][i]['NombreProducto'].toLowerCase().contains( name.toLowerCase() )){
              _products.add(Product.fromJson2(json_o['Cuerpo']['Productos'][i]));
            }
          }
        }
      });
    });

    return _products;
  }

  _HomePageCategoryState() {

    controller_destiny.addListener(() {
      if (controller_destiny.text.isEmpty) {
        products = getProducts("" );
      } else {

        setState(() {

          _products.clear();

          products = getProducts(controller_destiny.text);
        });
      }
    });

  }


  Future<List<Product?>> getproductos_search( )   {

    return Future.delayed(
      Duration(seconds: 2),
          () => products,
    );

  }


  @override
  Widget build(BuildContext context) {




    final bloc = Provider.of<Cart>(context, listen: false);
    if (bloc.itemCount>0){
      bloc.clear();}
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
        title: Text(
          "Menu del restaurant,  Costo de envío: \$  "+current_esquema ,
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

            FoodsWidget(_stproducts,widget.restaurant!.id_negocio   ),


          ],
        ),
      ),
    );
  }
}