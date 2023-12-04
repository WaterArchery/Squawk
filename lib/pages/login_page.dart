import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/theme_handler.dart';
import 'package:squawk/models/user_account.dart';
import 'package:squawk/squawk.dart';
import 'package:squawk/widgets/first_app_bar.dart';
import 'package:squawk/widgets/gradient_decoration.dart';
import 'package:squawk/widgets/iconed_button.dart';
import 'package:squawk/widgets/remember_me_box.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  String outputText = "";
  late RememberMeBox rememberMeBox;

  @override
  Widget build(BuildContext context) {
    ThemeHandler themeHandler = ThemeHandler.getInstance();
    final Color blackColor = themeHandler.getBlack();
    rememberMeBox = RememberMeBox();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final margin = height / 25;
    mailController.text = "arda@gmail.com";
    passwordController.text = "1234567";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: FirstAppBar(onThemeChange, preferredSize: const Size(56, 56),),
      body: Container(
        decoration: const GradientDecoration().getDecoration(),
        child: Column(
          children: [
            SizedBox(
              height: margin,
              width: width,
            ),
            Image.network("https://chickennw.com/finallogo.png", width: 200),
            SizedBox(
              height: (margin) / 4,
              width: width,
            ),
            Text(
              outputText,
              style: GoogleFonts.lato(fontSize: 16),
            ),
            SizedBox(
              height: (margin) / 2,
              width: width,
            ),
            SizedBox(
              width: (width * 85) / 100,
              child: TextField(
                controller: mailController,
                style: GoogleFonts.lato(color: Colors.white),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: blackColor,
                      ),
                    ),
                    labelText: 'Mail Address*',
                    labelStyle: GoogleFonts.lato(color: blackColor)),
              ),
            ),
            SizedBox(
              height: margin / 2,
              width: width,
            ),
            SizedBox(
              width: (width * 85) / 100,
              child: TextField(
                controller: passwordController,
                style: GoogleFonts.lato(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: blackColor,
                      ),
                    ),
                    labelText: 'Password*',
                    labelStyle: GoogleFonts.lato(color: blackColor)),
              ),
            ),
            SizedBox(height: margin / 3),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              rememberMeBox,
              Text(
                "Remember Me",
                style: GoogleFonts.lato(color: blackColor),
              ),
            ]),
            SizedBox(height: margin / 3),
            IconedButton(
                onLoginPress, Icons.login_outlined, "Login Now", 200, 50, themeHandler.getBlue()),
            SizedBox(height: margin / 3),
            IconedButton(onBackPress, Icons.arrow_back, "Go Back", 200, 50, themeHandler.getBlue()),
          ],
        ),
      ),
    );
  }

  void onBackPress() {
    SquawkState state = SquawkState.getState();
    state.updatePage("first");
  }

  void onLoginPress() {
    String mail = mailController.text;
    String pass = passwordController.text;

    AccountHandler handler = AccountHandler.getAccountHandler();
    UserAccount? account = handler.getAccountWithMail(mail);
    if (account != null && account.password == pass) {
      setState(() {
        outputText = "Logging...";
        SquawkState state = SquawkState.getState();
        if (rememberMeBox.isChecked) {
          saveRemember(account);
        }
        state.updatePage("home");
        handler.setActiveAccount(account);
      });
    } else {
      setState(() {
        outputText = "There is no account with the provided info.";
      });
    }
  }

  void saveRemember(UserAccount account) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mail', account.mail);
    await prefs.setString('pass', account.password);
  }

  void onThemeChange() {
    setState(() {
      ThemeHandler themeHandler = ThemeHandler.getInstance();
      themeHandler.changeTheme();
    });
  }

}
