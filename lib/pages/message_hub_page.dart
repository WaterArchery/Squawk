import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/avatar_handler.dart';
import 'package:squawk/handlers/message_handler.dart';
import 'package:squawk/handlers/theme_handler.dart';
import 'package:squawk/models/message.dart';
import 'package:squawk/models/user_account.dart';
import 'package:squawk/squawk.dart';
import 'package:squawk/widgets/home_app_bar.dart';
import 'package:squawk/widgets/home_navigation.dart';

class MessageHubPage extends StatefulWidget {
  const MessageHubPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MessageHubPageState();
  }
}

class _MessageHubPageState extends State<MessageHubPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ThemeHandler themeHandler = ThemeHandler.getInstance();
  final UserAccount account = AccountHandler.getAccountHandler().activeAccount!;
  final MessageHandler messageHandler = MessageHandler.getInstance();
  final List<Widget> widgetList = [];

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: HomeAppBar(openDrawer, onRefresh, onThemeChange,
            preferredSize: const Size(56, 56)),
        drawer: HomeNavigation(account),
        drawerEnableOpenDragGesture: true,
        body: Container(
            height: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            decoration: BoxDecoration(color: themeHandler.getHomeBackground()),
            child: SingleChildScrollView(
                child: Column(children: [
              Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Text(
                        "Messages",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 26),
                      ),
                      const SizedBox(height: 20,),
                      ...widgetList
                    ],
                  ))
            ]))));
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

  void loadMessages() {
    widgetList.clear();
    List<Message> messages = MessageHandler.getInstance().getAuthorMessages(account);
    List<String> receivers = [];
    for (Message message in messages.reversed) {
      if (!receivers.contains(message.receiver) && message.receiver != account.mail) {
        widgetList.add(getMessageWidget(message.receiver, message.message));
        receivers.add(message.receiver);
      }
    }
  }

  Widget getMessageWidget(String receiver, String message) {
    UserAccount user = AccountHandler.getAccountHandler().getAccountWithMail(receiver)!;
    return GestureDetector(
      onTap: () {
        onTapMessage(user.username);
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2.4), borderRadius: BorderRadius.circular(300)),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                  NetworkImage(AvatarHandler.getAvatarHandler().getAvatarUrl(user)),
                  radius: 26,
                ),
                const SizedBox(width: 8,),
                Text(user.name, style: GoogleFonts.lato(color: Colors.white),),
                const SizedBox(width: 4,),
                Text("(${user.username})", style: GoogleFonts.lato(color: Colors.white70),),
              ],
            ),
            Text(message.substring(0, min(12, message.length)), style: TextStyle(color: themeHandler.getBlack()),),
          ],
        ),
      ),
    );
  }

  void onTapMessage(String username) {
    SquawkState state = SquawkState.getState();
    state.updatePage("messages*$username");
  }

  void onRefresh() {
    setState(() {
      loadMessages();
    });
  }
}
