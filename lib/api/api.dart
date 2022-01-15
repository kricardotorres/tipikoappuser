import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "http://ec2-3-16-169-49.us-east-2.compute.amazonaws.com/tipikodev/api";

class Api {



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
}