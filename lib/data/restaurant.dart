


class Restaurant {
int id_negocio;
String Nombres, Direccion, Telefono,
UrlImagen, latitude, longitude ;


var productos   ;

Restaurant({
  required this.id_negocio,
required this.Nombres,
required  this.Direccion,
required  this.Telefono,
required  this.UrlImagen,
    required  this.productos,
  required  this.latitude,
  required  this.longitude,
});

Map<String, dynamic> toMap() {
var map = <String, dynamic>{
"id_negocio": id_negocio,
"Nombres": Nombres,
"Direccion": Direccion,
"Telefono": Telefono,
"UrlImagen": UrlImagen,
    "productos": productos,
  "latitud": latitude,
  "longitud": longitude,
};
return map;
}
factory  Restaurant.fromJson(Map<String, dynamic> parsedJson) {
Map json = parsedJson ;


return Restaurant(

    id_negocio : json['id_negocio'],
    Nombres : json['Nombres'],
    Direccion : json['Direccion'],
    Telefono : json['Telefono'].toString(),
    UrlImagen : json['UrlImagen'],
    productos:   json['ListaProductos'],
  latitude : json['latitud'],
  longitude : json['longitud'],
);
}

factory  Restaurant.fromJson2(Map<String, dynamic> parsedJson) {
  Map json = parsedJson ;


  return Restaurant(

      id_negocio : json['id_negocio'],
      Nombres : json['NombreNegocio'],
      Direccion : "",
      Telefono : "",
      UrlImagen : json['UrlImagen'],
      productos:   json['ListaProductos'],
    latitude : json['latitud'],
    longitude : json['longitud'],
  );
}


factory  Restaurant.fromJson3(Map<String, dynamic> parsedJson) {
  Map json = parsedJson ;


  return Restaurant(

    id_negocio : json['id_negocio'],
    Nombres : json['Nombres'],
    Direccion : "",
    Telefono : "",
    UrlImagen : json['UrlImagen'],
    productos:   "",
    latitude : json['latitud'],
    longitude : json['longitud'],
  );
}



}
