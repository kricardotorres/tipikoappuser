import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipiko_app_usr/data/json_user.dart';
import 'package:tipiko_app_usr/data/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'dart:async';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';
import 'package:tipiko_app_usr/api/api.dart';
import 'package:tipiko_app_usr/data/route.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:location/location.dart';

import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:tipiko_app_usr/data/u_address.dart';
import 'bus_list.dart';


const String spKey = 'myBool';
const String key = 'access_token';
const String email = 'email';

const String  uuid = 'uuid';
const String  client = 'client';
class MapNearest extends StatefulWidget {
    String title;
      Map<String, double> passed_Location;
  MapNearest( {   required this.title,  required this.passed_Location })  ;

  @override
  State<StatefulWidget> createState() {
    return _MapNearestPageState();
  }


}

JsonUser currentUser = new JsonUser(email: '', access_token: '', client: '', uuid: '');
class _MapNearestPageState extends State<MapNearest>   with TickerProviderStateMixin {
  late Future<List<Place?>> places ;
  List<Place?> _places = [];
   Future<List<BusRoute?>>  ?  bus_routes;


  List<BusRoute?> _bus_routes = [];
  Future<List<UAddress?>>  ?  uaddress;


  List<UAddress?> _uaddress = [];


  Location location = Location();
  var json_o;
  var currentLocation;
  late Marker  marker ;
  late SharedPreferences sharedPreferences;

