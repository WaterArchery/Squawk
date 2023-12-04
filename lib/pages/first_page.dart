import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squawk/handlers/theme_handler.dart';
import 'package:squawk/squawk.dart';
import 'package:squawk/widgets/first_app_bar.dart';
import 'package:squawk/widgets/gradient_decoration.dart';
import 'package:squawk/widgets/iconed_button.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FirstPageState();
  }

}

class _FirstPageState extends State<FirstPage> {

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final margin = height / 25;
    ThemeHandler themeHandler = ThemeHandler.getInstance();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: FirstAppBar(onThemeChange, preferredSize: const Size(56, 56),),
        body: Container(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            decoration: const GradientDecoration().getDecoration(),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: margin * 2,
              ),
              Text("Squawk",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                  textAlign: TextAlign.left),
              SizedBox(
                height: margin,
              ),
              const Text(
                  "🌟🚀🌌 Introducing Squawk, the vibrant social media platform that captures the essence of Twitter! On Squawk, users can express their thoughts, engage in conversations, and share updates with a global audience. With its familiar and user-friendly interface, Squawk offers a seamless experience for connecting with friends, following favorite personalities, and discovering trending topics. ",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(
                height: margin,
              ),
              const Text(
                  "Whether you're passionate about technology, entertainment, politics, or any other interest, Squawk has got you covered! Embrace the power of concise and expressive messaging as you embark on a journey of meaningful interactions. Join Squawk today and experience the joy of being heard in 280 characters or less! 🐦💬🌌🌟",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(
                height: margin,
              ),
              Center(
                child: Column(
                  children: [
                    IconedButton(onLoginClick, Icons.person_3, "Login", 200, 50, themeHandler.getBlue()),
                    SizedBox(
                      height: margin / 4,
                    ),
                    IconedButton(
                        onRegisterClick, Icons.app_registration, "Sign Up", 200, 50, themeHandler.getBlue()),
                  ],
                ),
              )
            ])));
  }

  void onRegisterClick() {
    SquawkState state = SquawkState.getState();
    state.updatePage("register");
  }

  void onThemeChange() {
    setState(() {
      ThemeHandler themeHandler = ThemeHandler.getInstance();
      themeHandler.changeTheme();
    });
  }

  void onLoginClick() {
    SquawkState state = SquawkState.getState();
    state.updatePage("login");
  }

}
