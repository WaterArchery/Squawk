import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/avatar_handler.dart';
import 'package:squawk/handlers/theme_handler.dart';
import 'package:squawk/models/storage.dart';
import 'package:squawk/models/user_account.dart';
import 'package:squawk/widgets/home_app_bar.dart';
import 'package:squawk/widgets/home_navigation.dart';
import 'package:squawk/widgets/iconed_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() {
    return _SettingsPageSate();
  }
}

class _SettingsPageSate extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final UserAccount userAccount;

  @override
  void initState() {
    super.initState();
    userAccount = AccountHandler.getAccountHandler().activeAccount!;
    nameController.text = userAccount.name;
    nickNameController.text = userAccount.username;
    descController.text = userAccount.description;
    locationController.text = userAccount.location;
  }

  final nameController = TextEditingController();
  final nickNameController = TextEditingController();
  final descController = TextEditingController();
  final locationController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final outputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeHandler themeHandler = ThemeHandler.getInstance();
    AvatarHandler avatarHandler = AvatarHandler.getAvatarHandler();
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: HomeAppBar(openDrawer, onRefresh, onThemeChange,
            preferredSize: const Size(56, 56)),
        drawer: HomeNavigation(userAccount),
        drawerEnableOpenDragGesture: true,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(color: themeHandler.getHomeBackground()),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    decoration: BoxDecoration(
                      color: themeHandler.getNavbarBackground()
                    ),
                    child: Column(
                      children:
                      [
                        Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(15, 22, 0, 3),
                        child: Text(
                          "EDIT PROFILE",
                          style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
                        ),
                      ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      avatarHandler.getAvatarUrl(userAccount)),
                                  radius: 62,
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                ElevatedButton(
                                    onPressed: uploadPhotoPressed,
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(120, 25),
                                        backgroundColor: themeHandler.getRedOrWhite()),
                                    child: Text("Upload Photo", style:  GoogleFonts.roboto(color: themeHandler.getWhite()))
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "(${userAccount.mail})",
                                  style: GoogleFonts.lato(fontSize: 13, color: Colors.white),
                                ),
                              ],
                            ),
                            Container(
                              width: 225,
                              height: 100,
                              margin: const EdgeInsets.all(17),
                              child: TextField(
                                minLines: 1,
                                maxLines: 3,
                                controller: descController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelStyle: GoogleFonts.lato(color: Colors.white70),
                                  labelText: "Profile Description",
                                ),
                              ),
                            )
                          ],
                        ),],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  settingsPart(nameController, "Full Name", 50),
                  settingsPart(nickNameController, "User Name", 50),
                  settingsPart(locationController, "Location", 50),
                  settingsPart(passwordController, "New Password", 50),
                  settingsPart(confirmPassController, "Confirm Password", 50),
                  Text(
                    outputController.text,
                    style: GoogleFonts.lato(fontSize: 13, color: themeHandler.getBlack()),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  IconedButton(updateProfile, Icons.tips_and_updates_sharp,
                      "Update Profile", 200, 50, themeHandler.getRed()),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )));
  }

  void updateProfile() {
    String name = nameController.text;
    String userName = nickNameController.text;
    String desc = descController.text;
    String location = locationController.text;
    String pass = passwordController.text;
    String confirmPass = confirmPassController.text;
    AccountHandler accountHandler = AccountHandler.getAccountHandler();
    if (name != userAccount.name ||
        userName != userAccount.username ||
        desc != userAccount.description ||
        location != userAccount.location ||
        (pass != userAccount.password && pass != "")) {
      setState(() {
        if (pass != "") {
          if (pass == confirmPass) {
            userAccount.password = pass;
          } else {
            outputController.text = "Passwords don't match!";
            return;
          }
        }
        if (userName != userAccount.username &&
            accountHandler.getAccountWithName(userName) != null) {
          outputController.text = "This username is already exist!";
          return;
        } else {
          userAccount.username = userName;
        }
        userAccount.name = name;
        userAccount.description = desc;
        userAccount.location = location;
        Storage storage = Storage.getStorage();
        storage.insertAccount(userAccount);
        outputController.text = "Account updated!";
      });
    } else {
      setState(() {
        outputController.text = "There is nothing you changed!";
      });
    }
  }

  Widget settingsPart(TextEditingController controller, String text, double height) {
    final width = MediaQuery.of(context).size.width;
    ThemeHandler themeHandler = ThemeHandler.getInstance();
    return Container(
      width: (width / 100) * 90,
      height: height,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.lato(color: themeHandler.getBlack() , fontWeight: FontWeight.w400),
        obscureText: false,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              width: 2,
              color: themeHandler.getRed300(),
            ),
          ),
          labelText: text,
          labelStyle: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  void uploadPhotoPressed() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      final storageRef = FirebaseStorage.instance.ref();
      final account = AccountHandler.getAccountHandler().activeAccount!;
      UploadTask task = storageRef.child("photos/${account.mail}.jpg").putFile(file);
      final snapshot = await task.whenComplete(() => {});
      final String url = await snapshot.ref.getDownloadURL().whenComplete(() => {});
      AvatarHandler avatarHandler = AvatarHandler.getAvatarHandler();
      setState(() {
        avatarHandler.setAvatarUrl(account, url);
      });
    }
  }


  void onRefresh() {
    setState(() {
      //TODO REFRESH LOGIC
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
