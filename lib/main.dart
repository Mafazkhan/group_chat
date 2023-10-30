import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/screens/chat_screen.dart';
import 'package:group_chat/screens/login_screen.dart';
import 'package:group_chat/screens/registration_screen.dart';
import 'package:group_chat/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

User? loggedInUser;
bool isWaiting = false;
final _auth = FirebaseAuth.instance;

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void getCurrentUser() {
    isWaiting = true;
    try {
      loggedInUser = _auth.currentUser!;
      
    } catch (e) {
      setState(() {
        isWaiting = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(),
            initialRoute:
                loggedInUser == null ? WelcomeScreen.id : ChatScreen.id,
            debugShowCheckedModeBanner: false,
            routes: {
              WelcomeScreen.id: (context) => WelcomeScreen(),
              LoginScreen.id: (context) => LoginScreen(),
              ChatScreen.id: (context) => ChatScreen(),
              RegistrationScreen.id: (context) => RegistrationScreen(),
            },
          );
  }
}
