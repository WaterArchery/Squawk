// ignore_for_file: avoid_print

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:squawk/firebase_options.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/models/message.dart';
import 'package:squawk/models/squawk_post.dart';
import 'package:squawk/models/user_account.dart';

class Storage {
  static Storage storage = Storage();
  static late FirebaseFirestore database;

  Storage();
  static Storage getStorage() {
    return storage;
  }



  Future<void> startStorage() async {
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseApp app = await Firebase.initializeApp(
      name: 'twitter',
      options: DefaultFirebaseOptions.currentPlatform,
    );
    database = FirebaseFirestore.instanceFor(app: app);
  }

  int _latestId = 0;

  Future<void> insertSquawk(SquawkPost post) async {
    var instance = database;
    if (post.id == -1) {
      _latestId++;
      post.id = _latestId;
    }
    else {
      _latestId = max(_latestId, post.id);
    }
    await instance.collection("posts").doc("${post.id}").set(post.toMap());
  }

  Future<void> deletePost(SquawkPost post) async {
    var instance = database;
    await instance.collection("posts").doc("${post.id}").delete();
  }

  Future<void> insertAccount(UserAccount account) async {
    var instance = database;
    AccountHandler accountHandler = AccountHandler.getAccountHandler();
    if (!accountHandler.accounts.contains(account)) {
      await instance.collection("accounts").doc(account.mail).set(account.toMap());
    }
    else {
      await instance.collection("accounts").doc(account.mail).set(account.toMap(), SetOptions(merge: true));
    }
  }

  int _latestMessage = 0;

  Future<void> insertMessage(Message message) async {
    if (message.id == -1) {
      _latestMessage++;
      message.id = _latestMessage;
    }
    else {
      _latestMessage = max(_latestMessage, message.id);
    }
    var instance = database;
    await instance.collection("messages").doc("${message.id}").set(message.toMap());
  }

  Future<void> deleteMessage(Message message) async {
    var instance = database;
    await instance.collection("messages").doc("${message.id}").delete();
  }

  Future<List<Map<String, dynamic>>?> getMessages() async {
    CollectionReference messages = database.collection('messages');
    List<Map<String, dynamic>> maps = [];
    await messages.get().then(
          (value) => {
        for (var docSnapshot in value.docs)
          {
            if (docSnapshot['id'] >= _latestMessage)
              {
                _latestMessage = docSnapshot['id'],
              },
            maps.add({
              'id': docSnapshot['id'],
              'author': docSnapshot['author'],
              'message': docSnapshot['message'],
              'receiver': docSnapshot['receiver'],
            }),
          },
      },
      onError: (e) => print("Error completing: $e"),
    );
    return maps;
  }


  Future<List<Map<String, dynamic>>?> getAccounts() async {
    CollectionReference users = database.collection('accounts');
    List<Map<String, dynamic>> maps = [];
    String followers;

    await users.get().then(
          (value) => {
          print(value.docs.length),
            for (var docSnapshot in value.docs)
              {
                followers = "",
                if (docSnapshot.data().toString().contains("followers")) {
                  followers = docSnapshot['followers'],
                },
                maps.add({
                  'mail': docSnapshot['mail'],
                  'username': docSnapshot['username'],
                  'name': docSnapshot['name'],
                  'password': docSnapshot['password'],
                  'photoUrl': docSnapshot['photoUrl'],
                  'bannerUrl': docSnapshot['bannerUrl'],
                  'joinDate': docSnapshot['joinDate'],
                  'location': docSnapshot['location'],
                  'description': docSnapshot['description'],
                  'followers': followers
                }),
              },
          },
          onError: (e) => print("Error completing: $e"),
        );
    return maps;
  }

  Future<List<SquawkPost>> getAllPosts() async {
    CollectionReference posts = database.collection('posts');
    List<SquawkPost> postList = [];
    SquawkPost post;
    await posts.get().then(
          (value) => {
            for (var docSnapshot in value.docs)
              {
                if (docSnapshot['id'] >= _latestId)
                  {
                    _latestId = docSnapshot['id'],
                  },
                post = SquawkPost(docSnapshot['id'],
                  docSnapshot['message'], docSnapshot['author']),
                post.parentPostID = docSnapshot['parentPostID'],
                for (String like in post.listToString(docSnapshot['likes'])) {
                  if (AccountHandler.getAccountHandler().getAccountWithMail(like) != null) {
                    post.addLike(AccountHandler.getAccountHandler().getAccountWithMail(like)!),
                  }
                },
                postList.add(post),
              },
          },
        );
    /* sorting list according to ids
     * because of sort view */

    postList.sort((a, b) => a.id.compareTo(b.id));
    return postList;
  }
}
