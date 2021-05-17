import 'dart:ui';

import 'package:flutter/material.dart';

const kNameKey='kNameKey';
const kBioKey='kBioKey';
const kAgeKey='kAgeKey';
const kLinkKey='kLinkKey';

const kHintStyle= TextStyle(
    color: Colors.grey
);

const kLinedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(
      Radius.circular(5)
  ),
  borderSide: BorderSide(color:Colors.grey, width: 1.5),

);

const kLinedFocusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(
      Radius.circular(5)
  ),
  borderSide: BorderSide(color:Colors.blue, width: 1),

);
const kNavTextStyle=TextStyle(
    color: Colors.white,
    fontSize: 14
);

const kBaseUrl= 'https://follow-me.search.windows.net/indexes/folloe-me';
const kAvatarList=[
  'images/maasai.png',
  'images/boy.png',
  'images/gamer.png',
  'images/boy1.png',
  'images/man1.png',
  'images/boy2.png',
  'images/boy3.png',
  'images/female.png',
  'images/man3.png',
  'images/woman.png',
  'images/man2.png',
  'images/woman2.png',
  'images/woman3.png',
  'images/woman1.png',
  'images/youngman.png',
  'images/user.png',
  'images/teenager.png',
  'images/spanish.png',
  'images/soccerplayer.png',
  'images/programmer.png',
  'images/profile.png',
  'images/man4.png',
  'images/man.png',
];