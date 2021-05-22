class Profile{
  String? id;
  String? pic;
  int? age;
  String? bio;
  String? name;
  String? link;

  Profile();

  Profile.fromMap(r) {
    id=r['id'];
    pic=r['pic'];
    age=int.tryParse(r['age'].toString())??0;
    bio=r['bio'];
    name=r['name'];
    link=r['link'];
  }

  @override
  String toString() {
    return 'id: $id, pic: $pic,, age: $age, bio: $bio, name: $name, link:$link';
  }
}