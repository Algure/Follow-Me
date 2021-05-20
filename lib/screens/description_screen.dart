
import 'package:flutter/material.dart';
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
                    tag: widget.profile.id!??'',
                    child: ClipOval(
                        child: Image.asset(kAvatarList[int.tryParse(widget.profile.pic!)??0], height: MediaQuery.of(context).size.height*0.2,)
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  child: Text(widget.profile.bio??'', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w900,           fontSize: 15),),
                ),
                SizedBox(height: 50,),
                MaterialButton(
                  padding: const EdgeInsets.all(12.0),
                  onPressed: () { openLink(); },
                  child: Text(widget.profile.link??'', textAlign: TextAlign.start, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w900,           fontSize: 15),),
                ),

              ],
            ),
          ),
        ),
      )
    );
  }

  void showProgress(bool bool) {
    if(bool)ProgressHUD.of(context)!.show();
    else ProgressHUD.of(context)!.dismiss();
  }

  void openLink() async{
    showProgress(true);
    if(await canLaunch(widget.profile.id!) ){
      await launch(widget.profile.id!);
    }else{
      uShowErrorNotification('Invalid twitter link');
    }
    showProgress(false);
  }
}
