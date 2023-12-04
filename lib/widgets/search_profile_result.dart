import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/avatar_handler.dart';
import 'package:squawk/handlers/theme_handler.dart';
import 'package:squawk/models/user_account.dart';
import 'package:squawk/squawk.dart';

class SearchProfileResult extends StatelessWidget {
  const SearchProfileResult(this.account, {super.key});

  final UserAccount account;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final AvatarHandler avatarHandler = AvatarHandler.getAvatarHandler();
    final ThemeHandler themeHandler = ThemeHandler.getInstance();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          color: themeHandler.getNavbarBackground(),
        ),
        padding: const EdgeInsets.all(12),
        width: (width * 93) / 100,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  avatarHandler.getAvatarUrl(account)),
              radius: 30,
            ),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Name: ${account.name}", style: GoogleFonts.lato(fontSize: 16, color: Colors.white),),
                Text("User Name: ${account.username}", style: GoogleFonts.lato(fontSize: 16, color: Colors.white)),
              ],
            ),)
          ],
        ),
      ),
    );
  }

  void onTap() {
    SquawkState state = SquawkState.getState();
    if (account == AccountHandler.getAccountHandler().activeAccount!) {
      state.updatePage("profile");
    }
    else {
      state.updatePage("otherProfile*${account.username}");
    }
  }

}