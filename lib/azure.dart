
import 'dart:convert';

import 'package:azstore/azstore.dart';
import 'package:follow_me/constants.dart';
import 'package:follow_me/data_objects/profile.dart';
import 'package:follow_me/keys.dart';
import 'package:follow_me/screens/profile_screen.dart';
import 'package:follow_me/utitlity_functions.dart';
import 'package:http/http.dart';

class AzureSingle {
  AzureSingle._privateConstructor();

  static final AzureSingle _instance = AzureSingle._privateConstructor();

  factory AzureSingle() {
    return _instance;
  }

  uploadProfile(Profile profile) async {
    // String sendUrl = '$baseEndPoint/indexes/folloe-me/docs/index?api-version=2020-06-30';
    // Request req = Request('POST', Uri.parse(sendUrl));
    // req.headers['Content-Type'] = 'application/json';
    // req.headers['api-key'] = searchKey;
    // req.body = '{"value":[{"@search.action": "mergeOrUpload","id":"${profile.id}","name":"${profile.name}","link":"${profile.link}","age":${profile.age},"bio":"${profile.bio}","pic":"${profile.pic}"}]}';
    // print(' started search upload ${req.body}');
    // await req.send().then((value) async {
    //   String message= await value.stream.bytesToString();
    //   print('order upload result: ${value.statusCode},  ${message}');
    //   if (value.statusCode >= 400) throw Exception(' ${message}');
    // });
    //

    String password= await uGetSharedPrefValue(kPassKey);
    String sendUrl = '$cloudBaseUrl/api/UpdateProfile?link=${profile.link}&pass=${password}&bio=${profile.bio}&id=${profile.id}&age=${profile.age}&name=${profile.name}&pic=${profile.pic}';
    Request req = Request('POST', Uri.parse(sendUrl));
    req.headers['Content-Type'] = 'application/json';
    print(' started search upload ${req.url}');
    await req.send().then((value) async {
      String message= await value.stream.bytesToString();
      print('order upload result: ${value.statusCode},  ${message}');
      if (value.statusCode >= 400) throw Exception(' ${message}');
    });
  }

  Future<String> loginOnCloud(String link, String password) async {
    String message='';
    String sendUrl = 'https://followmeres2apps.azurewebsites.net/api/Login?link=$link&pass=$password';
    Request req = Request('POST', Uri.parse(sendUrl));
    await req.send().then((value) async {
      message= await value.stream.bytesToString();
      print('login result:  ${value.statusCode},  ${message},  ${value.toString()},  ${value.reasonPhrase.toString()}');
      if (value.statusCode >= 400) throw AuthException(' ${message}');
    });
    var data= jsonDecode(message);
    return data['id'].toString();
  }

  Future<String> signUpOnCloud(String link,String password) async {
    String sendUrl = 'https://followmeres2apps.azurewebsites.net/api/SignUp?link=$link&pass=$password';
    Request req = Request('GET', Uri.parse(sendUrl));
    req.headers['Content-Type'] = 'application/json';
    print(' started search upload ${req.url}');
    String message= '';
    await req.send().then((value) async {
      message= await value.stream.bytesToString();
      print('sign up result:  ${value.statusCode},  ${message},  ${value.toString()},  ${value.reasonPhrase.toString()}');
      if (value.statusCode >= 400) throw AuthException(' ${message}');
    });
    var data= jsonDecode(message);
    return data['id'].toString();
  }

  Future<Profile?> fetchProfile(String id) async {
    Response response = await get(Uri.parse('$baseEndPoint/indexes/folloe-me/docs?api-version=2020-06-30&\$filter=link%20eq%20\'$id\''),
        headers:
        {'Content-Type': 'application/json',
          'api-key': searchKey});
    print('market status response: ${response.body}');
    if (response != null && response.body != null) {
      var res = jsonDecode(response.body);
      if (res['value'].length > 0) {
        return Profile.fromMap(
            res['value'][0]); // res['value'][0]['b'].toString();
      }
    }
    return null;
  }

   Future<List<Profile>> getAllProfiles() async {
    List<Profile> prolist=[];
    Response response = await get(
        Uri.parse('$baseEndPoint/indexes/folloe-me/docs?api-version=2020-06-30-Preview&search=*'),
        headers:
        {'Content-Type': 'application/json',
          'api-key': searchKey,
        'Access-Control-Allow-Origin':'*'
        });
    print('market status response: ${response.body}');
    if (response != null && response.body != null) {
      var res = jsonDecode(response.body);
      for(var data in res['value']){
        Profile pro= Profile.fromMap(data);
        if(pro!=null)prolist.add(pro);
      }
    }
    return prolist;
   }

  Future<List<Profile>> searchProfiles(String value) async {
    List<Profile> prolist=[];
    Response response = await get(
        Uri.parse('$baseEndPoint/indexes/folloe-me/docs?api-version=2020-06-30-Preview&search=$value&searchFields=name,bio'),
    headers:
    {'Content-Type': 'application/json',
    'api-key': searchKey,
    'Access-Control-Allow-Origin':'*'
    });
    //     Response response = await get(
    //     Uri.parse('$baseEndPoint/indexes/folloe-me/docs?api-version=2020-06-30-Preview&search=$value&queryType=semantic&queryLanguage=en-us&searchFields=name,bio'),
    //     headers:
    //     {'Content-Type': 'application/json',
    //       'api-key': searchKey,
    //       'Access-Control-Allow-Origin':'*'
    //     });
    print('search status response: ${response.body}');
    if (response != null && response.body != null) {
      var res = jsonDecode(response.body);
      for(var data in res['value']){
        Profile pro= Profile.fromMap(data);
        if(pro!=null)prolist.add(pro);
      }
    }
    return prolist;
  }

  filterProfiles(String value) async {
    List<String> range= value.split('-');
    if(range.length!=2)return;
    List<Profile> prolist=[];
    Response response = await get(Uri.parse('$baseEndPoint/indexes/folloe-me/docs?api-version=2020-06-30&\$filter=age%20ge%20${range[0]}%20and%20age%20le%20${range[1]}'),
        headers:
        {'Content-Type': 'application/json',
          'api-key': searchKey});
    print('search status response: ${response.body}');
    if (response != null && response.body != null) {
      var res = jsonDecode(response.body);
      for(var data in res['value']){
        Profile pro= Profile.fromMap(data);
        if(pro!=null)prolist.add(pro);
      }
    }
    return prolist;
  }

}

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}
