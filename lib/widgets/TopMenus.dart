import 'package:flutter/material.dart';
import 'package:tipiko_app_usr/data/category.dart';

class TopMenus extends StatefulWidget {

  Future<List<Category>>? categories;

  late final ScrollController scrollController ;

  TopMenus( this.categories, this.scrollController );



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
          height: double.maxFinite,
          child:  ListView.builder(shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                print('$index');
                return  TopMenuTiles(name: categories[index].name, imageUrl: categories[index].UrlImagen, slug: "");



              }),),




      controller: widget.scrollController,

    );
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
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
  String name;
  String imageUrl;
  String slug;

  TopMenuTiles(
      {
       required this.name,
       required this.imageUrl,
       required this.slug})
        ;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
