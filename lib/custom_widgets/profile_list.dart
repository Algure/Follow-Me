import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utilities/constants.dart';
import 'package:follow_me/data_objects/profile.dart';
import 'package:follow_me/screens/description_screen.dart';

class ProfileLitem extends StatelessWidget {

  ProfileLitem(this.profile);
  Profile profile= Profile();

  @override
  Widget build(BuildContext context) {
    return Container(
     height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 15,
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all( Radius.circular(15))
            ),
            height: 100,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DescriptionScreen(profile)));
              },
              child: ListTile(
                leading: Hero(
                  tag: profile.id!??'',
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image:AssetImage(kAvatarList[int.tryParse(profile.pic.toString())??0]), fit: BoxFit.fill)
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.all(5),
                hoverColor: Colors.blueGrey,
                tileColor: Colors.white,
                title: Text(profile.name??'', style: kNavTextStyle.copyWith(color: Colors.black, fontWeight: FontWeight.bold),),
                subtitle: Container(
                  height: double.maxFinite,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(profile.bio??'', overflow: TextOverflow.ellipsis, style: kNavTextStyle.copyWith(color: Colors.grey),),
                ),
                trailing: Container(
                  height: 90,
                  width: 50,
                  child: Align(
                      alignment:Alignment.bottomLeft,
                      child: Image.asset(_getImageIcon(), height: 20, width: 20,)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  String _getImageIcon() {
    String temp=profile.link!.toString().toLowerCase();
    if(temp.contains('github')){
      return 'images/github.png';
    }else if(temp.contains('facebook')){
      return 'images/facebook.png';
    }else if(temp.contains('instagram')){
      return 'images/instagram.png';
    }else if(temp.contains('linkedin')){
      return 'images/linkedin.png';
    }
    return 'images/twitter.png';
  }
}
