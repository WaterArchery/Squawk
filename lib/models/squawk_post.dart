import 'user_account.dart';

class SquawkPost {
  SquawkPost(this.id, this.message, this.authorMail);

  String message;
  String authorMail;
  List<String> likedAccounts = [];
  List<String> comments = [];
  int id;
  int parentPostID = -1;

  void addLike(UserAccount account) {
    //TODO LIKE LOGIC
    likedAccounts.add(account.mail);
  }

  void removeLike(UserAccount account) {
    //TODO LIKE LOGIC
    likedAccounts.remove(account.mail);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': authorMail,
      'message': message,
      'parentPostID': parentPostID,
      'likes': stringToList(likedAccounts),
      'comments': stringToList(comments)
    };
  }

  String stringToList(List<Object> list) {
    String finalString = "";
    for (Object object in list) {
      if (finalString != "") {
        finalString = "$finalString, $object";
      }
      else {
        finalString = "$object";
      }
    }
    return finalString;
  }

  List<String> listToString(String rawList) {
    List<String> finalList = [];
    for (String part in rawList.split(", ")) {
      finalList.add(part);
    }
    return finalList;
  }

  @override
  String toString() {
    return 'SquawkPost{message: $message, authorID: $authorMail, likedAccounts: $likedAccounts}';
  }

}