  late bool _testValue=false;
  ScrollController _scrollController = new ScrollController();
  Future<List<Place?>> getPlaces(String name) async {

    Api.getGeoPlace_search(name).then((response) {
      setState(() {
        _places!.clear();
        json_o = json.decode(response.body);
        if (json_o["candidates"].length > 0) {
          for (int i = 0; i < json_o['candidates'].length; i++) {
            _places!.add(Place.fromJson(json_o['candidates'][i]));
          }
        }
      });
    });

    return _places;
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      var authenticationToken_load = sharedPreferences.get(key).toString();
      var emailload  = sharedPreferences.get(email).toString();
      var client_load  = sharedPreferences.get(client).toString();
      var uuid_load  = sharedPreferences.get(uuid).toString();

      currentUser = JsonUser(email: emailload , access_token : authenticationToken_load, client: client_load, uuid: uuid_load);
      // will be null if never previously saved
      if (authenticationToken_load  == "null") {
        _testValue = false;
      }else {_testValue = true;}

    });
    mapController = MapController();

    location.onLocationChanged.listen((value) {

        currentLocation = value  ;


    });



    marker = Marker(
      width: 90.0,
      height: 90.0,
      point: LatLng(widget.passed_Location!["latitude"]!, widget.passed_Location!["longitude"]!),
      builder: (ctx) =>
          Container(
            child: const Icon(Icons.person_pin_circle,),
          ),
    );

    getPlaces_from_latlng(LatLng(widget.passed_Location!["latitude"]!, widget.passed_Location!["longitude"]!));


  }
  Future<List<Place?>> getPlaces_from_latlng(LatLng latLng) async  {

    Api.getGeoPlace_from_latlng(latLng.latitude.toString(),latLng.longitude.toString()).then((response) {
      setState(() {

        json_o = json.decode(response.body);

        controller_direccion.text = (json_o['results'][0]['formatted_address']);

        for (int i = 0; i < json_o['results'][0]['address_components'].length; i++) {

          if( json_o['results'][0]['address_components'][i]['types'].toString()== '[route]' )
            {controller_calle.text = (json_o['results'][0]['address_components'][i]['long_name']);break;}else{
            controller_calle.text="";
          }


        }
        for (int i = 0; i < json_o['results'][0]['address_components'].length; i++) {


          if( json_o['results'][0]['address_components'][i]['types'].toString()== '[political, sublocality, sublocality_level_1]' )
          {controller_colonia.text = (json_o['results'][0]['address_components'][i]['long_name']);
          break;
          }else{
            controller_colonia.text="";
          }

        }
        for (int i = 0; i < json_o['results'][0]['address_components'].length; i++) {


          if( json_o['results'][0]['address_components'][i]['types'].toString()== '[street_number]' )
          {controller_numInteriro.text = (json_o['results'][0]['address_components'][i]['long_name']);break;
          }else{
            controller_numInteriro.text="";
          }


        }

        controller_latitud.text = latLng.latitude.toString();
        controller_longitud.text = latLng.longitude.toString();
      });
    });

    return _places;
  }


  late MapController mapController;
  @override
  void dispose() {
    super.dispose();
  }



  Future<List<BusRoute?>> getBusRoutes(LatLng latLng) async {

    Api.getnearest_routes(latLng.latitude.toString(),latLng.longitude.toString()).then((response) {
      setState(() {
        json_o = json.decode(response.body);
        if (json_o.length > 0) {
          for (int i = 0; i < json_o.length; i++) {
            _bus_routes!.add(BusRoute.fromJson(json_o[i]));
          }
        }
      });
    });

    return _bus_routes;
  }


  Future<List<UAddress?>> postDireccion(UAddress ? uaddress) async {

    Api.postAddres(uaddress).then((response) {
      setState(() {
        json_o = json.decode(response.body);
        _showSnackBar("Dirección guardada!");
        Navigator.of(context).pop();


      });
    });

    return _uaddress;
  }



  void _handleTap(TapPosition tapPosition, LatLng latlng) {

    _set_marker_on_map(latlng);

    getPlaces_from_latlng(latlng);

    setState(() {
     // _bus_routes!.clear();
     // bus_routes =  getBusRoutes(latlng)  ;

    });


  }
  _set_place_on_map(Place ? place){
    _set_marker_on_map(place!.ubication);
  }
  _set_marker_on_map(LatLng latlng){

    Marker _marker = Marker(
      width: 90.0,
      height: 90.0,
      point: (latlng),
      builder: (ctx) =>
          Container(
            child: const Icon(Icons.person_pin_circle,),
          ),
    );
    setState(() {
      marker = _marker;
    });

    _animatedMapMove(latlng, 16.0);

  }
  TextEditingController controller_direccion = TextEditingController();
  TextEditingController controller_calle = TextEditingController();
  TextEditingController controller_colonia = TextEditingController();
  TextEditingController controller_referencia = TextEditingController();
  TextEditingController controller_numExterior = TextEditingController();
  TextEditingController controller_numInteriro = TextEditingController();
  TextEditingController controller_latitud = TextEditingController();
  TextEditingController controller_longitud = TextEditingController();
  TextEditingController controller_cruzamientos = TextEditingController();



  _MapNearestPageState() {
    controller_direccion.addListener(() {
      if (controller_direccion.text.isEmpty) {
        places = getPlaces("" );
      } else {

        setState(() {

          _places!.clear();

          places =  getPlaces(controller_direccion.text)  ;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    String defaultFontFamily = 'EBGaramond-Regular.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;
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
          "Nueva Dirección",
          style: TextStyle(
              color: Color(0xFF3a3737),
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        brightness: Brightness.light,
        actions: <Widget>[

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(currentLocation!=null){

            _set_marker_on_map(LatLng(
                currentLocation.latitude, currentLocation.longitude));

            getPlaces_from_latlng(LatLng(
                currentLocation.latitude, currentLocation.longitude));
            setState(() {
             // _bus_routes!.clear();
             // bus_routes =  getBusRoutes(LatLng(
                //  currentLocation.latitude, currentLocation.longitude))  ;
            });
          }
        },
        child: const Icon(Icons.location_on,),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[

            Flexible(

              child:   FlutterMap(

                mapController: mapController,
                options: MapOptions(
                  center: LatLng(widget.passed_Location!["latitude"]!, widget.passed_Location!["longitude"]!),

                  maxZoom: 17.0,
                  zoom: 16.0,
                  minZoom: 14.0,
                  onTap: (_handleTap)  ,
                ),

                layers: [
                  TileLayerOptions(

                    urlTemplate: "https://api.mapbox.com/styles/v1/kricardotorres/ck2u1c1ip5w7g1cnw3nvvgkgl/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia3JpY2FyZG90b3JyZXMiLCJhIjoiY2syYnp4cGxnMDF1YjNtcWNmcnZ4eTZtZCJ9.L8IZ8wU9-he3bXIJmAbYTQ",
                    additionalOptions: {
                      'accessToken': 'pk.eyJ1Ijoia3JpY2FyZG90b3JyZXMiLCJhIjoiY2syYnp4cGxnMDF1YjNtcWNmcnZ4eTZtZCJ9.L8IZ8wU9-he3bXIJmAbYTQ',
                      'id': 'mapbox.streets',
                    },
                  ),

                  MarkerLayerOptions(

                      markers:
                      <Marker>[marker ]),
                ],
              ),
            ),

            Container(

              child:       Padding(
                padding: EdgeInsets.all(5.0),
                child:
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller:   controller_direccion,
                    decoration: InputDecoration(

                      suffixIcon: IconButton(
                          icon: const Icon(Icons.backspace,
                            color: Colors.orange,),
                          onPressed: () {
                            controller_direccion.text='';
                          }),
                      prefixIcon: const Icon(Icons.location_on,
                        color: Colors.orange,)
                      ,
                      border: const OutlineInputBorder(),
                      hintText: 'Buscar ubicación',
                      hintStyle:const TextStyle(    fontFamily: "EBGaramond"),

                    ),
                    style:const TextStyle(  fontWeight: FontWeight.w300,      fontFamily: "EBGaramond" ),

                  ),
                  suggestionsCallback: (pattern) async {


                    return Future.delayed(
                      const Duration(seconds: 2),
                          () => places,
                    );
                    // ;
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text((suggestion as Place).place_name,style: const TextStyle(   fontFamily: "EBGaramond" ),),
                      subtitle: Text((suggestion as Place).address,style: const TextStyle(    fontFamily: "EBGaramond" ),),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    controller_direccion.text= (suggestion as Place).address;
                    _set_place_on_map(suggestion);
                    setState(() {
                     //_bus_routes!.clear();
                    //  bus_routes =  getBusRoutes((suggestion as Place).ubication) ;

                    });
                  },
                ),
              ),
            ),
            Form(
              key: formKey,
              child:   Column(
                children: [
                    TextFormField(
                      controller: controller_calle,
                    keyboardType: TextInputType.text,

                      style: const TextStyle(    fontFamily: "EBGaramond" ),
                      showCursor: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xFFF2F3F5),
                        hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize),
                        hintText: "Referencia",
                      ),
                    validator: (val) =>
                    val!.length == 0 ?"Introduce una referencia" : null,
                    onSaved: (val) => controller_calle.text = val!,
                  )
                  ,
                  TextFormField(
                    controller: controller_numInteriro,
                    keyboardType: TextInputType.text,

                    style: const TextStyle(    fontFamily: "EBGaramond" ),
                    showCursor: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Número de casa",
                    ),
                    validator: (val) =>
                    val!.length == 0 ?"Introduce un número de casa" : null,
                    onSaved: (val) => controller_numInteriro.text = val!,
                  )
                  ,
                  TextFormField(
                    controller: controller_cruzamientos,
                    keyboardType: TextInputType.text,

                    style: const TextStyle(    fontFamily: "EBGaramond" ),
                    showCursor: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Cruzamientos",
                    ),
                    validator: (val) =>
                    val!.length == 0 ?"Introduce los cruzamientos" : null,
                    onSaved: (val) => controller_cruzamientos.text = val!,
                  )
                  ,
                  TextFormField(
                    controller: controller_colonia,
                    keyboardType: TextInputType.text,

                    style: const TextStyle(    fontFamily: "EBGaramond" ),
                    showCursor: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Colonia",
                    ),
                    validator: (val) =>
                    val!.length == 0 ?"Introduce nombre de colonia" : null,
                    onSaved: (val) => controller_colonia.text = val!,
                  )
                  ,
                  TextFormField(
                    controller: controller_referencia,
                    keyboardType: TextInputType.text,

                    style: const TextStyle(    fontFamily: "EBGaramond" ),
                    showCursor: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Referencias",
                    ),
                    validator: (val) =>
                    val!.length == 0 ?"Introduce una referencia" : null,
                    onSaved: (val) => controller_referencia.text = val!,
                  )
                  ,
                  TextFormField(
                    controller: controller_numExterior,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(    fontFamily: "EBGaramond" ),
                    showCursor: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Número exterior",
                    ),

                    onSaved: (val) => controller_numExterior.text = val!,
                  )
                  ,
                  Visibility(
                    visible: false,
                    child:
                    TextFormField(
                      controller: controller_latitud,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(    fontFamily: "EBGaramond" ),
                      showCursor: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xFFF2F3F5),
                        hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize),
                        hintText: "Latitud",
                      ),
                      validator: (val) =>
                      val!.length == 0 ?"Seleccione un punto en el mapa" : null,
                      onSaved: (val) => controller_latitud.text = val!,
                    )
                    ,
                  ),
                  Visibility(
                    visible: false,
                      child:
                      TextFormField(
                        controller: controller_longitud,
                        keyboardType: TextInputType.text,
                        showCursor: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF2F3F5),
                          hintStyle: TextStyle(
                              color: Color(0xFF666666),
                              fontFamily: defaultFontFamily,
                              fontSize: defaultFontSize),
                          hintText: "Longitud",
                        ),
                        validator: (val) =>
                        val!.length == 0 ?"Seleccione un punto en el mapa" : null,
                        onSaved: (val) => controller_longitud.text = val!,
                      )
                    ,
                  ),
                  Container(margin: const EdgeInsets.only(top: 10.0),child:   ElevatedButton(onPressed: _submit,
                    child:   Text('Guardar Dirección'),),)

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  final formKey =   GlobalKey<FormState>();
  void _submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    }else{
      return;
    }

    var ua= UAddress( id_direccion:0,     id_cliente: int.parse( currentUser.uuid),     tipoDireccionId: 1,     cruzamientos: controller_cruzamientos.text,     numInteriro: controller_numInteriro.text,
      numExterior: controller_numExterior.text,     referencia: controller_referencia.text,

      calle:controller_calle.text,     direccion:controller_direccion.text,     colonia:controller_colonia.text,     latitud:controller_latitud.text,     longitud:controller_longitud.text,  );
    postDireccion(ua);

  }

  void _showSnackBar(String text) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:   Text(text),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          Navigator.of(context).pop();},
      ),
    ));
  }

  void _animatedMapMove(LatLng destLocation, double destZoom)  {
    final _latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    Animation<double> animation =
    CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

}