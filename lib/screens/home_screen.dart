import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timer/widgets/bjjLogo.dart';
import 'package:flutter_timer/widgets/bottoNavBar.dart';
import 'package:flutter_timer/widgets/floatingButton.dart';
import 'package:flutter_timer/widgets/restAndRoundSetting.dart';
import 'package:flutter_timer/widgets/rounds.dart';
import 'package:flutter_timer/widgets/timer.dart';
import 'package:flutter_timer/widgets/timer_control.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StreamController<int> scStartRound = StreamController<int>();
  final StreamController<int> scNextRound = StreamController<int>();
  final StreamController<int> scController = StreamController<int>.broadcast();
  final StreamController<String> scBJJLogo = StreamController<String>();
  final StreamController<int> scRoundDuration =
      StreamController<int>.broadcast();
  final StreamController<int> scRoundRestDuration =
      StreamController<int>.broadcast();
  final StreamController<int> scRoundTotal = StreamController<int>.broadcast();
  final StreamController<bool> scEnableSetting =
      StreamController<bool>.broadcast();
  final StreamController<int> scRoundsCountdown =
      StreamController<int>.broadcast();
  final StreamController<MaterialColor> scColor = StreamController<MaterialColor>();

  final timerWidgetGlobalKey = GlobalKey<TimerWidgetState>();
  Icon startButtonIcon = Icon(Icons.play_arrow);
  int startRoundState = 0;
  bool isRoundAlreadyStarted = false;
  String imagePath = 'assets/images/sjj-double-circle-15.png';
  int roundDuration = 3; // minutes
  int restRoundDuration = 2;
  int roundsTotal = 1;
  bool isSettingEnabled = false;
  int roundsCountDown = 0;
  MaterialColor currentColor = Colors.deepPurple;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    scController.stream.asBroadcastStream().listen((event) {
      print('event : $event');
      switch (event) {
        case 1:
          setState(() {
            this.startRoundState = 2;
          });
          break;
      }
    });

    scBJJLogo.stream.asBroadcastStream().listen((newImagePath) {
      setState(() {
        this.imagePath = newImagePath;
      });
    });

    scRoundDuration.stream.asBroadcastStream().listen((newRoundDuration) {
      setState(() {
        this.roundDuration = newRoundDuration;
      });
    });

    scRoundRestDuration.stream
        .asBroadcastStream()
        .listen((newRestRoundDuration) {
      setState(() {
        this.restRoundDuration = newRestRoundDuration;
      });
    });

    scRoundTotal.stream.asBroadcastStream().listen((newRoundsTotal) {
      setState(() {
        this.roundsTotal = newRoundsTotal;
      });
    });

    scEnableSetting.stream.asBroadcastStream().listen((newSettingValue) {
      print('newSettingValue : $newSettingValue');
      setState(() {
        this.isSettingEnabled = newSettingValue;
      });
    });

    scRoundsCountdown.stream.asBroadcastStream().listen((countDown) {
      setState(() {
        this.roundsCountDown -= countDown;
      });
      print('102 countDown : $countDown');
      print('102 this.roundsCountDown : ${this.roundsCountDown}');
      if (this.roundsCountDown > 0) {
        nextRound();
      }
    });

    scColor.stream.listen((newColor) {
      setState(() {
        this.currentColor = newColor;
      });
    });
  }

  void startRound({bool isNext = false}) {
    setState(() {
      this.startRoundState = this.startRoundState == 1 ? 0 : 1;
      if (!this.isRoundAlreadyStarted) {
        if (isSettingEnabled && !(this.roundsCountDown > 0)) {
          setState(() {
            this.roundsCountDown = this.roundsTotal;
          });
          print('117 this.roundsCountDown : ${this.roundsCountDown}');
        }
        this.isRoundAlreadyStarted = true;
        this.scNextRound.add(1);
      }
    });
    print('homescreen startRound : ${this.startRoundState}');
    if (isNext) {
      this.scStartRound.add(2);
    } else {
      this.scStartRound.add(this.startRoundState);
    }
    // if (isSettingEnabled) {
    //   setState(() {
    //     this.roundsCountDown--;
    //   });
    // }
  }

  void resetRound() {
    print('resetRound : ${this.startRoundState}');
    if (this.startRoundState == 1) {
      this.scStartRound.add(2);
    }
    setState(() {
      // this.startRoundState = 0;
      //this.isRoundAlreadyStarted = false;
    });
  }

  void nextRound() {
    this.resetRound();
    //this.scNextRound.add(1);
    setState(() {
      // this.startRoundState = 0;
      this.isRoundAlreadyStarted = false;
    });
    this.startRound(isNext: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StartFloatingButton(
          startRound: this.startRound, startRoundState: this.startRoundState),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      bottomNavigationBar: BottomNavbar(
          resetRound: this.resetRound,
          nextRound: this.nextRound,
          scBJJLogo: this.scBJJLogo,
          scRestRoundDuration: this.scRoundRestDuration,
          scRoundsTotal: this.scRoundTotal,
          scRoundDuration: this.scRoundDuration,
          scColor: this.scColor,
          startRoundState: this.startRoundState),
      body: Container(
        decoration: BoxDecoration(color: this.currentColor.shade600),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Card(
                elevation: 1,
                color: Colors.deepPurple.shade700,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            DateFormat('EEE, d MMM').format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            DateFormat('h:mm a').format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 45,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          RestAndRoundSetting(
                            defaultRestRoundDuration: this.restRoundDuration,
                            defaultRoundTotal: this.roundsTotal,
                            streamRestRoundDuration: this
                                .scRoundRestDuration
                                .stream
                                .asBroadcastStream(),
                            streamRoundTotal:
                                this.scRoundTotal.stream.asBroadcastStream(),
                            scEnableSetting: this.scEnableSetting,
                          )
                        ],
                      ),
                      Rounds(
                        streamNextRound: this.scNextRound.stream,
                      )
                    ],
                  ),
                ),
              ),
              //SizedBox(height: 5),
              Card(
                margin: EdgeInsets.only(top: 50),
                clipBehavior: Clip.none,
                elevation: 1,
                color: Colors.deepPurple.shade700,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  width: double.infinity,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BJJLogo(imagePath: imagePath),
                      SizedBox(
                        height: 20,
                      ),
                      TimerWidget(
                        streamRoundDuration:
                            this.scRoundDuration.stream.asBroadcastStream(),
                        streamStartRound:
                            this.scStartRound.stream.asBroadcastStream(),
                        scController: this.scController,
                        scRoundsCountdown: this.scRoundsCountdown,
                        streamRestRoundDuration:
                            this.scRoundRestDuration.stream.asBroadcastStream(),
                        streamEnableSetting:
                            this.scEnableSetting.stream.asBroadcastStream(),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // RestAndRoundSetting(
              //   defaultRestRoundDuration: this.restRoundDuration,
              //   defaultRoundTotal: this.roundsTotal,
              //   streamRestRoundDuration:
              //       this.scRoundRestDuration.stream.asBroadcastStream(),
              //   streamRoundTotal: this.scRoundTotal.stream.asBroadcastStream(),
              //   scEnableSetting: this.scEnableSetting,
              // )
              // TimerControl(
              //     startRound: this.startRound,
              //     resetRound: this.resetRound,
              //     nextRound: this.nextRound,
              //     streamController:
              //         this.scController.stream.asBroadcastStream(),
              //     startRoundState: this.startRoundState
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
