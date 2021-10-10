import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tipiko_app_usr/data/json_user.dart';

import 'package:shared_preferences/shared_preferences.dart';

const EdgeInsets pad20 = const EdgeInsets.all(20.0);
const String spKey = 'myBool';
const String key = 'user_authenticationToken';
const String email = 'user_email';

class LoggedScreen extends StatelessWidget {
  LoggedScreen({required this.user});

  final JsonUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Push"),leading: new Container(),
      ),
      body: Column(
          children: <Widget> [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text('Read'),
                onPressed:  () async {
                  _read();
                },
              ),
            ),

            user != null
                ? Text("Session iniciada \n \n Email: ${user.email} ")
                : Text("Necesitas iniciar sesiòn!"),
          ]
      ),

    );
  }




  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'access_token';
    final email = 'email';

    Fluttertoast.showToast(
        msg:  prefs.get(email).toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    Fluttertoast.showToast(
        msg:  prefs.get(key).toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}