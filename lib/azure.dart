
import 'dart:convert';

import 'package:follow_me/data_objects/profile.dart';
import 'package:follow_me/keys.dart';
import 'package:follow_me/screens/profile_screen.dart';
import 'package:http/http.dart';

class AzureSingle {
  AzureSingle._privateConstructor();

  static final AzureSingle _instance = AzureSingle._privateConstructor();

  factory AzureSingle() {
    return _instance;
  }

  uploadProfile(Profile profile) async {
    // String sendUrl = 'https://follow-me.search.windows.net/indexes/folloe-me/docs?api-version=2020-06-30-Preview';
    String sendUrl = 'https://follow-me.search.windows.net/indexes/folloe-me/docs?api-version=2020-06-30-Preview&search=*&&api-key=$searchKey';
    Request req = Request('POST', Uri.parse(sendUrl));
    req.headers['Content-Type'] = 'application/json';
    // req.headers['Access-Control-Allow-Origin'] = '*';
    req.headers['api-key'] = searchKey;
    req.body =
    '{"value":[{"@search.action": "upload","id":"${profile
        .id}","name":"${profile.name}","age":${profile.age},"bio":"${profile
        .bio}","pic":"${profile.pic}"}]}';
    print(' started search upload');
    await req.send().then((value) {
      print('order upload result: ${value.statusCode},  ${value.reasonPhrase
          .toString()}');
      if (value.statusCode >= 400) throw Exception(
          ' ${value.reasonPhrase.toString()}');
    });
  }

  Future<Profile?> fetchProfile(String id) async {
    Response response = await get(Uri.parse(
        'https://follow-me.search.windows.net/indexes/folloe-me/docs?api-version=2020-06-30-Preview&\$filter=id%20eq%20\'$id\''),
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
    Response response = await get(Uri.parse(
        'https://follow-me.search.windows.net/indexes/folloe-me/docs?api-version=2020-06-30-Preview&search=*'
    ),
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
}
