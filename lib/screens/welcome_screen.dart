import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/components/rounded_button.dart';
import 'package:group_chat/constants.dart';
import 'package:group_chat/screens/login_screen.dart';
import 'package:group_chat/screens/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  late Animation animation2;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    animation = ColorTween(begin: Colors.blue[900], end: Colors.white)
        .animate(controller);
    animation2 = CurvedAnimation(parent: controller, curve: Curves.bounceIn);

    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: animation2.value * 100,
                    ),
                  ),
                  // ignore: deprecated_member_use
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Flash Chat',
                        cursor: "⚡",
                        textStyle: kAnimatedTitleStyle,
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
                onTap: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                text: "Log in",
                color: Colors.lightBlueAccent),
            RoundedButton(
                onTap: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                text: "Register",
                color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}
