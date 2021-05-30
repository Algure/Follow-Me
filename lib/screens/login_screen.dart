import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../utilities/azure.dart';
import '../utilities/constants.dart';
import 'package:follow_me/data_objects/profile.dart';
import '../utilities/keys.dart';
import '../custom_widgets/my_button.dart';
import 'package:follow_me/screens/home_screen.dart';
import '../utilities/utitlity_functions.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _linkInFocus=false;
  bool showPassword=false;
  bool selected=false;
  bool _passInFocus= false;
  String _link='';
  String? _iconString;
  String  _password='';
  Widget _socialIcon=SizedBox.shrink();

  Color hintColor=Colors.grey;
  Color hintSelectedColor=Colors.blue;

  TextEditingController? _linkController;
  TextEditingController? _passController;

  @override
  void initState() {
      _linkController= TextEditingController(text: _link);
      _passController= TextEditingController(text: _password);
      EasyLoading.instance.userInteractions=false;
  }

  @override
  void didChangeDependencies() {
    _waitAndSetTrueAnim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Card(
                  elevation: 8,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 500
                    ),
                    padding: EdgeInsets.all(20),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'fologo',
                          child: AnimatedContainer(
                            width: selected ? 200.0 : 0.0,
                            height: selected ? 200.0 : 0.0,
                            // color: Colors.red : Colors.blue,
                            alignment:Alignment.center,
                            duration: Duration(milliseconds: 2000) ,
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: Image.asset('images/logo.png', color: Colors.blue, height: 75, width: 300,),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 50,
                          child: Focus(
                            onFocusChange: (hasFocus) {
                              setState(() => _linkInFocus=hasFocus);
                            },
                            child: TextFormField(
                                controller:_linkController,
                                style: TextStyle(color: Colors.black),//kInputTextStyle,
                                textAlign: TextAlign.start,
                                autofocus: false,
                                onEditingComplete: (){
                                  // setState(() {
                                  //   _descFocus.unfocus();
                                  // });
                                },
                                onChanged: (text){
                                  _link=text;
                                  _setSocialIcon();
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: 'Please enter your social link (Twitter link)',
                                    labelStyle: TextStyle(
                                        color:_linkInFocus?hintSelectedColor:hintColor
                                    ),
                                    suffixIcon: Padding(padding: EdgeInsets.all(5),child: _socialIcon),
                                    focusedBorder: kLinedFocusedBorder,
                                    enabledBorder: kLinedBorder,
                                    disabledBorder: kLinedBorder
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 50,
                          child: Focus(
                            onFocusChange: (hasFocus) {
                              setState(() => _passInFocus=hasFocus);
                            },
                            child: TextFormField(
                                controller: _passController,
                                style: TextStyle(color: Colors.black),//kInputTextStyle,
                                textAlign: TextAlign.start,
                                autofocus: false,
                                onEditingComplete: (){
                                  // setState(() {
                                  //   _descFocus.unfocus();
                                  // });
                                },
                                onChanged: (text){
                                  _password=text;
                                  // _setSocialIcon();
                                },
                                obscureText: showPassword?false:true,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: 'Please enter your password',
                                    labelStyle: TextStyle(
                                        color:_passInFocus?hintSelectedColor:hintColor
                                    ),
                                    // suffixIcon: Padding(padding: EdgeInsets.all(5),child: Icon(Icons.lock)),
                                    suffixIcon: IconButton(icon: Icon(showPassword?Icons.visibility_off:Icons.visibility, color: Colors.grey,), onPressed: _toggleIconVisibility,),
                                    focusedBorder: kLinedFocusedBorder,
                                    enabledBorder: kLinedBorder,
                                    disabledBorder: kLinedBorder
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        SizedBox(
                          height: 50,
                          child: Row(
                              children:[
                                Expanded(
                                  child: MyButton(buttonColor: Colors.blue,
                                    onPressed:() async {
                                      _login();
                                    },
                                    textColor: Colors.white, text: 'Login', ),
                                ),
                                SizedBox(width: 15,),
                                Expanded(
                                  child: MyButton(buttonColor: Colors.black,
                                    textColor: Colors.white,
                                    onPressed:() async {
                                      _signup();
                                    }, text: 'Sign Up', ),
                                ),
                              ]
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.1,
                        ),
                        Container(
                            height: 30,
                            child: Text('Powered by Azure', style:  TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.w900, fontSize: 12),)),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  _toggleIconVisibility(){
    setState(() {
      showPassword=!showPassword;
    });
  }

  void _setSocialIcon() {
    String? iconString= _getImageIcon(_link);
    if(iconString==null){
      if(_socialIcon!=SizedBox.shrink()) {
        setState(() {
          _socialIcon = SizedBox.shrink();
        });
      }
        return;
    }
    if(_iconString!=iconString){
      setState(() {
        _iconString=iconString;
        _socialIcon=Image.asset(_iconString??'', height: 20, width: 20,);
      });
    }
  }

  void _showProgress(bool bool) {
    if(bool)EasyLoading.show(status: 'loading...');
    else EasyLoading.dismiss();
    setState(() {

    });
  }

  _signup() async{
    _showProgress(true);
    try {
      _link = _link.trim();
      while(_link.endsWith('/')){
        _link=_link.substring(0, _link.length-1);
      }
      if (_link == null || _link.isEmpty) {
        _showProgress(false);
        uShowErrorNotification('Social link cannot be empty');
        return;
      } else if (!(await canLaunch(_link))) {
        _showProgress(false);
        uShowErrorNotification('Invalid social link');
        return;
      } else if (_iconString == null || _iconString!.isEmpty) {
        _showProgress(false);
        uShowErrorNotification(
            'Social link not recognised. Please try another !');
        return;
      }
      _password = _password.trim();
      if (_password == null || _password.isEmpty) {
        _showProgress(false);
        uShowErrorNotification('Password cannot be empty');
        return;
      } else if (_password.length < 3) {
        _showProgress(false);
        uShowErrorNotification('Password is too short');
        return;
      }
      Profile? tprf = await AzureSingle().fetchProfile(_link);
      if(tprf!=null && tprf.id!=null && tprf.id!.length>5){
        _showProgress(false);
        uShowErrorNotification('This link is registered');
        return;
      }
      print("link: $_link, password: $_password}");
      String id = await AzureSingle().signUpOnCloud(_link, _password);
      Profile mProfile = Profile()
        ..id = id
        ..age = 0
        ..name = ''
        ..link = _link
        ..bio = ''
        ..pic = '';

      await AzureSingle().uploadProfile(mProfile);
      // await AzureSingle().savePassword(mProfile.id!, _password);
      await uSetPrefsValue(kIdkey, mProfile.id);
      await uSetPrefsValue(kLinkKey, _link);
      await uSetPrefsValue(kPassKey, _password);
      _showProgress(false);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home',)));
    }catch(e,t){
      print('error: $e, trace: $t');
      if(e.runtimeType==AuthException) uShowErrorNotification('${(e as AuthException).message}');
      else uShowErrorNotification('An error occured !');
    }
    _showProgress(false);
  }

  Future<String?> _getId() async{
    String id= (await uGetSharedPrefValue(kIdkey))??'';
    if(id.length<5)return _generateRandomId();
    return id;
  }

  String _generateRandomId() {
    var uuid = Uuid();
    return 'a'+uuid.v1().replaceAll('-', '');
  }

  _login() async {
    _showProgress(true);
    try {
      _link = _link.trim().toLowerCase();
      while(_link.endsWith('/')){
        _link=_link.substring(0, _link.length-1);
      }
      if (_link == null || _link.isEmpty) {
        _showProgress(false);
        uShowErrorNotification('Social link cannot be empty');
        return;
      } else if (!(await canLaunch(_link))) {
        _showProgress(false);
        uShowErrorNotification('Invalid social link');
        return;
      } else if (_iconString == null || _iconString!.isEmpty) {
        _showProgress(false);
        uShowErrorNotification(
            'Social link not recognised. Please try another !');
        return;
      }

      _password = _password.trim();
      if (_password == null || _password.isEmpty|| _password.isEmpty) {
        _showProgress(false);
        uShowErrorNotification('Password cannot be empty');
        return;
      } else if (_password.length < 3) {
        _showProgress(false);
        uShowErrorNotification('Password is too short');
        return;
      }

      Profile? prf;

      String tittle = '';
      String fname = '';
      String sname = '';
      String? age = '';
      String? id = '';
      String? pic = '';
      // try {
        prf = await AzureSingle().fetchProfile(_link);
      // } catch (e, t) {
      //   print('error: $e,  trace: $t');
      // }
      if (prf != null) {
        // List<String> nameData = ((prf.name) ?? '').split(' ');
        // if (nameData.length == 2) {
        //   fname = nameData[0];
        //   sname = nameData[1];
        //   await uSetPrefsValue(kNameKey, '$fname $sname');
        // }
        // id = prf.id!;
        // tittle = prf.bio!;
        // age = prf.age != null ? '${prf.age}' : '0';
        // pic = prf.pic;
        //
        // if(id==null || id.isEmpty || id=='null') throw 'Profile not found.';
        // print(
        //     'age: $age, _tittle: $tittle, _link: $_link, _fname:$fname, _sname: $sname, pic: $pic');
        // String savedPass = await AzureSingle().getPassword(id);
        // print('saved: $savedPass, password:$_password');
        // if (savedPass != _password) throw "Wrong password";
        //
        // await uSetPrefsValue(kBioKey, tittle);
        // await uSetPrefsValue(kAgeKey, '$age');
        // await uSetPrefsValue(kPickey, '${prf.pic}');
        id =await AzureSingle().loginOnCloud(_link, _password);
        await uSetPrefsValue(kIdkey, '$id');
        await uSetPrefsValue(kLinkKey, _link);
        await uSetPrefsValue(kPassKey, _password);
        _showProgress(false);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home',)));
      }else{
        throw 'Profile not found.';
      }
    }catch(e,t){
      print('Error: $e, trace: $t');
      if(e.runtimeType==AuthException && !(e as AuthException).message.contains('<')) uShowErrorNotification('${(e as AuthException).message}');
      else if(e.toString().contains('Wrong password'))uShowErrorNotification('Wrong password !');
      else if(e.toString().contains('Profile not found.'))uShowErrorNotification('Profile not found.');
      else uShowErrorNotification('An error occured');
    }
    _showProgress(false);

  }

  String? _getImageIcon(String link) {
    String temp=link.toString().toLowerCase();
    if(temp.contains('github')){
      return 'images/github.png';
    }else if(temp.contains('facebook')){
      return 'images/facebook.png';
    }else if(temp.contains('instagram')){
      return 'images/instagram.png';
    }else if(temp.contains('linkedin')){
      return 'images/linkedin.png';
    }else if(temp.contains('twitter')){
      return 'images/twitter.png';
    }
    return null;
  }

  void _waitAndSetTrueAnim() {
    Future.delayed(Duration(seconds: 1),(){
     setState(() {
       selected=true;
     });
    });
  }
}
