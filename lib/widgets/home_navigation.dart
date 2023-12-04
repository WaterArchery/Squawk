import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/avatar_handler.dart';
import 'package:squawk/handlers/theme_handler.dart';
import 'package:squawk/models/user_account.dart';
import 'package:squawk/squawk.dart';
import 'package:squawk/widgets/custom_list_tile.dart';

class HomeNavigation extends StatelessWidget {
  const HomeNavigation(this.userAccount, {super.key});

  final UserAccount userAccount;

  @override
  Widget build(BuildContext context) {
    ThemeHandler themeHandler = ThemeHandler.getInstance();
    UserAccount? account = AccountHandler.getAccountHandler().activeAccount;
    AvatarHandler avatarHandler = AvatarHandler.getAvatarHandler();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 185,
            decoration: BoxDecoration(color: themeHandler.getNavbarBackground()),
            child: Column(
              children: [
                const SizedBox(height: 40,),
                CircleAvatar(
                  radius: 37,
                  child: Image.network(
                    avatarHandler.getAvatarUrl(account!),
                  ),
                ),
                const SizedBox(height: 15,),
                Text(userAccount.name, style: textStyle(),),
                Text(userAccount.mail, style: textStyle(),),
              ],
            ),
          ),
          CustomListTile(Icons.home, "Home", openHome),
          CustomListTile(Icons.account_box, "Profile", openProfile),
          CustomListTile(Icons.search, "Search Profile", openSearch),
          CustomListTile(Icons.message, "Messages", openMessageHub),
          CustomListTile(Icons.settings, "Settings", openSettings),
          CustomListTile(Icons.logout, "Log Out", () {onLogOut(context);}),
        ],
      ),
    );
  }

  TextStyle? textStyle() {
    return const TextStyle(color: Colors.white, fontSize: 15);
  }

  void onLogOut(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed:  () async {
        Navigator.pop(context);
        AccountHandler accountHandler = AccountHandler.getAccountHandler();
        accountHandler.activeAccount = null;
        SquawkState state = SquawkState.getState();
        state.updatePage("first");
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('mail');
        await prefs.remove('pass');
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Log Out?"),
      content: const Text("Are you sure to log out?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void openSettings() {
    SquawkState squawkState = SquawkState.getState();
    squawkState.updatePage("settings");
  }

  void openMessageHub() {
    SquawkState squawkState = SquawkState.getState();
    squawkState.updatePage("messageHub");
  }

  void openSearch() {
    SquawkState squawkState = SquawkState.getState();
    squawkState.updatePage("search");
  }

  void openProfile() {
    SquawkState squawkState = SquawkState.getState();
    squawkState.updatePage("profile");
  }

  void openHome() {
    SquawkState squawkState = SquawkState.getState();
    squawkState.updatePage("home");
  }

}
