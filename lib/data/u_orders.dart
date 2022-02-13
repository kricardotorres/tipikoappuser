
class UOrder {
int id_Pedido;
double Subtotal;
double
    Total  ;
String fecha;
var ListaProductos   ;

UOrder({
required this.id_Pedido,
required this.Subtotal,
required  this.fecha,
required  this.Total,
required  this.ListaProductos,
});

Map<String, dynamic> toMap() {
var map = <String, dynamic>{
"id_Pedido": id_Pedido,
"Subtotal": Subtotal,
"fecha": "",
"Total": Total,
"ListaProductos": ListaProductos,
};
return map;
}
factory  UOrder.fromJson(Map<String, dynamic> parsedJson) {
Map json = parsedJson ;


return UOrder(

  id_Pedido : json['id_Pedido'],
  Subtotal : json['Subtotal'],
  fecha : "",
  Total : json['Total'] ,
  ListaProductos : json['ListaProductos'],

);
}



}
