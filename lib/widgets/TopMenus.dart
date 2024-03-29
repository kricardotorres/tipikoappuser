import 'package:flutter/material.dart';
import 'package:tipiko_app_usr/animation/ScaleRoute.dart';
import 'package:tipiko_app_usr/data/category.dart';
import 'package:tipiko_app_usr/views/homepage_3Cat.dart';
import 'package:tipiko_app_usr/views/json_restful_api.dart';

class TopMenus extends StatefulWidget {

  Future<List<Category>>? categories;

  late final ScrollController scrollController ;

  var testValue;
  TopMenus( this.categories, this.scrollController,    this.testValue  );



  @override
  _TopMenusState createState() => _TopMenusState();
}

class _TopMenusState extends State<TopMenus> {


  list() {
    return  FutureBuilder<List>(
      future: widget.categories,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {

          return Text("Espere");
        }
        if (snapshot.hasData) {
          return dataTable(List<Category>.from(snapshot.data!)   );
        }


        return Text("Espere");
      },
    );
  }
  SingleChildScrollView dataTable(List<Category> categories) {
    return SingleChildScrollView(
      child: Container(
          height: 150,
          child:  ListView.builder(shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return  TopMenuTiles(id: categories[index].id ,name: categories[index].name, imageUrl: categories[index].UrlImagen, slug: "", testValue: widget.testValue,);



              }),),




      controller: widget.scrollController,

    );
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      child:ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          list(),

        ],
      ),
    );
  }
}

class TopMenuTiles extends StatelessWidget {
  int ? id;
  String name;
  String imageUrl;
  String slug;
  var testValue;

  TopMenuTiles(
      {
        required this.id,
       required this.name,
       required this.imageUrl,
       required this.slug,

        required this.testValue})
        ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        testValue ?  Navigator.push(context, ScaleRoute(page: HomePageCategoryStores( id  ))):  Navigator.push(context, ScaleRoute(page: LoginWithRestfulApi() ));

      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            decoration: new BoxDecoration(boxShadow: [
              new BoxShadow(
                color: Color(0xFFfae3e2),
                blurRadius: 25.0,
                offset: Offset(0.0, 0.75),
              ),
            ]),
            child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(3.0),
                  ),
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  child: Center(
                      child: Image.network(imageUrl ,
                          width: 45,
                          height: 45)

                  ),
                )),
          ),
          Text(name , overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Color(0xFF6e6e71),
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

