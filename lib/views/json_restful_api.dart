import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tipiko_app_usr/data/json_user.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipiko_app_usr/views/logged_screen.dart';

const EdgeInsets pad20 = const EdgeInsets.all(20.0);
const String spKey = 'myBool';
const String key = 'user_authenticationToken';
const String email = 'user_email';

class LoginWithRestfulApi extends StatefulWidget {




  @override
  _LoginWithRestfulApiState createState() => _LoginWithRestfulApiState();
}

class _LoginWithRestfulApiState extends State<LoginWithRestfulApi> {
  static var uri = "https://ximenacosmeticos.herokuapp.com/api";





  _save(JsonUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access_token';
    final email = 'email';
    final uuid = 'uuid';
    final client = 'client';
    print(user.client);
    print(user.access_token);
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

      Response response = await dio.post('/auth/sign_in',
          data: {"email": email, "password": password}, options: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson;
        responseJson =   {"access-token": response.headers.value('access-token'),
          "client": response.headers.value('client'),
          "uuid": response.headers.value('uid') ,"email" : response.headers.value('uid')}; //access-token client uuid
        print(responseJson);

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

    {
      return Scaffold(
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

              RaisedButton(
                child: Text("Entrar"),
                color: Colors.lightBlueAccent,
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
      );
    }



  }



}
