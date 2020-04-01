import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'dart:convert';
import 'dart:async';
//import '../http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier{
  String _authToken;
  String get authToken {
    if(_authToken != null){
      return _authToken;
    }
    return null;
  }

  bool get isAuth{
    return _authToken != null;
  }

  Future<String> signin(String email, String password) async
  {
    const url = "https://incomputable-attemp.000webhostapp.com/login-mobile.php";
    var data = {"email": email, "password": password};
    var response = await http.post(Uri.encodeFull(url),headers:{"Accept": "application/json"},body: data );
    return response.body.toString();
    // var res = json.decode(response.body);
    // print(res['error']);
    // if(res['error'] !=null){
    //   throw HttpException(res['error']);
    // }
    // // print(res);
    // _authToken = res['authToken'];
    // notifyListeners();
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString('AUTHTOKEN', _authToken);
    // final check = prefs.getString('AUTHTOKEN');
    // print(check);
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString('AUTHTOKEN', _authToken);
    
  }

  Future<bool> tryToAutoLogIn() async
  {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('AUTHTOKEN')){
      _authToken = prefs.getString('AUTHTOKEN');
      notifyListeners();
      return true;
    }
    else{
      return false;
    }
  }
}