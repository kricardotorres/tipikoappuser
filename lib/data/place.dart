import 'package:latlng/latlng.dart';
class Place  {
  String? place_name;
  String? address;
  LatLng? ubication;

  Place(
      this.place_name,
      this.ubication,
      this.address
      );


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'place_name': place_name,
      'ubication': ubication,
      'address': address
    };
    return map;
  }
  Place.fromJson(Map json){


    place_name = json['name'] ;
    address = json['formatted_address'];
    ubication =  LatLng(json['geometry']['location']['lat'].toDouble(), json['geometry']['location']['lng'].toDouble() );
  }



  Place.fromMap(Map<String, dynamic> map) {

    place_name = map['name'] ;
    address = map['formatted_address'];
    ubication =  LatLng(map['geometry']['location']['lat'].toDouble(), map['geometry']['location']['lng'].toDouble() );
  }




}