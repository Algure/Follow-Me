import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:follow_me/azure.dart';
import 'package:follow_me/custom_widgets/profile_list.dart';
import 'package:follow_me/data_objects/profile.dart';
import 'package:follow_me/screens/profile_screen.dart';

class MyHomePage extends StatefulWidget {

  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> proWidgets= [];

  var _progress;


  @override
  void initState() {
    _setProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Follow Me', style: TextStyle(color: Colors.blue),),
        elevation: 0,
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context)=> Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: proWidgets
              ),
            ),
          ),
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToProfilePage,
        tooltip: 'Increment',
        backgroundColor: Colors.blue,
        child: Icon(Icons.person_add,color: Colors.white,),
      ),
    );
  }

  Future<void> _loadProfiles() async {
    List<Profile> proList= await AzureSingle().getAllProfiles();
    for(Profile profile in proList)proWidgets.add(ProfileLitem(profile));

  }

  void _goToProfilePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
  }

  _setProfiles() async {
    showProgress(true);
    List<Profile> proList= await AzureSingle().getAllProfiles();
    proWidgets=[];
    for(Profile pro in proList){
      if(pro==null) continue;
      proWidgets.add(ProfileLitem(pro));
    }
    showProgress(false);
  }

  void showProgress(bool bool) {
    if(bool)EasyLoading.show(status: 'loading...');
    else EasyLoading.dismiss();
    setState(() {

    });
  }
}
