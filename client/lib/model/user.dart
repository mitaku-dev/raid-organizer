class User {
  String _username = "";
  String _profilePicUrl = "";

  String get username => _username;
  String get profilePicUrl => _profilePicUrl;

  User({
    required username,
    required profilePicUrl
    }) {
    _username =  username;
    _profilePicUrl = profilePicUrl;
  }

}