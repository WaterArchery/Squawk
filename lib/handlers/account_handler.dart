import 'dart:collection';

import 'package:squawk/models/storage.dart';
import 'package:squawk/models/user_account.dart';

class AccountHandler {
  static final AccountHandler _instance = AccountHandler();
  final List<UserAccount> accounts = [];

  static AccountHandler getAccountHandler() {
    return _instance;
  }

  void addAccount(UserAccount account) {
    accounts.add(account);
  }

  void removeAccount(UserAccount account) {
    accounts.remove(account);
  }

  Future<void> loadAccounts() async {
    Storage storage = Storage.getStorage();
    UserAccount account;
    Map<UserAccount, String> followersMap = HashMap();
    await storage.getAccounts().then((value) => {
          if (value != null)
            {
              for (Map<String, dynamic> map in value)
                {
                  account = UserAccount(
                    map['mail'],
                    map['username'],
                    map['name'],
                    map['password'],
                    map['photoUrl'],
                    map['bannerUrl'],
                    map['joinDate'],
                    map['location'],
                    map['description']),
                  addAccount(account),
                  if (map['followers'] != null) {
                    followersMap.putIfAbsent(account, () => map['followers']),
                  }
                },
            }
        });
    for (UserAccount account in followersMap.keys) {
      addFollowers(account, followersMap[account]!);
    }
  }

  void addFollowers(UserAccount account, String rawFollowers) {
    List<String> rawMails = account.stringToList(rawFollowers);
    for (String rawMail in rawMails) {
      UserAccount? user = getAccountWithMail(rawMail);
      if (user != null) {
        account.followers.add(user);
      }
    }
  }

  UserAccount? getAccountWithMail(String mail) {
    for (UserAccount account in accounts) {
      if (account.mail == mail) {
        return account;
      }
    }
    return null;
  }

  UserAccount? getAccountWithName(String username) {
    for (UserAccount account in accounts) {
      if (account.username == username) {
        return account;
      }
    }
    return null;
  }

  UserAccount? activeAccount;

  void setActiveAccount(UserAccount account) {
    activeAccount = account;
  }

  bool isFollowed(UserAccount account1, UserAccount account2) {
    return account1.followers.contains(account2);
  }
}
