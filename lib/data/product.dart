class Product {
  int id;
  int id_producto;
  String nombreNegocio, nombreProducto, descripcionProducto,
      urlImagenProducto, fechaInicioPromocion, fechaFinPromocion ;
  var Precio;
  bool Activo;



  Product({
    required this.id,

    required this.id_producto,
    required this.nombreNegocio,
    required  this.nombreProducto,
    required  this.descripcionProducto,
    required  this.urlImagenProducto,
    required this.fechaInicioPromocion,
    required this.fechaFinPromocion,
    required this.Activo,
    required this.Precio,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "id_producto": id_producto,
      "nombreNegocio": nombreNegocio,
      "nombreProducto": nombreProducto,
      "descripcionProducto": descripcionProducto,
      "urlImagenProducto": urlImagenProducto,
      "fechaInicioPromocion": fechaInicioPromocion,
      "fechaFinPromocion": fechaFinPromocion,
      "Activo": Activo,
      "Precio": Precio
    };
    return map;
  }
  factory  Product.fromJson(Map<String, dynamic> parsedJson) {
    Map json = parsedJson ;


    return Product(

      id : json['id'],
        id_producto : json['id_producto'],
        nombreNegocio : json['nombreNegocio'],
        nombreProducto : json['nombreProducto'],
        descripcionProducto : json['descripcionProducto'],
        urlImagenProducto : json['urlImagenProducto'],
        fechaInicioPromocion : json['fechaInicioPromocion'],
        fechaFinPromocion : json['fechaFinPromocion'],
      Activo:  json['Activo'],
        Precio :json['Precio']
    );
  }





}