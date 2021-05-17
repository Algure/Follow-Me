class Profile{
  String? id;
  String? pic;
  int? age;
  String? bio;
  String? name;

  Profile();

  Profile.fromMap(r) {
    id=r['id'];
    pic=r['pic'];
    age=int.tryParse(r['age'].toString())??0;
    bio=r['bio'];
    name=r['name'];
  }

}