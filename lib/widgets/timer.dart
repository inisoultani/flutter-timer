import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final Stream<int> streamStartRound;
  const TimerWidget({Key? key, required this.streamStartRound})
      : super(key: key);

  @override
  TimerWidgetState createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  static const countdownDuration = Duration(minutes: 5);
  Timer? timer;
  Duration duration = Duration();
  MaterialColor timeCardColor = Colors.green;

  int warnTimeInSeconds = 60;

  bool isCountdown = true;

  @override
  void initState() {
    super.initState();

    widget.streamStartRound.listen((startRound) {
      print('startRound : $startRound');
      if (startRound == 1) {
        this.startTimer();
      } else if (startRound == 0) {
        this.pauseTimer();
      } else if (startRound == 2) {
        this.reset();
      } 
    });
    reset();
  }

  void addTimeBySeconds() {
    final int secondsInterval = 1;

    setState(() {
      final seconds = duration.inSeconds +
          (isCountdown ? (secondsInterval * -1) : secondsInterval);
      this.duration = Duration(seconds: seconds);

      if (seconds == warnTimeInSeconds) {
        this.timeCardColor = Colors.orange;
      }

      if (seconds == 0 && isCountdown) {
        timer!.cancel();
        this.timeCardColor = Colors.red;
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) => addTimeBySeconds());
  }

  void pauseTimer() {
    setState(() {
      timer?.cancel();
    });
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
              color: this.timeCardColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        ),
        Container(
          padding: EdgeInsets.all(15),
          width: 150,
          child: Text(
            header,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
          ),
          decoration: BoxDecoration(
              color: this.timeCardColor.shade300,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
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
