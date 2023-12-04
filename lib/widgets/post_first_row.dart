import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/avatar_handler.dart';
import 'package:squawk/models/user_account.dart';

class PostFirstRow extends StatelessWidget {
  const PostFirstRow(this.authorMail, this.onDeleteButtonPressed, {super.key});

  final String authorMail;
  final void Function() onDeleteButtonPressed;

  @override
  Widget build(BuildContext context) {
    UserAccount? account = AccountHandler.getAccountHandler()
        .getAccountWithMail(authorMail);
    AvatarHandler avatarHandler = AvatarHandler.getAvatarHandler();
    if (account == AccountHandler.getAccountHandler().activeAccount) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatarHandler.getAvatarUrl(account!)),
            radius: 25,
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            children: [
              Text(
                account.name,
                style: GoogleFonts.lato(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                "@${account.username}",
                style: GoogleFonts.lato(color: Colors.white70),
              ),
            ],
          ),
          IconButton(onPressed: onDeleteButtonPressed, icon: const Icon(Icons.delete, color: Colors.white, size: 24,), alignment: Alignment.centerLeft,)
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatarHandler.getAvatarUrl(account!)),
            radius: 25,
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            children: [
              Text(
                account.name,
                style: GoogleFonts.lato(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                "@${account.username}",
                style: GoogleFonts.lato(color: Colors.white70),
              ),
            ],
          ),
        ],
      );
    }
  }
}