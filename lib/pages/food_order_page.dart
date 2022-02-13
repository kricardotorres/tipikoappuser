import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipiko_app_usr/animation/ScaleRoute.dart';
import 'package:tipiko_app_usr/api/api.dart';
import 'package:tipiko_app_usr/data/price_scheme.dart';
import 'package:tipiko_app_usr/data/restaurant.dart';
import 'package:tipiko_app_usr/views/UAdresslist.dart';

import '../cart_bloc.dart';
class FoodOrderPage extends StatefulWidget {
  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  int counter = 3;

  var restaurant;
  double totalDistance = 0;
  @override
  void initState() {
    super.initState();


    Future.delayed(Duration.zero, () {

      final cart = Provider.of<Cart>(context, listen: false);
      if(cart.items.values.toList()[0]!=null){



        _getRestaurant(cart.items.values.toList()[0].store_id.toString());


      }
    });
  }

  _FoodOrderPageState(){



  }

  _getRoutes(String distancia ) async {
    setState(() {
      priceSchemes= getPriceSchemes(distancia) as Future<List<PriceScheme>>;
    });


  }
  var seted_schema;
  Future<List<PriceScheme>> getPriceSchemes(String distancia ) async {

    Api.getprecioenvio(distancia).then((response) {
      setState(() {
        var json_o = json.decode(response.body);
        var ctg= PriceScheme.fromJson(json_o['Cuerpo']);
        current_esquema=ctg.precio.toString();
        seted_schema=ctg;
        _priceSchemes!.add(ctg);
      });
    });
    return _priceSchemes;
  }

  _getRestaurant(String restaurantid ) async {

    setState(() {
      restaurants= getRestaurants(restaurantid) as Future<List<Restaurant>>;
    });


  }

  Future<List<Restaurant>> getRestaurants(String idrestaurant ) async {

    Api.getrestaurantdata(idrestaurant).then((response) {
      setState(() {
        var json_o = json.decode(response.body);

        var ctg= Restaurant.fromJson3(json_o['Cuerpo']);
         restaurant=ctg ;
        _restaurants!.add(ctg);
        var sharedPreferences;
        SharedPreferences.getInstance().then((SharedPreferences sp) {
          sharedPreferences = sp;
          String client_address = 'client_address';
          String client_direccion_ = 'client_direccion';

          String client_latitud = 'client_latitud';
          String client_longitud = 'client_longitud';
          String uuid =  'uuid';

          var current_lat=sharedPreferences.get(client_latitud).toString();
          var current_lng=sharedPreferences.get(client_longitud).toString();
          cliend_dir_id= sharedPreferences.get(client_address).toString();
          client_id= sharedPreferences.get(uuid).toString();
          client_direccion= sharedPreferences.get(client_direccion_).toString();

          if(cliend_dir_id== "null"&&client_id!="null"){
            Navigator.push(context, ScaleRoute(page: UAddresslistview(int.parse(client_id))));
          }else{
            List<dynamic> data = [
              {
                "lat": double.parse(current_lat),
                "lng": double.parse(current_lng)
              },{
                "lat": double.parse(restaurant!.latitude),
                "lng": double.parse(restaurant!.longitude)
              } ,
            ];
            for(var i = 0; i < data.length-1; i++){
              totalDistance += calculateDistance(data[i]["lat"], data[i]["lng"], data[i+1]["lat"], data[i+1]["lng"]);
            }
            _getRoutes(  (totalDistance*1000).toStringAsFixed(0) );
            }
        });

      });
    });
    return _restaurants;
  }
  Future<List<Restaurant>>? restaurants;
  List<Restaurant> _restaurants = [];
  Future<List<PriceScheme>>? priceSchemes;
  List<PriceScheme> _priceSchemes = [];
  var cliend_dir_id;
  var client_id;
  String current_esquema="0";
  String client_direccion=" ";
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  void _showSnackBar(String text) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:   Text(text),
      duration: const Duration(seconds: 10),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
         },
      ),
    ));
  }


  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);





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
          title: Center(
            child: Text(
              "Productos + envio(\$$current_esquema)",
              style: TextStyle(
                  color: Color(0xFF3a3737),
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          brightness: Brightness.light,
          actions: <Widget>[

          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "Mi carrito",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),


                SizedBox(

                  height: MediaQuery.of(context).size.height*.60,
                  child: ListView.builder(
                    itemCount: cart.itemCount,
                    itemBuilder: (context, i) => CartItem(
                      id: cart.items.values.toList()[i].id,
                      productId: cart.items.keys.toList()[i],
                      price: cart.items.values.toList()[i].price,
                      quantity: cart.items.values.toList()[i].quantity,
                      title: cart.items.values.toList()[i].title,
                      restaurant_id: cart.items.values.toList()[i].store_id,
                    ),
                  ),
                ),


                SizedBox(
                  height: 10,
                ),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color(0xFFfae3e2).withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ]),
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 25, right: 30, top: 10, bottom: 10),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Total",
                          style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF3a3a3b),
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                        Chip(
                          label: Text('\$${(cart.totalAmount+double.parse(current_esquema)).toStringAsFixed(2)}',style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.w600),
                            textAlign: TextAlign.left,
                          ),
                          backgroundColor: Colors.white
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    if(client_id!=null){

                      Api.getLastCart(client_id).then((response) {

                          var json_o = json.decode(response.body);

                          Map<String, dynamic> carrito ={ "id_Pedido": json_o['Cuerpo']['id_Pedido'].toString(),
                            "Negocio": restaurant.id_negocio.toString(),
                            "Cliente":  json_o['Cuerpo']['Cliente'].toString(),
                            "id_esquema_cobro": seted_schema.id_esquema.toString(),
                            "Repartidor": "0",
                            "id_direccion": cliend_dir_id.toString() ,
                            "Estatus": "1"};
                          var user_list=[];
                          final cart = Provider.of<Cart>(context, listen: false);

                          for(int i=0;i<cart.items.values.toList().length;i++){
                            Map<String, dynamic> item= {

                              "Id_Pedido_Detalle": 0.toString(),
                              "Producto":  cart.items.values.toList()[i].id,

                              "Cantidad": cart.items.values.toList()[i].quantity.toString(),
                            };
                            user_list.add(item);
                          }

                          carrito.addAll({"ListaPedidos" :   (user_list)   });



                           Api.postLastCart(json.encode(carrito)).then((response) {

                           var json_o = json.decode(response.body);

                             if (json_o['Codigo']==200){
                               Map<String, dynamic> carrito_confirm ={ "idPedido": json_o['Cuerpo']['id_Pedido'].toString(),
                                 "id_estatus": "5"};

                               Api.postConfirmarEstatusPedido(json.encode(carrito_confirm)).then((response) {

                                 var json_o = json.decode(response.body);

                                 if (json_o['Codigo']==200){

                                   _showSnackBar("Pedido creado! En unos momentos el restaurant te confirmará el pedido");

                                   if (cart.itemCount>0){
                                     cart.clear();}
                                   Navigator.of(context).pop();
                                 }else{
                                   _showSnackBar("Falló :(");
                                 }

                               });
                             }

                          });

                      });

                    }

                  },
                  child: Container(
                    width: 200.0,
                    height: 45.0,
                    decoration: new BoxDecoration(
                      color: Color(0xFFfd2c2c),
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        'De acuerdo! Ordenar !',
                        style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                )
                //PaymentMethodWidget(),
              ],
            ),
          ),
        ));
  }
}

class PaymentMethodWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 10, right: 30, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/menus/ic_credit_card.png",
                  width: 50,
                  height: 50,
                ),
              ),
              Text(
                "Credit/Debit Card",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3a3a3b),
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
      ),
    );
  }
}



class PromoCodeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 3, right: 3),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0xFFfae3e2).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ]),
        child: TextFormField(
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFe6e1e1), width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFe6e1e1), width: 1.0),
                  borderRadius: BorderRadius.circular(7)),
              fillColor: Colors.white,
              hintText: 'Add Your Promo Code',
              filled: true,
              suffixIcon: IconButton(
                  icon: Icon(
                    Icons.local_offer,
                    color: Color(0xFFfd2c2c),
                  ),
                  onPressed: () {

                  })),
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final int restaurant_id;

  const CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.productId,
    required this.restaurant_id,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Dismissible(
        direction: DismissDirection.endToStart,
        key: ValueKey(id),
        background: Container(
          padding: EdgeInsets.only(right: 20),
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
        ),
        onDismissed: (direction) {
          cart.removeItem(productId);
        },
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Remover producto?'),
              content: Text('Desea remover este producto?'),
              actions: [
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('Si'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(2),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title ),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
class CartIconWithBadge extends StatelessWidget {
  int counter = 3;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.business_center,
              color: Color(0xFF3a3737),
            ),
            onPressed: () {}),
        counter != 0
            ? Positioned(
          right: 11,
          top: 11,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 14,
              minHeight: 14,
            ),
            child: Text(
              '$counter',
              style: TextStyle(
                color: Colors.red,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
            : Container()
      ],
    );
  }
}

class AddToCartMenu extends StatelessWidget {
  int productCounter;

  AddToCartMenu(this.productCounter);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.remove),
            color: Colors.black,
            iconSize: 18,
          ),
          InkWell(
            onTap: () => print('hello'),
            child: Container(
              width: 100.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: Color(0xFFfd2c2c),
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Text(
                  'Add To $productCounter',
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
            color: Color(0xFFfd2c2c),
            iconSize: 18,
          ),
        ],
      ),
    );
  }
}