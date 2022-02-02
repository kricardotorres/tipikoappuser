

class Product {
  int id_producto;
  String nombreNegocio, nombreProducto, descripcionProducto,
      urlImagenProducto, fechaInicioPromocion, fechaFinPromocion ;
  var Precio;
  bool Activo;
  int restaurant_id;



  Product({

    required this.id_producto,
    required this.nombreNegocio,
    required  this.nombreProducto,
    required  this.descripcionProducto,
    required  this.urlImagenProducto,
    required this.fechaInicioPromocion,
    required this.fechaFinPromocion,
    required this.Activo,
    required this.Precio,
    required this.restaurant_id,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id_producto": id_producto,
      "nombreNegocio": nombreNegocio,
      "nombreProducto": nombreProducto,
      "descripcionProducto": descripcionProducto,
      "urlImagenProducto": urlImagenProducto,
      "fechaInicioPromocion": fechaInicioPromocion,
      "fechaFinPromocion": fechaFinPromocion,
      "Activo": Activo,
      "Precio": Precio,
      "id_negocio": restaurant_id

    };
    return map;
  }
  factory  Product.fromJson(Map<dynamic, dynamic> parsedJson) {
    Map json = parsedJson ;


    return Product(

        id_producto : json['id_producto'],
        nombreNegocio : json['nombreNegocio'],
        nombreProducto : json['nombreProducto'],
        descripcionProducto : json['descripcionProducto'],
        urlImagenProducto : json['urlImagenProducto'],
        fechaInicioPromocion : json['fechaInicioPromocion'],
        fechaFinPromocion : json['fechaFinPromocion'],
      Activo:  json['Activo'],
        Precio :json['Precio'],
        restaurant_id : json['id_negocio'] ?? 0
    );
  }
  factory  Product.fromJson2(Map<String, dynamic> parsedJson) {
    Map json = parsedJson ;


    return Product(

        id_producto : json['id_producto'],
        nombreNegocio : "",
        nombreProducto : json['NombreProducto'],
        descripcionProducto : json['DescripcionProducto'],
        urlImagenProducto : json['UrlImagen'],
        fechaInicioPromocion : "",
        fechaFinPromocion : "",
        Activo:  true,
        Precio :json['Precio'],
        restaurant_id : json['id_negocio'] ?? 0
    );
  }


  factory  Product.fromJson3(Map<String, dynamic> parsedJson) {
    Map json = parsedJson ;


    return Product(


        id_producto : json['id_producto'],
        nombreNegocio : "",
        nombreProducto : json['NombreProducto'],
        descripcionProducto : json['DescripcionProducto'],
        urlImagenProducto : json['UrlImagen'],
        fechaInicioPromocion : "",
        fechaFinPromocion : "",
        Activo:  true,
        Precio :json['Precio'],
        restaurant_id : json['id_negocio']  ?? 0
    );
  }



}