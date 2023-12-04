import 'package:squawk/models/storage.dart';
import 'package:squawk/models/user_account.dart';

class AvatarHandler {

  final String defaultAvatar = "https://pbs.twimg.com/profile_images/1470863148966191114/yKQoj_BU_400x400.jpg";
  static final AvatarHandler _instance = AvatarHandler();
  static AvatarHandler getAvatarHandler() {
    return _instance;
  }

  String getAvatarUrl(UserAccount account) {
    if (account.photoUrl != "") {
      return account.photoUrl;
    }
    else {
      return defaultAvatar;
    }
  }

  void setAvatarUrl(UserAccount account, String photo) {
    Storage storage = Storage.getStorage();
    account.photoUrl = photo;
    storage.insertAccount(account);
  }

}