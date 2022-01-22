import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:tipiko_app_usr/data/place.dart';
import 'package:tipiko_app_usr/data/u_address.dart';

const baseUrl = "http://ec2-3-16-169-49.us-east-2.compute.amazonaws.com/tipikodev/api";

class Api {


  static Future postAddres(UAddress ? uaddress ) {
    var url = baseUrl + "/Cliente/AgregarModificarDireccion" ;


    return http.post(Uri.parse(url), body: uaddress!.toMap());
  }

  static Future getCategories( ) {
    var url = baseUrl + "/Negocio/ObtenerCategorias" ;
    return http.get(Uri.parse(url));
  }
  static Future getCategoriesRestaurants(int ? id ) {
    var url = baseUrl + "/Negocio/ObtenerNegocioPorCategoria?id_categoria="+id.toString() ;
    return http.get(Uri.parse(url));
  }
  static Future getProductosEnPromocion( ) {
    var url = baseUrl + "/Negocio/ObtenerProductosEnPromocion" ;
    return http.get(Uri.parse(url));
  }
  static Future getRestaurants_search(String name   ) {
    //   "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input="+name+"&inputtype=textquery&fields=formatted_address,name,geometry&key=%20AIzaSyDLPnAwVK_9jOFO1ijDSgTV04ScZX8RNSo"
  //  var url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input="+name+"&inputtype=textquery&fields=formatted_address,name,geometry&key=%20AIzaSyDLPnAwVK_9jOFO1ijDSgTV04ScZX8RNSo";

    var url = baseUrl + "/Negocio/ObtenerNegocioPorParametro?nombreNegocio="+name ;
    return http.get(Uri.parse(url));
  }



  static Future get_one_route(int ? id) {
    var url =  "https://conmanoizquierda.com/bus_routes/"+id.toString()+".json";

    return http.get(Uri.parse(url));
  }

  static Future getGeoPlace_from_latlng(String lat, String lng   ) {
    var url =  "https://maps.googleapis.com/maps/api/geocode/json?latlng="+lat+","+lng+"&key=%20AIzaSyDLPnAwVK_9jOFO1ijDSgTV04ScZX8RNSo";

    return http.get(Uri.parse(url));
  }


  static Future getGeoPlace_search(String name   ) {
    //   "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input="+name+"&inputtype=textquery&fields=formatted_address,name,geometry&key=%20AIzaSyDLPnAwVK_9jOFO1ijDSgTV04ScZX8RNSo"
    var url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input="+name+"&inputtype=textquery&fields=formatted_address,name,geometry&key=%20AIzaSyDLPnAwVK_9jOFO1ijDSgTV04ScZX8RNSo";

    return http.get(Uri.parse(url));
  }


  static Future getnearest_routes(String lat, String lng ) {
    var url = "https://conmanoizquierda.com/bus_routes/get_neares_route.json?[q][lat]="+lat+"&[q][long]="+lng  ;

    return http.get(Uri.parse(url));
  }
}