import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/avatar_handler.dart';
import 'package:squawk/models/user_account.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget(this.message, this.author, {super.key});
  final String message;
  final UserAccount author;

  @override
  Widget build(BuildContext context) {
    UserAccount activeAccount = AccountHandler.getAccountHandler().activeAccount!;
    AvatarHandler avatarHandler = AvatarHandler.getAvatarHandler();
    if (activeAccount == author) {
      return Container(
        width: double.infinity,
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(color: Colors.white24, width: 1.3),
            borderRadius: const BorderRadius.all(Radius.circular(132.0)
          ),),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: GoogleFonts.lato(fontSize: 14, color: Colors.white),),
              const SizedBox(width: 5,),
              CircleAvatar(
                backgroundImage: NetworkImage(
                    avatarHandler.getAvatarUrl(author)),
                radius: 22,
              ),

            ],
          ),
        )
      );
    }
    else {
      return Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white24,
              border: Border.all(color: Colors.white24, width: 1.3),
              borderRadius: const BorderRadius.all(Radius.circular(132.0)
              ),),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      avatarHandler.getAvatarUrl(author)),
                  radius: 22,
                ),
                const SizedBox(width: 5,),
                Text(message, style: GoogleFonts.lato(fontSize: 14, color: Colors.white),),
              ],
            ),
          )
      );
    }
  }
}