class UserAccount {
  UserAccount(
      this.mail,
      this.username,
      this.name,
      this.password,
      this.photoUrl,
      this.bannerUrl,
      this.joinDate,
      this.location,
      this.description,);

  //Mail is the primary key
  final String mail;
  String name;
  String username;
  String password;
  String photoUrl;
  String bannerUrl;
  final int joinDate;
  String location;
  String description;
  final List<UserAccount> followers = [];

  void addFollower(UserAccount account) {
    followers.add(account);
  }

  Map<String, dynamic> toMap() {
    return {
      'mail': mail,
      'username': username,
      'name': name,
      'password': password,
      'followers': listToString(followers),
      'photoUrl': photoUrl,
      'bannerUrl': bannerUrl,
      'joinDate': joinDate,
      'location': location,
      'description': description
    };
  }

  String listToString(List<UserAccount> list) {
    String finalString = "";
    for (UserAccount account in list) {
      if (finalString == "") {
        finalString = account.mail;
      }
      else {
        finalString = "$finalString, ${account.mail}";
      }
    }
    return finalString;
  }

  List<String> stringToList(String rawList) {
    List<String> finalList = [];
    for (String part in rawList.split(", ")) {
      finalList.add(part);
    }
    return finalList;
  }

}