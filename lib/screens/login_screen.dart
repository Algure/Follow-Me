import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:follow_me/azure.dart';
import 'package:follow_me/constants.dart';
import 'package:follow_me/data_objects/profile.dart';
import 'package:follow_me/my_button.dart';
import 'package:follow_me/screens/home_screen.dart';
import 'package:follow_me/utitlity_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _linkInFocus=false;
  String _link='';
  Color hintColor=Colors.grey;
  Color hintSelectedColor=Colors.blue;
  String? _iconString;
  Widget _socialIcon=SizedBox.shrink();

  var selected=false;


  @override
  void initState() {

  }


  @override
  void didChangeDependencies() {
    waitAndSetTrueAnim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'fologo',
                child: AnimatedContainer(
                  width: selected ? 200.0 : 0.0,
                  height: selected ? 100.0 : 0.0,
                  // color: Colors.red : Colors.blue,
                  alignment:Alignment.center,
                  duration: Duration(milliseconds: 2000) ,
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Image.asset('images/logo.png', color: Colors.blue, height: 75, width: 300,),
                ),
              ),
              SizedBox(height: 20,),

              Focus(
                onFocusChange: (hasFocus) {
                  setState(() => _linkInFocus=hasFocus);
                },
                child: TextFormField(
                    controller: TextEditingController(
                        text: _link,
                    ),
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
              SizedBox(height: 20,),
              MyButton(buttonColor: Colors.blue,
                onPressed:() async {
                  _login();
                },
                textColor: Colors.white, text: 'Proceed', ),
            ],
          ),
        ),
      ),
    );
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
      _iconString=iconString;
      _socialIcon=Image.asset(_iconString??'', height: 20, width: 20,);
      setState(() {

      });
    }
  }

  void showProgress(bool bool) {
    if(bool)EasyLoading.show(status: 'loading...');
    else EasyLoading.dismiss();
    setState(() {

    });
  }

  _login() async {
    showProgress(true);
    _link = _link.trim();
    if (_link == null || _link.isEmpty) {
      showProgress(false);
      uShowErrorNotification('Social link cannot be empty');
      return;
    } else if (!(await canLaunch(_link))) {
      showProgress(false);
      uShowErrorNotification( 'Invalid social link');
      return;
    }else if(_iconString==null || _iconString!.isEmpty){
      showProgress(false);
      uShowErrorNotification( 'Social link not recognised. Please try another !');
      return;
    }

    Profile? prf;

    String tittle='';
    String fname='';
    String sname='';
    String? age='';
    String? id='';
    String? pic='';
    try {
      prf = await AzureSingle().fetchProfile(_link);
    }catch(e,t){
      print('error: $e,  trace: $t');
    }
    if(prf!=null){
      List<String> nameData= (( prf.name)??'').split(' ');
      if(nameData.length==2) {
        fname = nameData[0];
        sname = nameData[1];
        await uSetPrefsValue(kNameKey,'$fname $sname');
      }
      id= prf.id!;
      tittle= prf.bio!;
      age= prf.age!=null?'${prf.age}':'0';
      pic= prf.pic;
      await uSetPrefsValue(kBioKey,tittle);
      await uSetPrefsValue(kAgeKey,'$age');
      await uSetPrefsValue(kIdkey,'$id');
      await uSetPrefsValue(kPickey,'${prf.pic}');
    }
    await uSetPrefsValue(kLinkKey,_link);

    print('age: $age, _tittle: $tittle, _link: $_link, _fname:$fname, _sname: $sname, pic: $pic');
    showProgress(false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: 'Home',)));
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

  void waitAndSetTrueAnim() {
    Future.delayed(Duration(seconds: 1),(){
     setState(() {
       selected=true;
     });
    });
  }
}
