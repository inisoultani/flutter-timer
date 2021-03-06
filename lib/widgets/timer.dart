import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TimerWidget extends StatefulWidget {
  final Stream<int> streamStartRound;
  final StreamController<int> scController;
  final Stream<int> streamRoundDuration;
  final StreamController<int> scRoundsCountdown;
  final Stream<bool> streamEnableSetting;
  final Stream<int> streamRestRoundDuration;
  const TimerWidget({
    Key? key,
    required this.streamStartRound,
    required this.scController,
    required this.streamRoundDuration,
    required this.scRoundsCountdown,
    required this.streamEnableSetting,
    required this.streamRestRoundDuration,
  }) : super(key: key);

  @override
  TimerWidgetState createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  Duration countdownDuration = Duration(seconds: 5);
  Timer? timer;
  Duration duration = Duration();
  MaterialColor timeCardColor = Colors.green;
  AudioPlayer audioPlayer = AudioPlayer();

  int warnTimeInSeconds = 60;
  bool isSettingEnabled = false;
  bool isCountdown = true;
  int restRoundDuration = 0;
  bool isRestTimerActive = false;

  @override
  void initState() {
    super.initState();

    widget.streamStartRound.listen((startRound) {
      print(
          'startRound : $startRound && this.duration.inSeconds : ${this.duration.inSeconds}');
      if (startRound == 1 && this.duration.inSeconds != 0) {
        this.startTimer();
      } else if (startRound == 0) {
        this.pauseTimer();
      } else if (startRound == 2) {
        this.reset();
        this.startTimer();
      }
    });

    widget.streamEnableSetting.listen((newSettingValue) {
      setState(() {
        this.isSettingEnabled = newSettingValue;
      });
    });

    widget.streamRoundDuration.listen((newRoundDuration) {
      print('newRoundDuration : $newRoundDuration');
      setState(() {
        this.countdownDuration = Duration(minutes: newRoundDuration);
      });
      reset();
    });

    widget.streamRestRoundDuration.listen((newRestRoundDuration) {
      setState(() {
        this.restRoundDuration = newRestRoundDuration;
      });
    });

    reset();
  }

  void addTimeBySeconds() {
    final int secondsInterval = 1;

    setState(() {
      // int seconds;
      // if (isSettingEnabled && isRestTimerActive) {
      //   seconds = Duration(minutes: 5).inSeconds;
      // }
      final seconds = this.duration.inSeconds +
          (isCountdown ? (secondsInterval * -1) : secondsInterval);
      this.duration = Duration(seconds: seconds);

      if (seconds < warnTimeInSeconds && this.timeCardColor != Colors.orange && this.timeCardColor != Colors.blue) {
        this.timeCardColor = Colors.orange;
        playBellLocal(2);
      }

      if (seconds == 0 && isCountdown) {
        timer!.cancel();
        timer = null;
        if (this.timeCardColor != Colors.blue) playBellLocal(3);
        this.timeCardColor = Colors.red;
        
        // for (int x = 0; x < 3; x++) {
        //   Future.delayed(Duration(milliseconds: (1150 * x)), () {
        //     playBellLocal(1);
        //   });
        // }
        this.widget.scController.add(1);
        if (isSettingEnabled) {
          if (isRestTimerActive) {
            setState(() {
              this.isRestTimerActive = false;
            });
            this.widget.scRoundsCountdown.add(1);
          } else {
            reset();
            startRestTimer();
          }
        }
      }
    });
  }

  void startTimer() {
    // if (timer == null) {
    playBellLocal(1);
    // }
    timer =
        new Timer.periodic(Duration(seconds: 1), (timer) => addTimeBySeconds());
  }

  void startRestTimer() {
    // if (timer == null) {
    //playBellLocal(1);
    // }
    timer?.cancel();
    timer = null;
    timer =
        new Timer.periodic(Duration(seconds: 1), (timer) => addTimeBySeconds());
    setState(() {
      duration = Duration(minutes: this.restRoundDuration);
      timeCardColor = Colors.blue;
      isRestTimerActive = true;
    });
  }

  void pauseTimer() {
    setState(() {
      timer?.cancel();
    });
  }

  void reset() {
    timer?.cancel();
    timer = null;
    if (isCountdown) {
      print('countdownDuration : ${countdownDuration.inMinutes}');
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = Duration());
    }
    setState(() => timeCardColor = Colors.green);
  }

  void playBellLocal(int code) async {
    String fileName = '';
    switch (code) {
      case 1:
        fileName = 'assets/audios/boxing_bell_1.m4a';
        break;
      case 2:
        fileName = 'assets/audios/boxing_bell_2.m4a';
        break;
      case 3:
        fileName = 'assets/audios/boxing_bell_3.m4a';
        break;
    }

    final byteData = await rootBundle.load(fileName);
    final buffer = byteData.buffer;
    int result = await audioPlayer.playBytes(buffer.asUint8List());
    print('result : $result');
    // AudioCache audioCache = AudioCache();
    // audioCache.play('audios/boxing-bell.mp3');
    // int result = await audioPlayer.play('../../assets/audios/boxing-bell.mp3',
    //     isLocal: true);
  }

  Widget buildTimeCard({required String time, required String header}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          width: 160,
          height: 120,
          child: FittedBox(
            child: Text(
              '$time',
              style: TextStyle(
                fontSize: 100, 
                color: Colors.white,
                fontFamily: 'TimeTrap',
                fontStyle: FontStyle.italic
              ),
            ),
          ),
          decoration: BoxDecoration(
              color: this.timeCardColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        ),
        Container(
          padding: EdgeInsets.all(15),
          width: 160,
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
