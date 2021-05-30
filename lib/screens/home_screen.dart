import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../utilities/azure.dart';
import 'package:follow_me/custom_widgets/profile_list.dart';
import 'package:follow_me/data_objects/profile.dart';
import 'package:follow_me/screens/profile_screen.dart';
import '../utilities/utitlity_functions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {

  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey _dropdownButtonKey = GlobalKey(debugLabel: 'GlobalDropdownKey');
  Color hintColor=Colors.grey;

  bool _inSearchMode=false;
  bool _inFilterMode=false;

  String searchText='';
  String? _filterValue='';

  List<Widget> proWidgets= [];
  List<DropdownMenuItem<String>> _filterList=[
      DropdownMenuItem<String>(child: Text( 'Select range', overflow: TextOverflow.ellipsis,), value: '') ,
      DropdownMenuItem<String>(child: Text( 'Age-range: 1-10', overflow: TextOverflow.ellipsis,), value: '1-10') ,
      DropdownMenuItem<String>(child: Text('Age-range: 11-20', overflow: TextOverflow.ellipsis,), value:'11-20') ,
      DropdownMenuItem<String>(child: Text('Age-range: 21-30', overflow: TextOverflow.ellipsis,), value:'21-30') ,
      DropdownMenuItem<String>(child: Text('Age-range: 31-40', overflow: TextOverflow.ellipsis,), value:'31-40') ,
      DropdownMenuItem<String>(child: Text('Age-range: 41-50', overflow: TextOverflow.ellipsis,), value:'41-50') ,
      DropdownMenuItem<String>(child: Text('Age-range: 51-60', overflow: TextOverflow.ellipsis,), value:'51-60') ,
      DropdownMenuItem<String>(child: Text('Age-range: 61-70', overflow: TextOverflow.ellipsis,), value:'61-70') ,
      DropdownMenuItem<String>(child: Text('Age-range: 71-80', overflow: TextOverflow.ellipsis,), value:'71-80') ,
      DropdownMenuItem<String>(child: Text('Age-range: 90-100', overflow: TextOverflow.ellipsis,), value:'90-100') ,
    ];

  RefreshController _rController= RefreshController(initialRefresh: false);

  @override
  void initState() {
    _setProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: _goToProfilePage,
          child: Icon(Icons.person_outline_outlined,color: Colors.blue, size: 24,),
        ),
        backgroundColor: Colors.white,
        title: Hero(
            tag: 'fologo',
            child: Image.asset('images/logo.png', color: Colors.blue, height: 50, width: 150,)),
        elevation: 0,
        actions: [
          AnimatedContainer(
            height: 50,
            width: _inSearchMode?MediaQuery.of(context).size.width*0.6:50,
            duration: Duration(milliseconds: 500),
            child: _inSearchMode?
                TextFormField(
                controller: TextEditingController(
                  text: searchText,
                ),
                style: TextStyle(color: Colors.black),//kInputTextStyle,
                textAlign: TextAlign.start,
                autofocus: false,
                onChanged: (text){
                  searchText=text;
                },
                textInputAction: TextInputAction.go,
                onFieldSubmitted: _startSearch,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xAAEEEEFF),
                    hintText: 'Enter name or bio text',
                    hintStyle: TextStyle(
                        color:hintColor
                    ),
                    suffixIcon: Padding(padding: EdgeInsets.all(5),child: GestureDetector(
                        onTap: (){
                          _setSearchMode(false);
                          _setProfiles();
                        },
                        child: Icon(Icons.search_off, color: Colors.black,))),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15)), borderSide: BorderSide.none),
                    // focusedBorder: kLinedFocusedBorder,
                    // enabledBorder: kLinedBorder,
                    // disabledBorder: kLinedBorder
                )
            )
                : MaterialButton(onPressed: () { _setSearchMode(true); },
              child: Icon(Icons.search, color: Colors.blue, size: 25,)),
          ),
          AnimatedContainer(
            height: 50,
            duration: Duration(milliseconds: 500),
            child: _inFilterMode?
            DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton <String>(
                    key:  _dropdownButtonKey,
                    isDense: true,
                    icon: Icon(Icons.filter_list_sharp, color: Colors.blue, size: 24,),
                    style: TextStyle(color: Colors.black),
                    items: this._filterList,
                    value: _filterValue,
                    onChanged: (value){
                      _filterValue=value;
                      _filterDb(value!);
                    }),
              ),
            )
                : MaterialButton(onPressed: () { _setFilterMode(true); },
                child: Icon(Icons.filter_alt_outlined, color: Colors.blue, size: 25,)),
          ),
          GestureDetector(
              onTap: displayAboutDialog,
              child: Icon(Icons.info_outline, color: Colors.blue, size: 25,)),
          SizedBox(width: 10,),
        ],
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context)=> Center(
            child: SmartRefresher(
              controller: _rController,
              onRefresh: _setProfiles,
              child: MediaQuery.of(context).size.width>=800?
              GridView(
                  padding: EdgeInsets.all(10),
                  children:proWidgets,
                  // semanticChildCount: proWidgets.l,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 5
                  )
              ):
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: proWidgets
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }

  displayAboutDialog(){
    showAboutDialog(
        applicationName: '',
        context: this.context,
        applicationIcon:Container(child: Image.asset('images/logo.png',height: 100, width: 100,),),
        children: [
           SizedBox(height: 20,),
          Row(children:[
            Text('Developed by', style: TextStyle(fontSize: 10,color: Colors.grey),),
            GestureDetector(
                onTap: () async {
                  await launch('https://www.linkedin.com/in/ajiri-gunn-a85352169/');
                },
                child: Text(' Algure', style: TextStyle(fontSize: 10,color: Colors.blue),)),
          ]),

          Row(children:[
            Text('Avatars from ', style: TextStyle(fontSize: 10,color: Colors.grey),),
            GestureDetector(
                onTap: () async {await launch('https://www.freepik.com');},
                child: Text(' https://www.freepik.com', style: TextStyle(fontSize: 10,color: Colors.blue),)),
          ]),
          SizedBox(height: 20,),
          Text('Powered by Azure', style: TextStyle(fontSize: 8,color: Colors.blue.shade900.withOpacity(0.5)),),
        ]
    );
  }

  void _goToProfilePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
  }

  _setProfiles() async {
    _setSearchMode(false);
    _setFilterMode(false);
    _showProgress(true);
    try {
      List<Profile> proList = await AzureSingle().getAllProfiles();
      proWidgets = [];
      for (Profile pro in proList) {
        if (pro == null) continue;
        proWidgets.add(ProfileLitem(pro));
      }
    }catch(e,t){
      uShowErrorNotification('An error occured. Drag to refresh.');
      print(' profile fetch error: $e, trace: $t');
    }
    _showProgress(false);
  }

  void _showProgress(bool bool) {
    _rController.refreshCompleted();
    if(bool)EasyLoading.show(status: 'loading...');
    else EasyLoading.dismiss();
    setState(() {

    });
  }

  Future<void> _startSearch(String value) async {
    if (value==null || value.trim().isEmpty){
      await  _setProfiles();
      return;
    }
    _showProgress(true);
    try {
      List<Profile> proList = await AzureSingle().searchProfiles(value);
      proWidgets = [];
      for (Profile pro in proList) {
        if (pro == null) continue;
        proWidgets.add(ProfileLitem(pro));
      }
    }catch(e,t){
      uShowErrorNotification('An error occured. Drag to refresh.');
      print(' profile fetch error: $e, trace: $t');
    }
    _showProgress(false);
  }

  void _setSearchMode(bool bool) {
    setState(() {
      _inSearchMode=bool;
      _inFilterMode=false;
    });
  }

  Future<void> _filterDb(String value) async {
    List<String> range= value.split('-');
    if(range.length!=2)return;
    _showProgress(true);
    try {
      List<Profile> proList = await AzureSingle().filterProfiles(value);
      proWidgets = [];
      for (Profile pro in proList) {
        if (pro == null) continue;
        proWidgets.add(ProfileLitem(pro));
      }
    }catch(e,t){
      uShowErrorNotification('An error occured. Drag to refresh.');
      print(' profile fetch error: $e, trace: $t');
    }
    _showProgress(false);
  }

  void openDropdown() {
    GestureDetector? detector;
    void searchForGestureDetector(BuildContext? element) {
      element!.visitChildElements((element) {
        if (element.widget != null && element.widget is GestureDetector) {
          detector = element.widget as GestureDetector?;
          return ;
        } else {
          searchForGestureDetector(element);
        }
        return;
      });
    }
    searchForGestureDetector(_dropdownButtonKey.currentContext);
    assert(detector != null);
    detector!.onTap!();
  }

  void _setFilterMode(bool bool) {
    setState(() {
      _inFilterMode=bool;
      _inSearchMode=false;
    });
  }
}
