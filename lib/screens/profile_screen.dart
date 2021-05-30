import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../utilities/azure.dart';
import 'package:follow_me/data_objects/profile.dart';
import '../custom_widgets/my_button.dart';
import '../utilities/utitlity_functions.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../utilities/constants.dart';

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
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: ClipOval(
                        child: Image.asset(kAvatarList[imageIndex], height: MediaQuery.of(context).size.height*0.2,)
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: 800
                    ),
                    child: CarouselSlider(

                        items: _getAvatarChoices()
                        , options: CarouselOptions(height: 120,
                        enlargeCenterPage: true,
                        viewportFraction: 0.3,//MediaQuery.of(context).size.width>500? 0.1:0.4
                    )),
                  ),
                  Card(
                    elevation: 10,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 800
                      ),
                      color: Colors.white,
                      padding: EdgeInsets.all(18),
                      margin: EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                                        controller: TextEditingController(
                                            text: _fname
                                        ),
                                        onEditingComplete: (){
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
                                        controller: TextEditingController(
                                            text: _sname
                                        ),
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
                            child: TextField(
                                controller: TextEditingController(
                                    text: _link
                                ),
                                style: TextStyle(color: Colors.black),//kInputTextStyle,
                                textAlign: TextAlign.start,
                                autofocus: false,
                                enabled: false,
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
                          MyButton(buttonColor: Colors.blue,
                            onPressed:() async {
                              _uploadProfile();
                            },
                            textColor: Colors.white, text: 'Update', ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _setProfile() async {
    _showProgress(true);
    Profile? prf;


    try {
      List<String> nameData= ((await uGetSharedPrefValue(kNameKey))??'').split(' ');
      if(nameData.length==2) {
        _fname = nameData[0];
        _sname = nameData[1];
      }
      _link= (await uGetSharedPrefValue(kLinkKey))??'';
      _tittle= (await uGetSharedPrefValue(kBioKey))??'';
      _age= (await uGetSharedPrefValue(kAgeKey))??'';
      String picData=(await uGetSharedPrefValue(kPickey))??'';
      imageIndex= int.tryParse(picData)??0;

      prf = await AzureSingle().fetchProfile(_link);

    if(prf!=null){
      print('profile: $prf');
      List<String> nameData= (( prf.name)??'').split(' ');
      if(nameData.length==2) {
        _fname = nameData[0];
        _sname = nameData[1];
        await uSetPrefsValue(kNameKey,'$_fname $_sname');
      }
      imageIndex= int.tryParse(prf.pic.toString())??0;
      print('pic: ${prf.pic}');
      // _link= prf.id!;
      _tittle= prf.bio!.toString().replaceAll('null', '');
      _age= (prf.age!=null?'${prf.age}':'0').replaceAll('null', '');;

      await uSetPrefsValue(kBioKey,_tittle);
      await uSetPrefsValue(kAgeKey,'$_age');
      await uSetPrefsValue(kLinkKey,_link);
    }

    }catch(e,t){
      print('error: $e,  trace: $t');
    }
    _tittle= _tittle.replaceAll('null', '');
    _age= _age.replaceAll('null', '');
    print('age: $_age, _tittle: $_tittle, _link: $_link, _fname:$_fname, _sname: $_sname , image: $imageIndex}');
    _showProgress(false);
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
    _showProgress(true);
    try{
    _fname = _fname.trim();
    if (_fname == null || _fname.isEmpty) {
      _showProgress(false);
      uShowErrorNotification ('First name cannot be empty');
      return;
    } else if (_fname.contains(' ')) {
      _showProgress(false);
      uShowErrorNotification(
           'First name cannot contain white/empty space');
      return;
    }else if(_fname.length>nameLength){
      _showProgress(false);
      uShowErrorNotification( 'First name length is too long');
      return;
    }

    _sname = _sname.trim();
    if (_sname == null || _sname.isEmpty) {
      _showProgress(false);
      uShowErrorNotification( 'Last/Sur name cannot be empty');
      return;
    } else if (_sname.contains(' ')) {
      _showProgress(false);
      uShowErrorNotification(
           'Last/Sur name cannot contain white/empty space');
      return;
    }else if(_sname.length>nameLength){
      _showProgress(false);
      uShowErrorNotification('Last name length is too long');
      return;
    }

    _link = _link.trim();
    if (_link == null || _link.isEmpty) {
      _showProgress(false);
      uShowErrorNotification('Twitter link cannot be empty');
      return;
    } else if (!(await canLaunch(_link))) {
      _showProgress(false);
      uShowErrorNotification( 'Invalid twitter link');
      return;
    }

    if (!(await uCheckInternet())) {
      _showProgress(false);
      uShowErrorNotification('No internet connection detected !');
      return;
    }
    await _updateProfile();
    uShowOkNotification('Profile updated');
  }catch(e,t ){
    uShowErrorNotification( 'An error occured. Please check inputs.');
    print('error: $e, $t');
  }
  _showProgress(false);
  }

  Future<void> _updateProfile() async {
    Profile mProfile = Profile()
        ..id= await _getId()
        ..age= (_age.isNotEmpty)?int.tryParse(_age)??0:0
        ..name='$_fname $_sname'
        ..link=_link
        ..bio=_tittle
        ..pic='$imageIndex';
    await AzureSingle().uploadProfile(mProfile);
    await uSetPrefsValue(kNameKey,'$_fname $_sname');
    await uSetPrefsValue(kBioKey,_tittle);
    await uSetPrefsValue(kIdkey,mProfile.id);
    await uSetPrefsValue(kAgeKey,'$_age');
    await uSetPrefsValue(kLinkKey,_link);
  }

  String _generateRandomId() {
    var uuid = Uuid();
    return 'a'+uuid.v1().replaceAll('-', '');
  }

  void _showProgress(bool bool) {
    if(bool)EasyLoading.show(status: 'loading...');
    else EasyLoading.dismiss();
    setState(() {

    });
  }

  Future<String?> _getId() async{
    String id= (await uGetSharedPrefValue(kIdkey))??'';
    if(id.length<5)return _generateRandomId();
    return id;
  }
}

enum SearchChoice{
  none, search, filter
}
