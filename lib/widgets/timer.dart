import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<TimerWidget> {
  static const countdownDuration = Duration(minutes: 5);
  Timer? timer;
  Duration duration = Duration();

  bool isCountdown = true;

  @override
  void initState() {
    super.initState();

    startTimer();
    reset();
  }

  void addTimeBySeconds() {
    final int secondsInterval = 1;
    
    setState(() {
      final seconds = duration.inSeconds + (isCountdown ? (secondsInterval * -1) : secondsInterval);
      this.duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) => addTimeBySeconds());
  }

  void reset() {
    if (isCountdown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = Duration());
    }
  }

  Widget buildTimeCard({required String time, required String header}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          width: 150,
          height: 120,
          child: FittedBox(
            child: Text(
              '$time',
              style: TextStyle(fontSize: 100, color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.green, 
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
          ),
        ),
        Container(
          padding: EdgeInsets.all(15),
          width: 150,
          child: Text(
            header,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.white
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.green.shade300, 
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
          ),
          
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(this.duration.inMinutes.remainder(60));
    final seconds = twoDigits(this.duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildTimeCard(time: minutes, header: 'MINUTES'),
        buildTimeCard(time: seconds, header: 'SECONDS'),
      ],
    );
  }
}
