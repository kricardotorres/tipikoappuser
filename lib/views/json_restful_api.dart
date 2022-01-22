import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tipiko_app_usr/data/json_user.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipiko_app_usr/views/homepage_2.dart';
import 'package:tipiko_app_usr/views/logged_screen.dart';

import 'homepage.dart';

const EdgeInsets pad20 = const EdgeInsets.all(20.0);
const String spKey = 'myBool';
const String key = 'user_authenticationToken';
const String email = 'user_email';


class LoginWithRestfulApi extends StatefulWidget {




  @override
  _LoginWithRestfulApiState createState() => _LoginWithRestfulApiState();
}

class _LoginWithRestfulApiState extends State<LoginWithRestfulApi> {
  static var uri = "http://ec2-3-16-169-49.us-east-2.compute.amazonaws.com/tipikodev/api";





  _save(JsonUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access_token';
    final email = 'email';
    final uuid = 'uuid';
    final client = 'client';
    print(user );
    print(user );
    prefs.setString(key, user.access_token);
    prefs.setString(email, user.email);
    prefs.setString(uuid, user.uuid);
    prefs.setString(client, user.client);

  }
  static BaseOptions options = BaseOptions(
      baseUrl: uri,
      responseType: ResponseType.plain,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      validateStatus: (code) {
        if (code! >= 200) {
          return true;
        }else{
          return false;
        }
      });
  static Dio dio = Dio(options);

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<dynamic> _loginUser(String email, String password) async {
    try {
      Options options = Options(
        contentType: "application/json"
      );

      Response response = await dio.post('/Principal/iniciarsesion?Rol=Cliente',
          data: {"usuario": email, "password": password}, options: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJs=json.decode(response.data) ;
        var responseJson ;
        print( json.decode(response.data) );
        print(responseJs['Cuerpo']['access_token'] );
        print(responseJs['Cuerpo']['usuario']['Usuario'] );
        responseJson =   {"access_token": responseJs['Cuerpo']['access_token'],
          "client": responseJs['Cuerpo']['usuario']['Usuario'],
          "uuid": responseJs['Cuerpo']['usuario']['id'].toString(),"Usuario" : responseJs['Cuerpo']['usuario']['Usuario']}; //access-token client uuid


        return  responseJson;
      } else if (response.statusCode == 401) {
        setState(() => _isLoading = false);
        throw Exception("Incorrect Email/Password");
      } else
        setState(() => _isLoading = false);
      throw Exception('Authentication Error');
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        setState(() => _isLoading = false);
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.receiveTimeout ||
          exception.type == DioErrorType.connectTimeout) {
        setState(() => _isLoading = false);
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }
  late SharedPreferences sharedPreferences;


  @override
  Widget build(BuildContext context) {
    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    {return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 30),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white70,
        child:
        _isLoading
            ? CircularProgressIndicator(
          backgroundColor: Colors.cyanAccent,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
        )
            :
        Column(
          children: <Widget>[

            Flexible(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 230,
                    height: 100,
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/menus/ic_food_express.png",
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: _emailController,
                    showCursor: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Email",
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    showCursor: true,
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                      suffixIcon: Icon(
                        Icons.remove_red_eye,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                        color: Color(0xFF666666),
                        fontFamily: defaultFontFamily,
                        fontSize: defaultFontSize,
                      ),
                      hintText: "Contraseña",
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Forgot your password?",
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontFamily: defaultFontFamily,
                        fontSize: defaultFontSize,
                        fontStyle: FontStyle.normal,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  Container(
            width: double.infinity,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Color(0xFFfbab66),
        ),
        BoxShadow(
          color: Color(0xFFf7418c),
        ),
      ],
      gradient: LinearGradient(
          colors: [Color(0xFFf7418c), Color(0xFFfbab66)],
          begin: const FractionalOffset(0.2, 0.2),
          end: const FractionalOffset(1.0, 1.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp),
    ),
    child: MaterialButton(
    highlightColor: Colors.transparent,
    splashColor: Color(0xFFf7418c),
    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
    child: Padding(
    padding:
    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
    child: Text(
    "Entrar",
    style: TextStyle(
    color: Colors.white,
    fontSize: 25.0,
    fontFamily: "WorkSansBold"),
    ),
    ),
    onPressed: () async {
    setState(() => _isLoading = true);
    var res = await _loginUser(
    _emailController.text, _passwordController.text);
    setState(() => _isLoading = false);

    JsonUser user = JsonUser.fromJson(res);
    if (user != null) {

    _save(user);
    Navigator.of(context).pushReplacement(MaterialPageRoute<Null>(
    builder: (BuildContext context) {
    return new HomePage(  );
    }));
    } else {
    Scaffold.of(context).showSnackBar(
    SnackBar(content: Text("Wrong email ")));
    }
    }),
    ),
                  SizedBox(
                    height: 2,
                  ),
                //FacebookGoogleLogin()
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => {
                       // Navigator.push(context, ScaleRoute(page: SignUpPage()))
                      },
                      child: Container(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(0xFFf7418c),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
      /*return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text("Iniciar sesion en Tipiko")),
        body: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: 'Email', border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Password",
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                ),
              ),

              ElevatedButton(
                child: Text("Entrar"),
                onPressed: () async {
                  setState(() => _isLoading = true);
                  var res = await _loginUser(
                      _emailController.text, _passwordController.text);
                  setState(() => _isLoading = false);

                  JsonUser user = JsonUser.fromJson(res);
                  if (user != null) {

                    _save(user);
                    Navigator.of(context).pushReplacement(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return new LoggedScreen(
                            user: user,
                          );
                        }));
                  } else {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Wrong email ")));
                  }
                },
              ),
            ],
          ),
        ),
      );*/
    }



  }



}
