


import 'package:flutter/material.dart';
import 'package:tipiko_app_usr/data/u_orders.dart';


class  UOrdersList extends StatefulWidget {

  var   uOrder;


  UOrdersList( this.uOrder );



  @override
  _UOrdersListState createState() => _UOrdersListState();
}

class _UOrdersListState extends State<UOrdersList> {


  ScrollController _scrollController = new ScrollController();

  list() {


    return  FutureBuilder<List>(
      future: widget.uOrder,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {

          return Text("Espere");
        }
        if (snapshot.hasData) {
          return dataTable(List<UOrder>.from(snapshot.data!)   );
        }


        return Text("Espere");
      },
    );

    return dataTable(widget.uOrder);

  }
  SingleChildScrollView dataTable(List<UOrder> ? uOrder) {
    return SingleChildScrollView(
      child: ListView.builder(shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: uOrder!.length,
          itemBuilder: (context, index) {
            return  PopularFoodTiles(name: uOrder[index].id_Pedido.toString(), imageUrl: "",
                uOrder: uOrder[index]
            );



          }),




      controller:  _scrollController ,

    );
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          PopularFoodTitle(),
          Expanded(
            child:  ListView(
              children: <Widget>[
                list(),

              ],
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
  UOrder uOrder;

  PopularFoodTiles(
      {
        required this.name,
        required this.imageUrl,

        required this.uOrder})
  ;



  void _showSnackBar(String text,BuildContext context) {

    ScaffoldMessenger.of( context).showSnackBar(SnackBar(
      content:   Text(text),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          Navigator.of( context).pop();},
      ),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async {


        //  Navigator.push(context, ScaleRoute(page: FoodDetailsPage( UOrder : UOrder  )));
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
                  width: 308,
                  height: 108,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 5, top: 5),
                            child: Text(uOrder.id_Pedido.toString(),
                                style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Container(
                              width: 200,
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.only(left: 5, top: 5),
                              child: Text(uOrder.Total.toString() , overflow: TextOverflow.ellipsis, maxLines: 10)
                          ),
                        ],
                      ),
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
        ],
      ),
    );
  }
}


