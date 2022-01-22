
class UAddress  {
  int id_direccion, id_cliente;
  int tipoDireccionId;
  String cruzamientos;
  String numInteriro;
  String numExterior;
  String referencia;
  String calle;
  String direccion;
  String colonia;

  String latitud, longitud;






  UAddress(
      { required this.id_direccion,
        required this.id_cliente,
        required this.tipoDireccionId,
        required this.cruzamientos,
        required this.numInteriro,
        required this.numExterior,
        required this.referencia,
        required this.calle,
        required this.direccion,
        required this.colonia,
        required this.latitud,
        required this.longitud,}
      );


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{

      'tipoDireccionId': tipoDireccionId.toString(),
      'id_direccion': id_direccion.toString(),
      'id_cliente': id_cliente.toString(),
      'cruzamientos': cruzamientos,
      'numInteriro': numInteriro,
      'numExterior': numExterior,
      'referencia': referencia,
      'calle': calle,
      'nombre': direccion,
      'colonia': colonia,
      'latitud':latitud,
      'longitud' :longitud

    };
    return map;
  }



  factory  UAddress.fromJson(Map<String, dynamic> parsedJson) {
    Map json = parsedJson ;


    return UAddress(


        id_direccion:  json['id_direccion'] ,
        id_cliente:  json['id_cliente'] ,
        tipoDireccionId:  json['tipoDireccionId'] ,
        cruzamientos:  json['cruzamientos'] ,
        numInteriro:  json['numInteriro'] ,
        numExterior:  json['numExterior'] ,
        referencia:  json['referencia'] ,
        calle:  json['calle'] ,
        direccion:  json['direccion'] ,
        colonia:  json['colonia'] ,
        latitud: json['latitud'] ,
        longitud : json['longitud']
    );
  }



}