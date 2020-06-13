import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';

class TimeTableWidget extends StatefulWidget {
  @override
  _TimeTableWidgetState createState() => _TimeTableWidgetState();
}

class _TimeTableWidgetState extends State<TimeTableWidget> {
  var _index = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Entypo.cancel_circled),
          title: Text('mon'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          title: Text('tue'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer),
          title: Text('wed'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.label),
          title: Text('thu'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer),
          title: Text('fri'),
        ),
      ],
      currentIndex: _index,
      onTap: (value) {
        setState(() {
          _index = value;
        });
      },
    );
  }
}
