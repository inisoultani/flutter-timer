import 'package:flutter/material.dart';

class Timer extends StatefulWidget {
  const Timer({ Key? key }) : super(key: key);

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Text(
        '00:42',
        style: TextStyle(
          fontSize: 100,
          //backgroundColor: Colors.green,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10)
      ),
    );
  }
}