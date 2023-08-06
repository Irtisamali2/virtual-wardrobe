import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_signin/provider/category_provider.dart';
import 'package:firebase_signin/provider/wardRobe_provider.dart';
import 'package:firebase_signin/screens/Home/home_screen.dart';
import 'package:firebase_signin/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/shared_pref_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('email') ?? '';
  runApp(MyApp(
    email: email,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.email, Key? key}) : super(key: key);
  final String email;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final _provider = Provider.of<SharedPrefProvider>(context, listen: false);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SelectCategory()),
        ChangeNotifierProvider(create: (context) => WardRobeProvider()),
        ChangeNotifierProvider(create: (context) => SharedPrefProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: email == '' ? const SignInScreen() : const HomeScreen(),
      ),
    );
  }
}
