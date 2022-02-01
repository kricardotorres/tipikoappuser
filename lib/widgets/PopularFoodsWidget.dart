import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipiko_app_usr/animation/RotationRoute.dart';
import 'package:tipiko_app_usr/animation/ScaleRoute.dart';
import 'package:tipiko_app_usr/data/product.dart';
import 'package:tipiko_app_usr/pages/food_details_page.dart';

import '../cart_bloc.dart';
//import 'package:tipiko_app_usr/pages/FoodDetailsPage.dart';

class PopularFoodsWidget extends StatefulWidget {

  Future<List<Product>>? products;

  late final ScrollController scrollController ;
  int restaurant_id;

  PopularFoodsWidget( this.products, this.scrollController, this.restaurant_id );



  @override
  _PopularFoodsWidgetState createState() => _PopularFoodsWidgetState();
}

class _PopularFoodsWidgetState extends State<PopularFoodsWidget> {



  list() {
    return  FutureBuilder<List>(
      future: widget.products,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {

          return Text("Espere");
        }
        if (snapshot.hasData) {
          return dataTable(List<Product>.from(snapshot.data!)   );
        }


        return Text("Espere");
      },
    );
  }
  SingleChildScrollView dataTable(List<Product> products) {
    return SingleChildScrollView(
      child: Container(
        height: double.maxFinite,
        child:  ListView.builder(shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return  PopularFoodTiles(name: products[index].nombreProducto, imageUrl: products[index].urlImagenProducto, rating: "",
                  numberOfRating: "",
                  price: products[index].Precio.toString(),
                  slug: "",
                product: products[index]
              );



            }),),




      controller: widget.scrollController,

    );
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      height: 265,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          PopularFoodTitle(),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height-200,
              child:ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  list(),

                ],
              ),
            ) ,
          )
        ],
      ),
    );
  }
}

class PopularFoodTiles extends StatelessWidget {
  String name;
  String imageUrl;
  String rating;
  String numberOfRating;
  String price;
  String slug;
  Product product;

  PopularFoodTiles(
      {
       required this.name,
       required this.imageUrl,
       required this.rating,
       required this.numberOfRating,
       required this.price,
       required this.slug,

        required this.product})
       ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {


        final bloc = Provider.of<Cart>(context, listen: false);
       // if (bloc.itemCount>0){
        //  bloc.clear();}
       //  Navigator.push(context, ScaleRoute(page: FoodDetailsPage( product : product, restaurant_id: ,  )));
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            decoration: BoxDecoration(boxShadow: [
               BoxShadow(
                color: Color(0xFFfae3e2),
                blurRadius: 15.0,
                offset: Offset(0, 0.75),
              ),
            ]),
            child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(2.0),
                  ),
                ),
                child: Container(
                  width: 208,
                  height: 208,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              alignment: Alignment.topRight,
                              width: double.infinity,
                              padding: EdgeInsets.only(right: 5, top: 5),
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white70,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFfae3e2),
                                        blurRadius: 25.0,
                                        offset: Offset(0.0, 0.75),
                                      ),
                                    ]),
                                child: Icon(
                                  Icons.favorite,
                                  color: Color(0xFFfb3132),
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Center(
                                child: Image.network(imageUrl ,
                                  width: 130,
                                  height: 140,)),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 5, top: 5),
                            child: Text(name,
                                style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(right: 5),
                            child: Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white70,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFfae3e2),
                                      blurRadius: 25.0,
                                      offset: Offset(0.0, 0.75),
                                    ),
                                  ]),
                              child: Icon(
                                Icons.near_me,
                                color: Color(0xFFfb3132),
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 5, top: 5),
                                child: Text(rating,
                                    style: TextStyle(
                                        color: Color(0xFF6e6e71),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400)),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 3, left: 5),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Color(0xFFfb3132),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Color(0xFFfb3132),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Color(0xFFfb3132),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Color(0xFFfb3132),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Color(0xFF9b9b9c),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 5, top: 5),
                                child: Text("($numberOfRating)",
                                    style: TextStyle(
                                        color: Color(0xFF6e6e71),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 5, top: 5, right: 5),
                            child: Text('\$' + price,
                                style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          )
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class PopularFoodTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Nuestras recomendaciones",
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFF3a3a3b),
                fontWeight: FontWeight.w300),
          ),
          Text(
            "Ver todo",
            style: TextStyle(
                fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w100),
          )
        ],
      ),
    );
  }
}


