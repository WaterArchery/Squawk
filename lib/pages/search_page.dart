import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/theme_handler.dart';
import 'package:squawk/models/user_account.dart';
import 'package:squawk/widgets/home_app_bar.dart';
import 'package:squawk/widgets/home_navigation.dart';
import 'package:squawk/widgets/search_profile_result.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  final AccountHandler accountHandler = AccountHandler.getAccountHandler();
  late UserAccount? account = accountHandler.activeAccount;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ThemeHandler themeHandler = ThemeHandler.getInstance();
  final List<Widget> accountsList = [];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: HomeAppBar(openDrawer, onRefresh, onThemeChange,
            preferredSize: const Size(56, 56)),
        drawer: HomeNavigation(account!),
        drawerEnableOpenDragGesture: true,
        body: Container(
            height: double.infinity,
            decoration: BoxDecoration(color: themeHandler.getHomeBackground()),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 3,
                  ),
                  Container(
                    width: (width * 93) / 100,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: TextField(
                      autofocus: false,
                      onChanged: onChanged,
                      style: GoogleFonts.lato(color: Colors.white, fontSize: 20),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search, color: Colors.white,),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: 'Enter a username',
                          hintStyle: GoogleFonts.lato(fontSize: 18),
                        ),
                    ),
                  ),
                  ...accountsList
                ],
              ),
            )));
  }

  void onChanged(String text){
    accountsList.clear();
    setState(() {
      for (UserAccount account in accountHandler.accounts) {
        if (account.username.contains(text) && account.mail != this.account!.mail) {
          Widget widget = SearchProfileResult(account);
          accountsList.add(widget);
        }
      }
    });
  }

  void onRefresh() {
    setState(() {});
  }

  void openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void onThemeChange() {
    setState(() {
      themeHandler.changeTheme();
      onRefresh();
    });
  }
}
