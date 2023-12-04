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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    loadPagePosts();
  }

  final List<PostWidget> pagePosts = [];
  TextEditingController controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PostHandler postHandler = PostHandler.getInstance();

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
            child: Column(
          children: [
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
                    TextField(
                      minLines: 1,
                      maxLines: 3,
                      controller: controller,
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
                    )
                  ],
                )),
            ...pagePosts.reversed
          ],
        )),
      ),
    );
  }

  void onSquawkPress() {
    setState(() {
      String postContent = controller.text;
      if (postContent.length >= 3 && postContent.length <= 140) {
        final activeAccount = AccountHandler.getAccountHandler().activeAccount;
        if (activeAccount != null) {
          SquawkPost post = SquawkPost(-1, postContent, activeAccount.mail);
          Storage storage = Storage.getStorage();
          storage.insertSquawk(post).then((value) => {
            postHandler.allPosts.add(post),
            loadPagePosts(),
            controller.text = "",
          });
        }
      } else {
        showAlertDialog(context);
      }
    });
  }

  void showAlertDialog(BuildContext context) {
    Widget okayButton = TextButton(
      child: const Text("Okay"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Squawk"),
      content: const Text(
          "Your squawk is too short or too long. It needs to be longer than 3 chars and shorter than 155 chars."),
      actions: [
        okayButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void onRefresh() {
    setState(() {
      loadPagePosts();
    });
  }

  void openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void loadPagePosts() {
    UserAccount account = AccountHandler.getAccountHandler().activeAccount!;
    setState(() {
      pagePosts.clear();
      for (SquawkPost post in postHandler.getUserPosts(account)) {
        PostWidget widget = PostWidget(post, onDeletePost);
        pagePosts.add(widget);
        widget.setLikeColor();
      }
    });
  }

  void onThemeChange() {
    setState(() {
      ThemeHandler themeHandler = ThemeHandler.getInstance();
      themeHandler.changeTheme();
      onRefresh();
    });
  }

  void onDeletePost(PostWidget postWidget) {
    setState(() {
      pagePosts.remove(postWidget);
      postHandler.deletePost(postWidget.post);
      Storage storage = Storage.getStorage();
      storage.deletePost(postWidget.post);
      //loadPagePosts();
    });
  }

}
