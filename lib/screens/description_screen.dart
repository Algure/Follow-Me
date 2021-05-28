
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:follow_me/constants.dart';
import 'package:follow_me/data_objects/profile.dart';
import 'package:follow_me/utitlity_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class DescriptionScreen  extends StatefulWidget {

  DescriptionScreen(this.profile);

  Profile profile= Profile();
  @override
  _State createState() => _State();
}

class _State extends State<DescriptionScreen> {
  var imageIndex=0;
  String? _iconString;
  Widget _socialIcon=SizedBox.shrink();


  @override
  void initState() {
    _setSocialIcon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text('My Profile', style: TextStyle(color: Colors.blue),),
        elevation: 0,
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context)=>SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Hero(
                    tag: widget.profile.id.toString()??'',
                    child: ClipOval(
                        child: Image.asset(kAvatarList[int.tryParse(widget.profile.pic.toString())??0], height: MediaQuery.of(context).size.height*0.2,)
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  child: Text(widget.profile.name??'', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900,           fontSize: 18),),
                ),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  child: Text(widget.profile.bio??'', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w900,    fontSize: 15),),
                ),
                SizedBox(height: 50,),
                MaterialButton(
                  padding: const EdgeInsets.all(12.0),
                  onPressed: () { openLink(); },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                  [
                    _socialIcon,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.profile.link??'', overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w900, fontSize: 15),),
                    )
                  ]
                  ),
                ),

              ],
            ),
          ),
        ),
      )
    );
  }

  void showProgress(bool bool) {
    if(bool)EasyLoading.show(status: 'loading...');
    else EasyLoading.dismiss();
    setState(() {

    });
  }

  void _setSocialIcon() {
    String? iconString= _getImageIcon(widget.profile.link??'');
    if(iconString==null){
      _socialIcon=Image.asset('images/twitter.png'??'', height: 20, width: 20,);
      return;
    }
    if(_iconString!=iconString){
      _iconString=iconString;
      _socialIcon=Image.asset(_iconString??'', height: 20, width: 20,);
      setState(() {

      });
    }
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

  void openLink() async{
    showProgress(true);
    if(await canLaunch(widget.profile.link!) ){
      await launch(widget.profile.link!);
    }else{
      uShowErrorNotification('Invalid link');
    }
    showProgress(false);
  }
}
