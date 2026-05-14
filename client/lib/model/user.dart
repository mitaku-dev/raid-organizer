class User {
  String _username = "";
  String _profilePicUrl = "";
  String _email = "";
  int _id = 0;


  String get username => _username;
  String get profilePicUrl => _profilePicUrl;
  String get email => _email;
  int get id => _id;

  User({
    required id,
    required username,
    required profilePicUrl,
    required email,
    }) {
    _username =  username;
    _profilePicUrl = profilePicUrl;
    _email = email;
    _id = id;
  }

  static User fromMap(Map<String,dynamic> json){
    return User(
        username: json['username'] ?? "",
        profilePicUrl: json['profilePicUrl'] ?? "",
        email: json['email']?? "",
        id: json['id'] ?? 0
    );
  }

  static List<User> listFromMap(Iterable json){
    return List<User>.from(json.map((model) => User.fromMap(model)));
  }

}