import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher/mainChild.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([
    SystemUiOverlay.top
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));
  runApp(MainParent());
}

class MainParent extends StatefulWidget {
  _MainParentState createState() => _MainParentState();
}

class _MainParentState extends State<MainParent> {
  bool isDark = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    getNightMode().then((int i) {
      i == 0
          ? setState(() {
              isDark = true;
            })
          : setState(() {
              isDark = false;
            });
    });
  }

  Future<Null> saveNightMode(int i) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("NightMode", i);
  }

  Future<int> getNightMode() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt("NightMode");
  }

  void setDark() {
    setState(() {
      isDark = !isDark;
      !isDark
          ? saveNightMode(1)
          : saveNightMode(0); //1 means light 0 means dark
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainChild(setDark),
      theme: ThemeData(
        textTheme: TextTheme(
          title: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 16.0,
              letterSpacing: 2.0),
        ),
        canvasColor: (isDark) ? null : Colors.white,
        dialogBackgroundColor: (isDark) ? null : Colors.white,
        backgroundColor: (!isDark) ? Colors.white : Colors.black,
        brightness: (isDark) ? Brightness.dark : Brightness.light,
      ),
    );
  }
}
