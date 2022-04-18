import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipiko_app_usr/views/homepage.dart';
import 'package:tipiko_app_usr/views/homepage_2.dart';
import 'cart_bloc.dart';
import 'data/json_user.dart';
import 'views/json_restful_api.dart';
import 'views/logged_screen.dart';

void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  MyApp({Key key = const Key("any_key")}) : super(key: key);

  @override
  createState() => new MyAppState();
}

const EdgeInsets pad20 = const EdgeInsets.all(20.0);
const String spKey = 'myBool';
const String key = 'access_token';
const String email = 'email';

const String  uuid = 'uuid';
const String  client = 'client';
JsonUser currentUser = new JsonUser(email: '', access_token: '', client: '', uuid: '');
//prefs.setString(key, user.authenticationToken);
//prefs.setString(email, user.email);
class MyAppState extends State<MyApp> {
  late SharedPreferences sharedPreferences;

  late bool _testValue=false;
  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {



    return MultiProvider(
        providers: [

    ChangeNotifierProvider.value(
    value: Cart(),
    ),
    ],
        child: MaterialApp(

          title: 'Flutter Google SignIn',

          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Roboto', hintColor: Color(0xFFd0cece)),
          home:
          HomePage(  )
        ));
  }
}