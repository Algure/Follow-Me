// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follow_me/data_objects/profile.dart';
import '../lib/utilities/keys.dart';

import 'package:follow_me/main.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

Future<void> main() async {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());
  //
  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);
  //
  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();
  //
  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });

  Profile p= Profile()
  ..id=generateRandomId()
    ..name='testname'
  ..pic='1'
  ..link='http://khisdsa.net'
  ..bio='jlkc'
  ..age=20;
  await uploadProfile(p);
}

String generateRandomId() {
  var uuid = Uuid();
  return 'a'+uuid.v1().replaceAll('-', '');
}

uploadProfile(Profile profile) async {
  // String sendUrl = 'https://follow-me.search.windows.net/indexes/folloe-me/docs?api-version=2020-06-30-Preview&search=*';
  // Request req = Request('GET', Uri.parse(sendUrl));
  String sendUrl = 'https://follow-me.search.windows.net/indexes/folloe-me/docs/index?api-version=2020-06-30';
  Request req = Request('POST', Uri.parse(sendUrl));
  req.headers['Content-Type'] = 'application/json';
  req.headers['Access-Control-Allow-Origin'] = '*';
  req.headers['Access-Control-Allow-Methods'] = 'GET, PUT, POST, DELETE, HEAD, OPTIONS, PATCH, PROPFIND, PROPPATCH, MKCOL, COPY, MOVE, LOCK';
  req.headers[' Access-Control-Allow-Credentials'] = 'true';
  // Access-Control-Allow-Methods: 'GET, PUT, POST, DELETE, HEAD, OPTIONS, PATCH, PROPFIND, PROPPATCH, MKCOL, COPY, MOVE, LOCK'
  // Access-Control-Allow-Methods: request initiator or '*'
  // Access-Control-Allow-Credentials: 'true'
  req.headers['api-key'] = searchKey;
  req.body =
  '{"value":[{"@search.action": "mergeOrUpload","id":"${profile.id}","name":"${profile.name}","age":${profile.age},"bio":"${profile.bio}","pic":"${profile.pic}"}]}';
  print(' started search upload');
  await req.send().then((value) async {
    String message= await value.stream.bytesToString();
    print('order upload result: ${value.statusCode},  ${message}');
    if (value.statusCode >= 400) throw Exception(
        ' ${value.reasonPhrase.toString()}');
  }).onError ((e,t) async {
    print('internal error $e, trace $t');
    throw '$e';
  });
}


