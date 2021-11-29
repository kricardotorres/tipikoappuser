import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "http://40.71.216.78/tipikodev/api";

class Api {



  static Future getCategories( ) {
    var url = baseUrl + "/Negocio/ObtenerCategorias" ;
    return http.get(Uri.parse(url));
  }
  static Future getProductosEnPromocion( ) {
    var url = baseUrl + "/Negocio/ObtenerProductosEnPromocion" ;
    return http.get(Uri.parse(url));
  }

}