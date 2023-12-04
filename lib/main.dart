import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:squawk/firebase_options.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/message_handler.dart';
import 'package:squawk/handlers/post_handler.dart';
import 'package:squawk/models/storage.dart';
import 'package:squawk/squawk.dart';


Future main() async {
  await Storage.getStorage().startStorage();
  await AccountHandler.getAccountHandler().loadAccounts().then(
        (value) => print(
            "${AccountHandler.getAccountHandler().accounts.length} total account loaded from database"),
      );
  PostHandler.getInstance().loadPosts();
  await MessageHandler.getInstance().loadMessages();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Squawk()));
}
