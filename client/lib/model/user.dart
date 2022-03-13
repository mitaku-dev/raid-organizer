class User {
  String _username = "";
  String _profilePicUrl = "";
  String _email = "";


  String get username => _username;
  String get profilePicUrl => _profilePicUrl;
  String get email => _email;

  User({
    required username,
    required profilePicUrl,
    required email,
    }) {
    _username =  username;
    _profilePicUrl = profilePicUrl;
    _email = email;
  }

  static User fromMap(Map<String,dynamic> json){
    return User(
        username: json['username'] ?? "",
        profilePicUrl: json['profilePicUrl'] ?? "",
        email: json['email']?? ""
    );
  }

}