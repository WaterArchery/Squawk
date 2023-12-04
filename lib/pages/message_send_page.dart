import 'package:flutter/material.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/message_handler.dart';
import 'package:squawk/handlers/theme_handler.dart';
import 'package:squawk/models/message.dart';
import 'package:squawk/models/storage.dart';
import 'package:squawk/models/user_account.dart';
import 'package:squawk/squawk.dart';
import 'package:squawk/widgets/home_app_bar.dart';
import 'package:squawk/widgets/home_navigation.dart';
import 'package:squawk/widgets/message_widget.dart';

class MessageSendPage extends StatefulWidget {
  const MessageSendPage(this.receiver, {super.key});

  final UserAccount receiver;

  @override
  State<StatefulWidget> createState() {
    return _MessageSendPageState();
  }
}

class _MessageSendPageState extends State<MessageSendPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ThemeHandler themeHandler = ThemeHandler.getInstance();
  final UserAccount account = AccountHandler.getAccountHandler().activeAccount!;
  final MessageHandler messageHandler = MessageHandler.getInstance();
  final newMessageController = TextEditingController();
  final List<MessageWidget> messages = [];

  @override
  void initState() {
    super.initState();
    loadPageMessages();
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
            alignment: Alignment.bottomCenter,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: themeHandler.getHomeBackground()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 565,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [...messages],
                    ),
                  ),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: themeHandler.getBlack()),
                      ),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          minLines: 1,
                          maxLines: 3,
                          controller: newMessageController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.white70),
                            labelText: "Send your message..",
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.local_post_office),
                              onPressed: onSendMessage,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: themeHandler.getRed()),
                              label: const Text("Send Message!"),
                            ),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ])
              ],
            )));
  }

  void onSendMessage() {
    String rawMessage = newMessageController.text;
    MessageHandler messageHandler = MessageHandler.getInstance();
    if (rawMessage.isNotEmpty) {
      final activeAccount = AccountHandler.getAccountHandler().activeAccount;
      if (activeAccount != null) {
        Message message =
            Message(activeAccount.mail, widget.receiver.mail, rawMessage, -1);
        Storage storage = Storage.getStorage();
        storage.insertMessage(message).then((value) => {
              messageHandler.messages.add(message),
              setState(() {
                newMessageController.text = "";
              }),
              loadPageMessages(),
            });
      }
    }
  }

  void loadPageMessages() {
    setState(() {
      messages.clear();
      for (Message message
          in messageHandler.getConversation(account, widget.receiver)) {
        UserAccount account = AccountHandler.getAccountHandler()
            .getAccountWithMail(message.author)!;
        MessageWidget messageWidget = MessageWidget(message.message, account);
        messages.add(messageWidget);
      }
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

  void onRefresh() {
    setState(() {
      loadPageMessages();
    });
  }
}
