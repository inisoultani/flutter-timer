import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timer/widgets/bjjLogo.dart';
import 'package:flutter_timer/widgets/bottoNavBar.dart';
import 'package:flutter_timer/widgets/floatingButton.dart';
import 'package:flutter_timer/widgets/restAndRoundSetting.dart';
import 'package:flutter_timer/widgets/rounds.dart';
import 'package:flutter_timer/widgets/timer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
  final StreamController<MaterialColor> scColor =
      StreamController<MaterialColor>();

  final timerWidgetGlobalKey = GlobalKey<TimerWidgetState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static const SAVED_IMAGE_PATH = 'saved_image_logo_path';
  static const SAVED_COLOR = 'saved_color';
  static const SAVED_ROUND_SETTING = 'saved_round_setting';

  Icon startButtonIcon = Icon(Icons.play_arrow);
  int startRoundState = 0;
  bool isRoundAlreadyStarted = false;
  String imagePath = 'assets/images/sjj-double-circle-15.png';
  int roundDuration = 3; // minutes
  int restRoundDuration = 2;
  int roundsTotal = 1;
  bool isSettingEnabled = false;
  int roundsCountDown = 0;
  MaterialColor currentColor = Colors.grey;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    getSavedImagePath();
    getSavedColor();
    getSavedRoundSetting();

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
      // setState(() {
      //   this.imagePath = newImagePath;
      // });
      saveImagePath(newImagePath);
    });

    scRoundDuration.stream.asBroadcastStream().listen((newRoundDuration) {
      // setState(() {
      //   this.roundDuration = newRoundDuration;
      // });
      saveRoundSetting(roundDuration: newRoundDuration);
    });

    scRoundRestDuration.stream
        .asBroadcastStream()
        .listen((newRestRoundDuration) {
      // setState(() {
      //   this.restRoundDuration = newRestRoundDuration;
      // });
      saveRoundSetting(restRoundDuration: newRestRoundDuration);
    });

    scRoundTotal.stream.asBroadcastStream().listen((newRoundsTotal) {
      // setState(() {
      //   this.roundsTotal = newRoundsTotal;
      // });
      saveRoundSetting(roundTotal: newRoundsTotal);
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
      print('newcolor  : $newColor');
      // setState(() {
      //   this.currentColor = newColor;
      // });
      saveSelectedColor(newColor);
    });
  }

  void getSavedImagePath() async {
    final SharedPreferences prefs = await this._prefs;
    final String? savedImagePath = prefs.getString(SAVED_IMAGE_PATH);

    if (savedImagePath != null) {
      setState(() {
        this.imagePath = savedImagePath;
      });
    }
  }

  void getSavedColor() async {
    final SharedPreferences prefs = await this._prefs;
    final String? savedColor = prefs.getString(SAVED_COLOR);
    print('savedColor : $savedColor');
    if (savedColor != null) {
      Map<String, dynamic> data = jsonDecode(savedColor);
      MaterialColor customMaterialColor = MaterialColor(0xFFFFFF,
          BottomNavbar.generateColorMap(data['r'], data['g'], data['b']));
      setState(() {
        this.currentColor = customMaterialColor;
      });
    }
  }

  void getSavedRoundSetting() async {
    final SharedPreferences prefs = await this._prefs;
    final String? savedRoundSetting = prefs.getString(SAVED_ROUND_SETTING);
    print('savedRoundSetting : $savedRoundSetting');
    if (savedRoundSetting != null) {
      Map<String, dynamic> data = jsonDecode(savedRoundSetting);
      setState(() {
        this.roundDuration = data['round_duration'];
        this.restRoundDuration = data['rest_round_duration'];
        this.roundsTotal = data['round_total'];
      });
      scRoundDuration.add(this.roundDuration);
      scRoundRestDuration.add(this.restRoundDuration);
      scRoundTotal.add(this.roundsTotal);
    }
  }

  void saveImagePath(String newImagePath) async {
    final SharedPreferences prefs = await this._prefs;
    prefs.setString(SAVED_IMAGE_PATH, newImagePath).then((value) {
      setState(() {
        this.imagePath = newImagePath;
      });
    });
  }

  void saveSelectedColor(MaterialColor color) async {
    final SharedPreferences prefs = await this._prefs;
    print('saving color : ${materialColorToJson(color)}');
    prefs.setString(SAVED_COLOR, materialColorToJson(color)).then((value) {
      setState(() {
        this.currentColor = color;
      });
    });
  }

  void saveRoundSetting(
      {int? roundDuration, int? restRoundDuration, int? roundTotal}) async {
    final SharedPreferences prefs = await this._prefs;
    String jsonSetting = roundSettingToJson(
        roundDuration: roundDuration,
        restRoundDuration: restRoundDuration,
        roundTotal: roundTotal);
    print('saving round Setting : $jsonSetting');
    prefs.setString(SAVED_ROUND_SETTING, jsonSetting).then((value) {
      setState(() {
        this.roundDuration =
            roundDuration != null ? roundDuration : this.roundDuration;
        this.restRoundDuration = restRoundDuration != null
            ? restRoundDuration
            : this.restRoundDuration;
        this.roundsTotal = roundTotal != null ? roundTotal : this.roundsTotal;
      });
    });
  }

  String materialColorToJson(MaterialColor color) {
    Map<String, dynamic> data = {
      'r': color.shade900.red,
      'g': color.shade900.green,
      'b': color.shade900.blue,
    };
    return jsonEncode(data);
  }

  String roundSettingToJson(
      {int? roundDuration, int? restRoundDuration, int? roundTotal}) {
    Map<String, dynamic> data = {
      'round_duration':
          roundDuration != null ? roundDuration : this.roundDuration,
      'rest_round_duration': restRoundDuration != null
          ? restRoundDuration
          : this.restRoundDuration,
      'round_total': roundTotal != null ? roundTotal : this.roundsTotal,
    };
    return jsonEncode(data);
  }

  void startRound({bool isNext = false}) {
    setState(() {
      if (isNext) {
        this.startRoundState = 1;
        this.scStartRound.add(2);
      } else {
        this.startRoundState = this.startRoundState == 1 ? 0 : 1;
        this.scStartRound.add(this.startRoundState);
      }

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
        decoration: BoxDecoration(color: this.currentColor.shade700),
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
                color: this.currentColor.shade900,
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
                          StreamBuilder(
                            stream: Stream.periodic(const Duration(seconds: 1)),
                            builder: (context, snapshot) {
                              return Text(
                                DateFormat('h:mm a').format(DateTime.now()),
                                style: TextStyle(
                                  fontSize: 45,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
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
                color: this.currentColor.shade900,
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
