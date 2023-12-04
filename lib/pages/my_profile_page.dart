import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/avatar_handler.dart';
import 'package:squawk/handlers/post_handler.dart';
import 'package:squawk/handlers/theme_handler.dart';
import 'package:squawk/models/squawk_post.dart';
import 'package:squawk/models/user_account.dart';
import 'package:squawk/squawk.dart';
import 'package:squawk/widgets/home_app_bar.dart';
import 'package:squawk/widgets/home_navigation.dart';
import 'package:squawk/widgets/iconed_button.dart';
import 'package:squawk/widgets/post_widget.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() {
    return _MyProfilePageState();
  }
}

class _MyProfilePageState extends State<MyProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late UserAccount account;
  final PostHandler postHandler = PostHandler.getInstance();
  static final List<PostWidget> pagePosts = [];
  bool isYourSquawks = true;

  @override
  void initState() {
    super.initState();
    account = AccountHandler.getAccountHandler().activeAccount!;
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
      drawer: HomeNavigation(account),
      drawerEnableOpenDragGesture: true,
      body: Container(
          height: double.infinity,
          decoration: BoxDecoration(color: themeHandler.getHomeBackground()),
          child: SingleChildScrollView(
              child: Column(children: [
            Container(
                padding: const EdgeInsets.all(10),
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
                      margin: const EdgeInsets.fromLTRB(8, 22, 0, 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            account.name,
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 26),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "(${account.username})",
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
                          width: 8,
                        ),
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(avatarHandler.getAvatarUrl(account)),
                          radius: 62,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            account.description,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconedButton(onUpdateProfile, Icons.settings,
                            "Change Profile", 155, 45, themeHandler.getRed()),
                        Row(
                          children: [
                            Icon(
                              Icons.date_range,
                              color: themeHandler.getRedOrWhite(),
                            ),
                            Text(
                              getJoinDate(),
                              style: GoogleFonts.lato(
                                  color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Visibility(
                              visible: account.location.isNotEmpty,
                              child: Icon(
                                Icons.location_on,
                                color: themeHandler.getRedOrWhite(),
                              ),
                            ),
                            Text(
                              account.location,
                              style: GoogleFonts.lato(
                                  color: Colors.white, fontSize: 16),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                )),
            Container(
              //padding: const EdgeInsets.fromLTRB(0, 7, 0, 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: themeHandler.getBlack()),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: squawksButtonPressed,
                    child: Text("Your Squawks", style: TextStyle(color: getTextButtonColor(true), fontSize: 24, fontWeight: FontWeight.bold),),
                  ),
                  TextButton(
                    onPressed: likesButtonPressed,
                    child: Text("Liked Squawks", style: TextStyle(color: getTextButtonColor(false), fontSize: 24, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ...pagePosts.reversed
          ]))),
    );
  }


  void squawksButtonPressed() {
    setState(() {
      isYourSquawks = true;
    });
    loadPagePosts();
  }

  void likesButtonPressed() {
    setState(() {
      isYourSquawks = false;
    });
    loadPagePosts();
  }

  Color getTextButtonColor(bool boolean) {
    if ((isYourSquawks && boolean) || (!isYourSquawks && !boolean)) {
      return Colors.white;
    } else {
      return Colors.white54;
    }
  }

  String getJoinDate() {
    DateTime date =
        DateTime.fromMicrosecondsSinceEpoch(account.joinDate * 1000);
    return "${date.day}/${date.month}/${date.year}";
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

  void loadPagePosts() {
    UserAccount account = AccountHandler.getAccountHandler().activeAccount!;
    setState(() {
      pagePosts.clear();
      if (isYourSquawks) {
        for (SquawkPost post in postHandler.getOwnerPosts(account)) {
          PostWidget postWidget = PostWidget(post, onDeletePost);
          postWidget.setLikeColor();
          pagePosts.add(postWidget);
        }
      }
      else {
        for (SquawkPost post in postHandler.getLikedPosts(account)) {
          PostWidget postWidget = PostWidget(post, onDeletePost);
          postWidget.setLikeColor();
          pagePosts.add(postWidget);
        }
      }
    });
  }

  void onDeletePost(PostWidget postWidget) {
    setState(() {
      postHandler.allPosts.remove(postWidget.post);
      //loadPagePosts();
      pagePosts.remove(postWidget);
    });
  }

  void onUpdateProfile() {
    SquawkState squawkState = SquawkState.getState();
    if (squawkState.activePage != "settings") {
      squawkState.updatePage("settings");
    }
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
}
