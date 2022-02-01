 
class PriceScheme  {
int id_esquema;
double precio;
PriceScheme(
{ required this.id_esquema,
required this.precio, }
);


Map<String, dynamic> toMap() {
var map = <String, dynamic>{
'id_esquema': id_esquema,
'precio': precio
};
return map;
}



factory  PriceScheme.fromJson(Map<String, dynamic> parsedJson) {
Map json = parsedJson ;

  return PriceScheme(

    id_esquema : json['id_esquema'],
    precio : json['precio'],
);
}



}