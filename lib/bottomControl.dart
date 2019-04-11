import 'package:flutter/material.dart';
import 'package:battery/battery.dart';

class BottomControl extends StatefulWidget {
  @override
  _BottomControlState createState() => _BottomControlState();
}

class _BottomControlState extends State<BottomControl> {

  Battery battery = Battery();
  int bat;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  getBattery()async{
    bat = await battery.batteryLevel;
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              minRadius: 15.0,
              maxRadius: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(TimeOfDay.now().format(context),
                  style: Theme.of(context).textTheme.title),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(bat.toString()),
            )
          ],
        ),
      ),
    );
  }
}
