import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/avatar_handler.dart';
import 'package:squawk/handlers/post_handler.dart';
import 'package:squawk/handlers/theme_handler.dart';
import 'package:squawk/models/squawk_post.dart';
import 'package:squawk/models/storage.dart';
import 'package:squawk/models/user_account.dart';
import 'package:squawk/squawk.dart';
import 'package:squawk/widgets/home_app_bar.dart';
import 'package:squawk/widgets/home_navigation.dart';
import 'package:squawk/widgets/iconed_button.dart';
import 'package:squawk/widgets/post_widget.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage(this.account, {super.key});
  final UserAccount account;

  @override
  State<UserProfilePage> createState() {
    return _UserProfilePageState();
  }
}

class _UserProfilePageState extends State<UserProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PostHandler postHandler = PostHandler.getInstance();
  static final List<PostWidget> pagePosts = [];

  @override
  void initState() {
    super.initState();
    loadPagePosts();
  }

  @override
  Widget build(BuildContext context) {
    AvatarHandler avatarHandler = AvatarHandler.getAvatarHandler();
    ThemeHandler themeHandler = ThemeHandler.getInstance();
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: HomeAppBar(openDrawer, onRefresh, onThemeChange,
          preferredSize: const Size(56, 56)),
      drawer: HomeNavigation(widget.account),
      drawerEnableOpenDragGesture: true,
      body: Container(
          height: double.infinity,
          decoration: BoxDecoration(color: themeHandler.getHomeBackground()),
          child: SingleChildScrollView(
              child: Column(children: [
                Container(
                    padding: const EdgeInsets.all(7),
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: themeHandler.getBlack()),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.fromLTRB(4, 22, 0, 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.account.name,
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "(${widget.account.username})",
                                style: GoogleFonts.roboto(
                                    color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 2,
                            ),
                            CircleAvatar(
                              backgroundImage:
                              NetworkImage(avatarHandler.getAvatarUrl(widget.account)),
                              radius: 62,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                widget.account.description,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.bottomLeft,
                              width: 150,
                              child: getFollowButton(),
                            ),
                            Row(
                              children: [
                                Icon(Icons.date_range, color: themeHandler.getRedOrWhite(),),
                                Text(getJoinDate(), style: GoogleFonts.lato(color: Colors.white, fontSize: 15),),
                                const SizedBox(width: 2,),
                                Visibility(visible: widget.account.location.isNotEmpty, child: Icon(Icons.location_on, color: themeHandler.getRedOrWhite(),),),
                                Text(widget.account.location, style: GoogleFonts.lato(color: Colors.white, fontSize: 15),),
                                IconButton(onPressed: onMessagePress, icon: Icon(Icons.local_post_office, color: themeHandler.getRedOrWhite(),))
                              ],
                            )
                          ],
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 15,
                ),
                ...pagePosts.reversed,
              ]))),
    );
  }

  String getJoinDate() {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(widget.account.joinDate * 1000);
    return "${date.day}/${date.month}/${date.year}";
  }

  void onMessagePress() {
    setState(() {
      SquawkState squawkState = SquawkState.getState();
      squawkState.updatePage("messages*${widget.account.username}");
    });
  }

  void onRefresh() {
    setState(() {
      loadPagePosts();
    });
  }

  void addPost(SquawkPost post) {
    setState(() {
      postHandler.allPosts.add(post);
    });
  }

  void onDeletePost(PostWidget postWidget) {
    setState(() {
      postHandler.allPosts.remove(postWidget.post);
      pagePosts.remove(postWidget);
    });
  }

  void openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void onThemeChange() {
    setState(() {
      ThemeHandler themeHandler = ThemeHandler.getInstance();
      themeHandler.changeTheme();
      onRefresh();
    });
  }

  Widget getFollowButton() {
    ThemeHandler themeHandler = ThemeHandler.getInstance();
    UserAccount activeAccount = AccountHandler.getAccountHandler().activeAccount!;
    if (widget.account.followers.contains(activeAccount)) {
      return IconedButton(unFollow, Icons.heart_broken,
          "Unfollow", 135, 45, themeHandler.getRed());
    }
    else {
      return IconedButton(follow, Icons.location_searching_sharp,
          "Follow", 135, 45, themeHandler.getRed());
    }
  }

  void follow() {
    UserAccount activeAccount = AccountHandler.getAccountHandler().activeAccount!;
    setState(() {
      widget.account.followers.add(activeAccount);
      Storage storage = Storage.getStorage();
      storage.insertAccount(widget.account);
    });
  }

  void unFollow() {
    UserAccount activeAccount = AccountHandler.getAccountHandler().activeAccount!;
    setState(() {
      widget.account.followers.remove(activeAccount);
      Storage storage = Storage.getStorage();
      storage.insertAccount(widget.account);
    });
  }

  void loadPagePosts() {
    setState(() {
      pagePosts.clear();
      for (SquawkPost post in postHandler.getOwnerPosts(widget.account)) {
        pagePosts.add(PostWidget(post, onDeletePost));
      }
    });
  }

}
