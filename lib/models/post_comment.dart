
class PostComment {
  PostComment(this.postID, this.message, this.authorID);


  int postID;
  String message;
  int authorID;
  List<int> likedAccounts = [];

  void addLike(int accountID) {
    likedAccounts.add(accountID);
  }

  void removeLike(int accountID) {
    likedAccounts.remove(accountID);
  }

  String stringToList(List<Object> list) {
    String finalString = "";
    for (Object object in list) {
      finalString = "$finalString, $object";
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

}