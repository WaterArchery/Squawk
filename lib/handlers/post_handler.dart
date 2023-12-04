import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/models/squawk_post.dart';
import 'package:squawk/models/storage.dart';
import 'package:squawk/models/user_account.dart';

class PostHandler {
  static final PostHandler _instance = PostHandler();
  List<SquawkPost> allPosts = [];

  static PostHandler getInstance() {
    return _instance;
  }

  Future<void> loadPosts() async {
    allPosts.clear();
    Storage storage = Storage.getStorage();
    await storage.getAllPosts().then((allPosts) => {
      for (SquawkPost squawkPost in allPosts){
        this.allPosts.add(squawkPost),
      },
      print("${allPosts.length} total post loaded!"),
    });
  }

  List<SquawkPost> getUserPosts(UserAccount user) {
    AccountHandler accountHandler = AccountHandler.getAccountHandler();
    List<SquawkPost> userPosts = [];

    for (SquawkPost squawkPost in allPosts){
      UserAccount? author = accountHandler.getAccountWithMail(squawkPost.authorMail);
      if (squawkPost.parentPostID == -1 && (squawkPost.authorMail == user.mail || author!.followers.contains(user))) {
        userPosts.add(squawkPost);
      }
    }
    return userPosts;
  }

  List<SquawkPost> getOwnerPosts(UserAccount user) {
    List<SquawkPost> userPosts = [];
    for (SquawkPost squawkPost in allPosts){
      if (squawkPost.parentPostID == -1 && squawkPost.authorMail == user.mail) {
        userPosts.add(squawkPost);
      }
    }
    return userPosts;
  }

  List<SquawkPost> getLikedPosts(UserAccount user) {
    List<SquawkPost> userPosts = [];
    for (SquawkPost squawkPost in allPosts){
      if (squawkPost.likedAccounts.contains(user.mail)) {
        userPosts.add(squawkPost);
      }
    }
    return userPosts;
  }

  List<SquawkPost> getChildPosts(int parentID) {
    List<SquawkPost> childPosts = [];
    for (SquawkPost squawkPost in allPosts){
      if (squawkPost.parentPostID != -1 && squawkPost.parentPostID == parentID) {
        childPosts.add(squawkPost);
      }
    }
    return childPosts;
  }

  void deletePost(SquawkPost post) {
    List<SquawkPost> tempList = [];
    for (SquawkPost squawkPost in allPosts) {
      if (squawkPost.id == post.id || squawkPost.parentPostID == post.id) {
        tempList.add(squawkPost);
      }
    }
    allPosts.removeWhere((key) => tempList.contains(key));
  }

}