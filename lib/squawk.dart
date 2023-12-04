import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/post_handler.dart';
import 'package:squawk/models/squawk_post.dart';
import 'package:squawk/models/user_account.dart';
import 'package:squawk/pages/first_page.dart';
import 'package:squawk/pages/home_page.dart';
import 'package:squawk/pages/login_page.dart';
import 'package:squawk/pages/message_hub_page.dart';
import 'package:squawk/pages/message_send_page.dart';
import 'package:squawk/pages/my_profile_page.dart';
import 'package:squawk/pages/post_page.dart';
import 'package:squawk/pages/register_page.dart';
import 'package:squawk/pages/search_page.dart';
import 'package:squawk/pages/settings_page.dart';
import 'package:squawk/pages/user_profile_page.dart';
import 'package:squawk/widgets/post_widget.dart';

class Squawk extends StatefulWidget {
  const Squawk({super.key});

  @override
  State<Squawk> createState() {
    return SquawkState();
  }
}

class SquawkState extends State<Squawk> {
  static late SquawkState _state;

  @override
  void initState() {
    super.initState();
    _state = this;
    checkAutoLogin();
  }

  static SquawkState getState() {
    return _state;
  }

  String activePage = "first";

  @override
  Widget build(BuildContext context) {
    if (activePage == 'first') {
      return const FirstPage();
    } else if (activePage == 'home') {
      return const HomePage();
    } else if (activePage == 'login') {
      return const LoginPage();
    } else if (activePage == 'register') {
      return const RegisterPage();
    } else if (activePage == 'search') {
      return const SearchPage();
    } else if (activePage == 'profile') {
      return const MyProfilePage();
    } else if (activePage.contains('otherProfile*')) {
      String userName = activePage.replaceAll('otherProfile*', "");
      UserAccount? account =
          AccountHandler.getAccountHandler().getAccountWithName(userName);
      return UserProfilePage(account!);
    } else if (activePage.contains('postPage*')) {
      String postID = activePage.replaceAll('postPage*', "");
      PostWidget? finalPost;
      PostHandler postHandler = PostHandler.getInstance();
      for (SquawkPost squawkPost in postHandler.allPosts) {
        if (squawkPost.id.toString() == postID) {
          finalPost = PostWidget(squawkPost, onDeletePost);
        }
      }
      if (finalPost != null) {
        return PostPage(finalPost);
      }
      else {
        return const HomePage();
      }
    } else if (activePage == 'settings') {
      return const SettingsPage();
    }
    else if (activePage == 'messageHub') {
      return const MessageHubPage();
    }
    else if (activePage.contains('messages*')) {
      String userName = activePage.replaceAll('messages*', "");
      UserAccount? account = AccountHandler.getAccountHandler().getAccountWithName(userName);
      return MessageSendPage(account!);
    }
    else {
      return const FirstPage();
    }
  }

  void onDeletePost(PostWidget postWidget) {
    setState(() {
      PostHandler.getInstance().allPosts.remove(postWidget.post);
    });
  }

  Future<void> checkAutoLogin() async {
    if (activePage == 'first') {
      final prefs = await SharedPreferences.getInstance();
      final mail = prefs.getString('mail') ?? "";
      final pass = prefs.getString('pass') ?? "";
      AccountHandler accountHandler = AccountHandler.getAccountHandler();
      UserAccount? account = accountHandler.getAccountWithMail(mail);
      if (account != null && account.password == pass) {
        updatePage("home");
        accountHandler.setActiveAccount(account);
      } else {
        await prefs.remove('mail');
        await prefs.remove('pass');
      }
    }
  }

  void updatePage(String page) {
    setState(() {
      activePage = page;
    });
  }


}
