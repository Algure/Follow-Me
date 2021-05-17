import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:follow_me/azure.dart';
import 'package:follow_me/data_objects/profile.dart';
import 'package:follow_me/my_button.dart';
import 'package:follow_me/utitlity_functions.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _tittle='';
  String _fname='';
  String _sname='';
  String _link='';
  int _tittleLength=30;
  String _age='10';
  int nameLength=20;
  double marginVal=16;
  int imageIndex=0;

  Color hintColor=Colors.grey;
  Color hintSelectedColor=Colors.blue;
  Color textFillColor=Colors.white;

  bool _ageInFocus=false;
  bool _descInFocus=false;
  bool _fnameInFocus=false;
  bool _snameInFocus=false;
  bool _linkInFocus=false;



  @override
  void initState() {
    _setProfile();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Profile', style: TextStyle(color: Colors.blue),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        elevation: 0,
        actions: [

        ],
      ),
      body: ProgressHUD(
        child:Builder(
          builder: (context)=>SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: ClipOval(
                        child: Image.asset(kAvatarList[imageIndex], height: MediaQuery.of(context).size.height*0.2,)
                    ),
                  ),
                  CarouselSlider(
                      items: _getAvatarChoices()
                      , options: CarouselOptions(height: 120,
                      enlargeCenterPage: true,
                      viewportFraction: 0.1
                  )),
                  Container(
                    height: 70,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            // margin: EdgeInsets.symmetric(horizontal:marginVal),
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                setState(() => _fnameInFocus=hasFocus);
                              },
                              child: TextFormField(
                                onChanged: (string){_fname=string;},
                                autofocus: false,
                                maxLength: nameLength,
                                onEditingComplete: (){
                                  // setState(() {
                                  //   _fnameFocus.unfocus();
                                  // });
                                },
                                inputFormatters:[
                                  LengthLimitingTextInputFormatter(nameLength)
                                ],
                                decoration: InputDecoration(
                                    filled: true,
//                            prefixIcon: Icon(CupertinoIcons.person, color: Colors.white,),
                                    labelText: 'First name',
                                    labelStyle: TextStyle(
                                        color:_fnameInFocus?hintSelectedColor:hintColor
                                    ),
                                    // hintText: 'Enter  name',
                                    // hintStyle: TextStyle(
                                    //     color:hintColor
                                    // ),
                                    counterStyle: kHintStyle,
                                    fillColor: textFillColor,
                                    focusedBorder: kLinedFocusedBorder,
                                    enabledBorder: kLinedBorder,
                                    disabledBorder: kLinedBorder
                                ),
                                textInputAction: TextInputAction.next,
                                style: TextStyle(color: Colors.black, ),
                                keyboardType: TextInputType.name,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 30,),
                        Expanded(
                          child: Container(
                            // margin: EdgeInsets.symmetric(horizontal:marginVal),
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                setState(() => _snameInFocus=hasFocus);
                              },
                              child: TextFormField(
                                onChanged: (string){_sname=string;},
                                maxLength: nameLength,
                                autofocus: false,
                                onEditingComplete: (){
                                  // setState(() {
                                  //   _snameFocus.unfocus();
                                  // });
                                },
                                inputFormatters:[
                                  LengthLimitingTextInputFormatter(nameLength)
                                ],
                                decoration: InputDecoration(
                                    filled: true,
//                              prefixIcon: Icon(CupertinoIcons.person, color: Colors.white,),
                                    labelText: 'Last name',
                                    labelStyle: TextStyle(
                                        color:_snameInFocus?hintSelectedColor:hintColor
                                    ),
                                    // hintStyle: TextStyle(
                                    //     color: Colors.grey
                                    // ),
                                    counterStyle: kHintStyle,
                                    helperStyle: TextStyle(color: Colors.blue),
                                    fillColor: textFillColor,
                                    focusedBorder: kLinedFocusedBorder,
                                    enabledBorder: kLinedBorder,
                                    disabledBorder: kLinedBorder
                                ),
                                textInputAction: TextInputAction.next,
                                style: TextStyle(color: Colors.black),
                                keyboardType: TextInputType.name,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Focus(
                    onFocusChange: (hasFocus) {
                      setState(() => _ageInFocus=hasFocus);
                    },
                    child: TextField(
                        controller: TextEditingController(
                            text: _age
                        ),
                        style: TextStyle(color: Colors.black),//kInputTextStyle,
                        textAlign: TextAlign.start,
                        autofocus: false,
                        onEditingComplete: (){
                          // setState(() {
                          //   _descFocus.unfocus();
                          // });
                        },
                        keyboardType: TextInputType.number,
                        maxLength: _tittleLength,
                        onChanged: (text){_age=text;},
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Please enter your age. (Private 🔒)',
                            labelStyle: TextStyle(
                                color:_ageInFocus?hintSelectedColor:hintColor
                            ),
                            focusedBorder: kLinedFocusedBorder,
                            enabledBorder: kLinedBorder,
                            disabledBorder: kLinedBorder
                        )
                    ),
                  ),
                  SizedBox(height: 20,),
                  Focus(
                    onFocusChange: (hasFocus) {
                      setState(() => _descInFocus=hasFocus);
                    },
                    child: TextFormField(
                        controller: TextEditingController(
                            text: _tittle
                        ),
                        style: TextStyle(color: Colors.black),//kInputTextStyle,
                        textAlign: TextAlign.start,
                        autofocus: false,
                        onEditingComplete: (){
                          // setState(() {
                          //   _descFocus.unfocus();
                          // });
                        },
                        // maxLength: _tittleLength,
                        maxLines: 7,
                        onChanged: (text){_tittle=text;},
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Why follow you?',
                            labelStyle: TextStyle(
                                color:_descInFocus?hintSelectedColor:hintColor
                            ),
                            focusedBorder: kLinedFocusedBorder,
                            enabledBorder: kLinedBorder,
                            disabledBorder: kLinedBorder
                        )
                    ),
                  ),
                  SizedBox(height: 20,),
                  Focus(
                    onFocusChange: (hasFocus) {
                      setState(() => _linkInFocus=hasFocus);
                    },
                    child: TextFormField(
                        controller: TextEditingController(
                            text: _link
                        ),
                        style: TextStyle(color: Colors.black),//kInputTextStyle,
                        textAlign: TextAlign.start,
                        autofocus: false,
                        onEditingComplete: (){
                          // setState(() {
                          //   _descFocus.unfocus();
                          // });
                        },
                        onChanged: (text){_link=text;},
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: textFillColor,
                            labelText: 'Twitter link.',
                            labelStyle: TextStyle(
                                color:_linkInFocus?hintSelectedColor:hintColor
                            ),
                            focusedBorder: kLinedFocusedBorder,
                            enabledBorder: kLinedBorder,
                            disabledBorder: kLinedBorder
                        )
                    ),
                  ),
                  SizedBox(height: 20,),
                  MyButton(buttonColor: Colors.blue, onPressed:() async {
                  ProgressHUD.of(context)!.show();
                    try{
                      _fname = _fname.trim();
                      if (_fname == null || _fname.isEmpty) {
                        ProgressHUD.of(context)!.dismiss();
                        uShowErrorNotification ('First name cannot be empty');
                        return;
                      } else if (_fname.contains(' ')) {
                        ProgressHUD.of(context)!.dismiss();
                        uShowErrorNotification(
                            'First name cannot contain white/empty space');
                        return;
                      }else if(_fname.length>nameLength){
                        ProgressHUD.of(context)!.dismiss();
                        uShowErrorNotification( 'First name length is too long');
                        return;
                      }

                      _sname = _sname.trim();
                      if (_sname == null || _sname.isEmpty) {
                        ProgressHUD.of(context)!.dismiss();
                        uShowErrorNotification( 'Last/Sur name cannot be empty');
                        return;
                      } else if (_sname.contains(' ')) {
                        ProgressHUD.of(context)!.dismiss();
                        uShowErrorNotification(
                            'Last/Sur name cannot contain white/empty space');
                        return;
                      }else if(_sname.length>nameLength){
                        ProgressHUD.of(context)!.dismiss();
                        uShowErrorNotification('Last name length is too long');
                        return;
                      }

                      _link = _link.trim();
                      if (_link == null || _link.isEmpty) {
                        ProgressHUD.of(context)!.dismiss();
                        uShowErrorNotification('Twitter link cannot be empty');
                        return;
                      } else if (!(await canLaunch(_link))) {
                        ProgressHUD.of(context)!.dismiss();
                        showProgress(false);
                    uShowErrorNotification( 'Invalid twitter link');
                    return;
                    }

                    if (!(await uCheckInternet())) {
                      ProgressHUD.of(context)!.dismiss();
                      uShowErrorNotification('No internet connection detected !');
                      return;
                    }
                    await _updateProfile();
                    uShowOkNotification('Profile updated');
                    }catch(e){
                    uShowErrorNotification( 'An error occured. Please check inputs.');
                    print('error: ${e}');
                    }
                    ProgressHUD.of(context)!.dismiss();
                    },
                    textColor: Colors.white, text: 'Update', ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _setProfile() async {
    showProgress(true);
    Profile? prf= await AzureSingle().fetchProfile(_link);
    List<String> nameData= ((await uGetSharedPrefValue(kNameKey))??'').split(' ');
    if(nameData.length==2) {
      _fname = nameData[0];
      _sname = nameData[1];
    }
    _link= (await uGetSharedPrefValue(kLinkKey))??'';
    _tittle= (await uGetSharedPrefValue(kBioKey))??'';
    _age= (await uGetSharedPrefValue(kAgeKey))??'';
    if(prf!=null){
      List<String> nameData= (( prf.name)??'').split(' ');
      if(nameData.length==2) {
        _fname = nameData[0];
        _sname = nameData[1];
        await uSetPrefsValue(kNameKey,'$_fname $_sname');
      }
      // _link= prf.id!;
      _tittle= prf.bio!;
      _age= prf.age!=null?'${prf.age}':'0';
      await uSetPrefsValue(kBioKey,_tittle);
      await uSetPrefsValue(kAgeKey,'$_age');
      await uSetPrefsValue(kLinkKey,_link);
    }
    showProgress(false);
  }

  List<Widget> _getAvatarChoices() {
    List<Widget> result= [];
    int dex=0;
    for(String ava in kAvatarList){
      result.add(
     MaterialButton(
        onPressed: () {
          setState(() {
            imageIndex= kAvatarList.indexOf(ava);
          });
        },
        child: Container(
            height: MediaQuery.of(context).size.height*0.1,
            // width: MediaQuery.of(context).size.width*0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // border: Border.all(color: Colors.blue, width:0)// (imageIndex==dex)?1:0 )
            ),
            child: Image.asset(ava, fit: BoxFit.cover,)),
      ));
      dex++;
    }
    return result;
  }

  Future<void> _uploadProfile() async {
    try{
    _fname = _fname.trim();
    if (_fname == null || _fname.isEmpty) {
      showProgress(false);
      uShowErrorNotification ('First name cannot be empty');
      return;
    } else if (_fname.contains(' ')) {
      showProgress(false);
      uShowErrorNotification(
           'First name cannot contain white/empty space');
      return;
    }else if(_fname.length>nameLength){
      showProgress(false);
      uShowErrorNotification( 'First name length is too long');
      return;
    }

    _sname = _sname.trim();
    if (_sname == null || _sname.isEmpty) {
      showProgress(false);
      uShowErrorNotification( 'Last/Sur name cannot be empty');
      return;
    } else if (_sname.contains(' ')) {
      showProgress(false);
      uShowErrorNotification(
           'Last/Sur name cannot contain white/empty space');
      return;
    }else if(_sname.length>nameLength){
      showProgress(false);
      uShowErrorNotification('Last name length is too long');
      return;
    }

    _link = _link.trim();
    if (_link == null || _link.isEmpty) {
      showProgress(false);
      uShowErrorNotification('Twitter link cannot be empty');
      return;
    } else if (!(await canLaunch(_link))) {
      showProgress(false);
      uShowErrorNotification( 'Invalid twitter link');
      return;
    }

    if (!(await uCheckInternet())) {
      showProgress(false);
      uShowErrorNotification('No internet connection detected !');
      return;
    }
    await _updateProfile();
    uShowOkNotification('Profile updated');
  }catch(e,t ){
    uShowErrorNotification( 'An error occured. Please check inputs.');
    print('error: $e, $t');
  }
  showProgress(false);
  }

  Future<void> _updateProfile() async {
    Profile mProfile = Profile()
        ..age= (_age.isNotEmpty)?int.tryParse(_age)??0:0
        ..name='$_fname $_sname'
        ..id=_link
        ..bio=_tittle
        ..pic='$imageIndex';
    await AzureSingle().uploadProfile(mProfile);
    await uSetPrefsValue(kNameKey,'$_fname $_sname');
    await uSetPrefsValue(kBioKey,_tittle);
    await uSetPrefsValue(kAgeKey,'$_age');
    await uSetPrefsValue(kLinkKey,_link);
  }

  String generateRandomId() {
    var uuid = Uuid();
    return uuid.v1().replaceAll('-', '');
  }

  void showProgress(bool bool) {
    // if(bool)_progress.;
    // else _progress.dis();
  }
}

enum SearchChoice{
  none, search, filter
}