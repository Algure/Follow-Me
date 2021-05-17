import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:follow_me/constants.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> uCheckInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

void uShowErrorNotification(String text){
  showSimpleNotification(
      Text(text, style: kNavTextStyle,),
      leading:Icon(Icons.warning, color:Colors.white),
      background: Colors.red);
}

void uShowOkNotification(String text){
  showSimpleNotification(
      Text(text, style: kNavTextStyle,),
      // leading:Icon(Icons.ok, color:Colors.white),
      background: Colors.green);
}

Future<void> uSetPrefsValue(String key, var value) async {
  SharedPreferences sp=await SharedPreferences.getInstance();
  if(sp.containsKey(key)){
    await sp.remove(key);
  }
  await sp.reload();
  await sp.setString(key, value.toString());
  await sp.commit();
}

Future<dynamic> uGetSharedPrefValue(String key) async {
  SharedPreferences sp=await SharedPreferences.getInstance();
  await sp.reload();
  return sp.get(key).toString();
}