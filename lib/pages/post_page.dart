import 'package:flutter/material.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/post_handler.dart';
import 'package:squawk/handlers/theme_handler.dart';
import 'package:squawk/models/squawk_post.dart';
import 'package:squawk/models/storage.dart';
import 'package:squawk/models/user_account.dart';
import 'package:squawk/widgets/home_app_bar.dart';
import 'package:squawk/widgets/home_navigation.dart';
import 'package:squawk/widgets/post_widget.dart';

class PostPage extends StatefulWidget {
  const PostPage(this.postWidget, {super.key});

  final PostWidget postWidget;

  @override
  State<StatefulWidget> createState() {
    return _PostPageState();
  }
}

class _PostPageState extends State<PostPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final newCommentController = TextEditingController();
  final List<PostWidget> pagePosts = [];

  @override
  void initState() {
    super.initState();
    loadPagePosts();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final margin = height / 25;
    UserAccount account = AccountHandler.getAccountHandler().activeAccount!;
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
              widget.postWidget,
                Column(
                  children: [
                    TextField(
                      minLines: 1,
                      maxLines: 3,
                      controller: newCommentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white70),
                        labelText: "Share your awesome thoughts...",
                      ),
                    ),
                    SizedBox(
                      height: margin / 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.post_add),
                          onPressed: onSquawkPress,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: themeHandler.getRed()), label: const Text("Squawk!"),),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: themeHandler.getBlack()),
                        ),
                      ),
                    ),
                  ],
                ),
                  ...pagePosts.reversed
            ]))));
  }

  final PostHandler postHandler = PostHandler.getInstance();
  void onSquawkPress() {
    setState(() {
      String postContent = newCommentController.text;
      if (postContent.length > 3 && postContent.length < 155) {
        final activeAccount = AccountHandler.getAccountHandler().activeAccount;
        if (activeAccount != null) {
          SquawkPost post = SquawkPost(-1, postContent, activeAccount.mail);
          Storage storage = Storage.getStorage();
          post.parentPostID = widget.postWidget.post.id;
          storage.insertSquawk(post).then((value) => {
            postHandler.allPosts.add(post),
            loadPagePosts(),
            newCommentController.text = "",
          });
        }
      }
    });
  }

  void loadPagePosts() {
    setState(() {
      pagePosts.clear();
      for (SquawkPost post in postHandler.getChildPosts(widget.postWidget.post.id)) {
        PostWidget widget = PostWidget(post, onDeletePost);
        pagePosts.add(widget);
        widget.setLikeColor();
      }
    });
  }

  void onDeletePost(PostWidget postWidget) {
    setState(() {
      pagePosts.remove(postWidget);
      postHandler.allPosts.remove(postWidget.post);
      //loadPagePosts();
    });
  }

  void onRefresh() {
    setState(() {
      loadPagePosts();
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
}
