import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/bottomControl.dart';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:material_search/material_search.dart';

class MainChild extends StatefulWidget {
  final Function setDark;

  MainChild(this.setDark);

  _MainChildState createState() => _MainChildState();
}

class _MainChildState extends State<MainChild> {
  var numberOfapps;
  List<App> apps;
  var wallpaper;
  List<Widget> appsList = [];
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = new ScrollController();
    // Get wallpaper as binary data
    LauncherAssist.getWallpaper().then((imageData) {
      setState(() {
        wallpaper = imageData;
      });
    });
    // Get all apps
    LauncherAssist.getAllApps().then((apps) {
      setState(() {
        numberOfapps = apps.length;
        this.apps = apps;
        this.apps.sort(
            (a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
        initAppsList();
      });
    });
  }

  void initAppsList() {
    apps.forEach((a) {
      appsList.add(Padding(
        padding: const EdgeInsets.only(
            top: 20.0, bottom: 10.0, left: 5.0, right: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              child: Container(
                child: ListTile(
                  leading: Image.memory(
                    a.icon,
                    height: MediaQuery.of(context).size.height * 0.07,
                    fit: BoxFit.fitHeight,
                    alignment: AlignmentDirectional.topStart,
                  ),
                  onTap: () {
                    LauncherAssist.launchApp(a.package);
                  },
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                a.label,
                style: Theme.of(context).textTheme.title,
              ),
            ),
          ],
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: wallpaper != null
          ? BoxDecoration(
              image: DecorationImage(
                  image: MemoryImage(
                    wallpaper,
                  ),
                  fit: BoxFit.cover,
                  alignment: AlignmentDirectional.center))
          : BoxDecoration(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Scaffold(
          endDrawer: Drawer(
            child: ListView(
              reverse: true,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.lightbulb_outline),
                  onPressed: () {
                    widget.setDark();
                  },
                  tooltip: "Night Mode",
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  children: appsList,
                ),
                BottomControl(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
