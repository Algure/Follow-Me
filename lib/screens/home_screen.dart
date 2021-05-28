import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:follow_me/azure.dart';
import 'package:follow_me/constants.dart';
import 'package:follow_me/custom_widgets/profile_list.dart';
import 'package:follow_me/data_objects/profile.dart';
import 'package:follow_me/screens/profile_screen.dart';
import 'package:follow_me/utitlity_functions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyHomePage extends StatefulWidget {

  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> proWidgets= [];
  Color hintColor=Colors.grey;
  var _progress;

  RefreshController _rController= RefreshController(initialRefresh: false);
  GlobalKey _dropdownButtonKey = GlobalKey(debugLabel: 'GlobalDropdownKey');

  String searchText='';

  bool _inSearchMode=false;

  List<DropdownMenuItem<String>> _filterList=[
    DropdownMenuItem<String>(child: Text( 'Age-range: 1-10'), value: '1-10') ,
    DropdownMenuItem<String>(child: Text('Age-range: 11-20',), value:'11-20') ,
    DropdownMenuItem<String>(child: Text('Age-range: 21-30'), value:'21-30') ,
    DropdownMenuItem<String>(child: Text('Age-range: 31-40'), value:'31-40') ,
    DropdownMenuItem<String>(child: Text('Age-range: 41-50'), value:'41-50') ,
    DropdownMenuItem<String>(child: Text('Age-range: 51-60'), value:'51-60') ,
    DropdownMenuItem<String>(child: Text('Age-range: 61-70'), value:'61-70') ,
    DropdownMenuItem<String>(child: Text('Age-range: 71-80'), value:'71-80') ,
    DropdownMenuItem<String>(child: Text('Age-range: 90-100'), value:'90-100') ,
    ];

  bool _inFilterMode=false;

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
        title: Hero(
            tag: 'fologo',
            child: Image.asset('images/logo.png', color: Colors.blue, height: 50, width: 150,)),// Text('Follow Me', style: TextStyle(color: Colors.blue),),
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
                onEditingComplete: (){
                  // setState(() {
                  //   _descFocus.unfocus();
                  // });
                },
                onChanged: (text){
                  searchText=text;
                  // _setSocialIcon();
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
            // width: _inFilterMode?MediaQuery.of(context).size.width*0.6:50,
            duration: Duration(milliseconds: 500),
            child: _inFilterMode?
            DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton <String>(
                    key:  _dropdownButtonKey,
                    dropdownColor: Colors.white,
                    isDense: true,
                    icon: Icon(Icons.filter_list_sharp, color: Colors.blue, size: 24,),
                    style: TextStyle(color: Colors.black),
                    items: this._filterList,
                    onChanged: (value){
                      _filterDb(value!);
                    }),
              ),
            )
                : MaterialButton(onPressed: () { _setFilterMode(true); },
                child: Icon(Icons.filter_alt_outlined, color: Colors.blue, size: 25,)),
          ),


          SizedBox(width: 10,),
        ],
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context)=> Center(
            child: SmartRefresher(
              controller: _rController,
              onRefresh: _setProfiles,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToProfilePage,
        tooltip: 'Increment',
        backgroundColor: Colors.blue,
        child: Icon(Icons.person_outline_outlined,color: Colors.white,),
      ),
    );
  }

  void _goToProfilePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
  }

  _setProfiles() async {
    _setSearchMode(false);
    showProgress(true);
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
    showProgress(false);
  }

  void showProgress(bool bool) {
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
    showProgress(true);
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
    showProgress(false);
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
    showProgress(true);
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
    showProgress(false);
  }

  void openDropdown() {
    GestureDetector? detector;
    void searchForGestureDetector(BuildContext? element) {
      element!.visitChildElements((element) {
        if (element.widget != null && element.widget is GestureDetector) {
          detector = element.widget as GestureDetector?;
          return ;//false;
        } else {
          searchForGestureDetector(element);
        }
        return;// true;
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
    if(_inFilterMode)openDropdown();
  }
}
