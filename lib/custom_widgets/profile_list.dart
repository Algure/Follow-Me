import 'package:flutter/material.dart';
import 'package:follow_me/constants.dart';
import 'package:follow_me/data_objects/profile.dart';
import 'package:follow_me/screens/description_screen.dart';
import 'package:follow_me/screens/profile_screen.dart';
import 'package:follow_me/utitlity_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileLitem extends StatelessWidget {

  ProfileLitem(this.profile);
  Profile profile= Profile();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all( Radius.circular(15))
        ),
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>DescriptionScreen(profile)));
          },
          child: ListTile(
            leading: Hero(
              tag: profile.id!,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image:AssetImage(kAvatarList[int.tryParse(profile.pic!)??0]), fit: BoxFit.fill)
                ),
              ),
            ),
            contentPadding: EdgeInsets.all(5),
            hoverColor: Colors.blueGrey,
            tileColor: Colors.white,
            title: Text(profile.name!??'', style: kNavTextStyle.copyWith(color: Colors.black),),
            subtitle: Container(
              height: double.maxFinite,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: _launchTwitter,
                child: Text(profile.id!??'', style: kNavTextStyle.copyWith(color: Colors.blue),),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchTwitter() async {
    if(await canLaunch(profile.id!)){
      launch(profile.id!);
    }else{
      uShowErrorNotification('Can\'t launch url');
    }
  }
}
