import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tipiko_app_usr/animation/ScaleRoute.dart';
import 'package:tipiko_app_usr/api/api.dart';
import 'package:tipiko_app_usr/data/category.dart';
import 'package:tipiko_app_usr/data/product.dart';
import 'package:tipiko_app_usr/data/restaurant.dart';
import 'package:tipiko_app_usr/widgets/BestFoodWidget.dart';
import 'package:tipiko_app_usr/widgets/BottomNavBarWidget.dart';
import 'package:tipiko_app_usr/widgets/FoodlistWidget.dart';
import 'package:tipiko_app_usr/widgets/PopularFoodsWidget.dart';
import 'package:tipiko_app_usr/widgets/TopMenus.dart';

import 'json_restful_api.dart';


class HomePageCategory extends StatefulWidget {

   Restaurant  ? restaurant;


  HomePageCategory( this.restaurant  );

  @override
  _HomePageCategoryState createState() => _HomePageCategoryState();
}
class _HomePageCategoryState extends State<HomePageCategory> {

  List<Product> ? _stproducts = [];
  @override
  void initState() {
    super.initState();
    _getRoutes();

    print(widget.restaurant!.productos );
    print("Aver como sale es nulo?");
    print(widget.restaurant!.productos );
    for (int i = 0; i < widget.restaurant!.productos!.length; i++)  {
      var prjson_ooduct=   widget.restaurant!.productos![i];
        print("zzzzzzzzzzzz");
      print(prjson_ooduct);
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
  }
  _getRoutes( ) async {
    setState(() {
      categories= getcategories() as Future<List<Category>>;
      productos_promotion= getproductos_promotion() as Future<List<Product>>;
    });


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

    print(_products.length.toString()+"aaaaaaaaaaaaaaaaaaaa");
    return _products;
  }
  _HomePageState() {



    controller_destiny.addListener(() {
      if (controller_destiny.text.isEmpty) {
        products = getProducts("" );
      } else {

        setState(() {

          print("Esto deberia estar pasando");
          _products.clear();

          products = getProducts(controller_destiny.text);
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

  Future<List<Product?>> getproductos_search( )   {

    return Future.delayed(
      Duration(seconds: 2),
          () => products,
    );

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
              title: Text( (suggestion as Product).nombreProducto.toString()),
              subtitle: Text( (suggestion as Product).descripcionProducto.toString()),
            );
          },
          onSuggestionSelected: (suggestion) {
            controller_destiny.text= suggestion.toString();

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

            TopMenus(categories ,_scrollController),
            FoodsWidget(_stproducts   ),


          ],
        ),
      ),
    );
  }
}