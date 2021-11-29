import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipiko_app_usr/views/homepage.dart';
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

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      var authenticationToken_load = sharedPreferences.get(key).toString();
      var emailload  = sharedPreferences.get(email).toString();
      var client_load  = sharedPreferences.get(client).toString();
      var uuid_load  = sharedPreferences.get(uuid).toString();

      currentUser = JsonUser(email: emailload , access_token : authenticationToken_load, client: client_load, uuid: uuid_load);
      // will be null if never previously saved
      if (authenticationToken_load  == "null") {
        _testValue = false;
      }else {_testValue = true;}
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Flutter Google SignIn',

      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', hintColor: Color(0xFFd0cece)),
      home: _testValue?
      HomePage(  ):
      LoginWithRestfulApi(),
    );
  }
}