import 'dart:math';

import 'package:flutter/material.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/post_handler.dart';
import 'package:squawk/handlers/theme_handler.dart';
import 'package:squawk/models/squawk_post.dart';
import 'package:squawk/models/storage.dart';
import 'package:squawk/models/user_account.dart';
import 'package:squawk/squawk.dart';
import 'package:squawk/widgets/iconed_button.dart';
import 'package:squawk/widgets/post_first_row.dart';

class PostWidget extends StatefulWidget {
  PostWidget(this.post, this.deletePost, {super.key});
  final SquawkPost post;
  Color likeColor = Colors.white;
  final void Function(PostWidget postWidget) deletePost;

  @override
  State<PostWidget> createState() {
    return _PostWidgetState();
  }

  void setLikeColor() {
    AccountHandler accountHandler = AccountHandler.getAccountHandler();
    UserAccount userAccount = accountHandler.activeAccount!;
    if (post.likedAccounts.contains(userAccount.mail)) {
      likeColor = Colors.redAccent;
    } else {
      likeColor = Colors.white;
    }
  }

}

class _PostWidgetState extends State<PostWidget> {
  late Color commentColor;
  ThemeHandler themeHandler = ThemeHandler.getInstance();

  @override
  void initState() {
    super.initState();
    widget.setLikeColor();
    commentColor = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    double height = max((widget.post.message.length / 2 - 2), 13);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: themeHandler.getBlack()),
          ),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: onPostAuthorClick,
              child: PostFirstRow(widget.post.authorMail, deleteButtonPressed),
            ),
            Container(
              alignment: Alignment.center,
              height: height,
              margin: const EdgeInsets.fromLTRB(15, 7, 15, 0),
              child: Text(
                widget.post.message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                softWrap: false,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconedButton(
                    likeButtonPressed, Icons.favorite, "", 8, 8, widget.likeColor),
                Text("${widget.post.likedAccounts.length}",
                    style: const TextStyle(color: Colors.white)),
                IconedButton(
                    onCommentClick, Icons.comment, "", 8, 8, commentColor),
                Text(
                  "${getCommentCount()}",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  int getCommentCount() {
    int count = PostHandler.getInstance().getChildPosts(widget.post.id).length;
    return count;
  }

  void onTap() {
    SquawkState state = SquawkState.getState();
    if (widget.post.parentPostID == -1) {
      setState(() {
        state.updatePage("postPage*${widget.post.id}");
      });
    }
    else {
      setState(() {
        state.updatePage("postPage*${widget.post.parentPostID}");
      });
    }
  }

  void onPostAuthorClick() {
    SquawkState state = SquawkState.getState();
    AccountHandler accountHandler = AccountHandler.getAccountHandler();
    UserAccount account = accountHandler.getAccountWithMail(widget.post.authorMail)!;
    if (account == accountHandler.activeAccount!) {
      state.updatePage("profile");
    }
    else {
      state.updatePage("otherProfile*${account.username}");
    }
  }

  void onCommentClick() {
    onTap();
  }

  void deleteButtonPressed() {
    widget.deletePost(widget);
  }

  void likeButtonPressed() {
    setState(() {
      AccountHandler accountHandler = AccountHandler.getAccountHandler();
      UserAccount userAccount = accountHandler.activeAccount!;
      Storage storage = Storage.getStorage();

      if (widget.post.likedAccounts.contains(userAccount.mail)) {
        widget.post.likedAccounts.remove(userAccount.mail);
        storage.insertSquawk(widget.post);
      } else {
        widget.post.likedAccounts.add(userAccount.mail);
        storage.insertSquawk(widget.post);
      }
      widget.setLikeColor();
    });
  }
}
