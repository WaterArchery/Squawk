import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squawk/handlers/account_handler.dart';
import 'package:squawk/handlers/theme_handler.dart';
import 'package:squawk/models/storage.dart';
import 'package:squawk/models/user_account.dart';
import 'package:squawk/squawk.dart';
import 'package:squawk/widgets/first_app_bar.dart';
import 'package:squawk/widgets/gradient_decoration.dart';
import 'package:squawk/widgets/iconed_button.dart';
import 'package:squawk/widgets/input_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final mailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  String outputText = "";
  @override
  Widget build(BuildContext context) {
    ThemeHandler themeHandler = ThemeHandler.getInstance();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final margin = height / 25;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: FirstAppBar(onThemeChange, preferredSize: const Size(56, 56),),
      body: Container(
        decoration: const GradientDecoration().getDecoration(),
        child: Column(
          children: [
            SizedBox(
              height: margin / 3,
              width: width,
            ),
            Image.network("https://chickennw.com/finallogo.png", width: 200),
            SizedBox(
              height: margin / 8,
              width: width,
            ),
            Text(outputText, style: GoogleFonts.lato(fontSize: 16),),
            SizedBox(
              height: margin / 4,
            ),
            InputField("Mail address*", mailController, false, (width * 85) / 100, 50),
            SizedBox(
              height: margin / 2,
            ),
            InputField("Username*", usernameController, false, (width * 85) / 100, 50),
            SizedBox(
              height: margin / 2,
            ),
            InputField("Password*", passwordController, true, (width * 85) / 100, 50),
            SizedBox(
              height: margin / 2,
            ),
            InputField("Name*", nameController, false, (width * 85) / 100, 50),
            SizedBox(
              height: margin / 2,
            ),
            InputField("Location", locationController, false, (width * 85) / 100, 50),
            SizedBox(height: margin / 3),
            IconedButton(
                onRegisterPress, Icons.app_registration_sharp, "Register Now", 200, 50, themeHandler.getBlue()),
            SizedBox(height: margin / 3),
            IconedButton(
                onBackPress, Icons.arrow_back, "Go Back", 200, 50, themeHandler.getBlue()),
          ],
        ),
      ),
    );
  }

  void onBackPress() {
    SquawkState state = SquawkState.getState();
    state.updatePage("first");
  }

  void onRegisterPress() {
    String mail = mailController.text;
    String pass = passwordController.text;
    String location = locationController.text;
    String name = nameController.text;
    String username = usernameController.text;
    if (mail.isEmpty || pass.isEmpty || username.isEmpty || name.isEmpty) {
      setState(() {
        outputText = "There are missing inputs!";
      });
      return;
    }
    else if (!mail.contains("@")) {
      setState(() {
        outputText = "Mail format is incorrect!";
      });
      return;
    }
    else if (pass.length < 6) {
      setState(() {
        outputText = "Password is too short!";
      });
      return;
    }
    else if (username.length < 3) {
      setState(() {
        outputText = "Username is too short!";
      });
      return;
    }
    AccountHandler accountHandler = AccountHandler.getAccountHandler();
    if (accountHandler.getAccountWithMail(mail) != null) {
      setState(() {
        outputText = "Account mail is already exist!";
      });
    }
    else if (accountHandler.getAccountWithName(username) != null) {
      setState(() {
        outputText = "Username is already exist!";
      });
    }
    else {
      UserAccount account = UserAccount(mail, username, name, pass, "", "", DateTime.now().millisecondsSinceEpoch, location, "");
      accountHandler.addAccount(account);
      Storage.getStorage().insertAccount(account);
      setState(() {
        outputText = "Account successfully created!";
      });
    }
  }

  void onThemeChange() {
    setState(() {
      ThemeHandler themeHandler = ThemeHandler.getInstance();
      themeHandler.changeTheme();
    });
  }

}
