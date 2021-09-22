import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final timerWidgetGlobalKey = GlobalKey<TimerWidgetState>();
  Icon startButtonIcon = Icon(Icons.play_arrow);
  int startRoundState = 0;
  bool isRoundAlreadyStarted = false;

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
  }

  void startRound({bool isNext = false}) {
    setState(() {
      this.startRoundState = this.startRoundState == 1 ? 0 : 1;
      if (!this.isRoundAlreadyStarted) {
        this.isRoundAlreadyStarted = true;
        this.scNextRound.add(1);
      }
    });
    print('homescreen startRound : ${this.startRoundState}');
    if(isNext) {
      this.scStartRound.add(2);
    } else {
      this.scStartRound.add(this.startRoundState);
    }
  }

  void resetRound() {
    print('resetRound : ${this.startRoundState}');
    if (this.startRoundState == 1) {
      this.scStartRound.add(2);
    }
    // setState(() {
    //   this.startRoundState = 0;
    //   this.isRoundAlreadyStarted = false;
    // });
  }

  void nextRound() {
    this.resetRound();
    this.scNextRound.add(1);
    this.startRound(isNext: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade600
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Card(
                elevation: 1,
                color: Colors.deepPurple.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
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
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            DateFormat('h:mm a').format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 45,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
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
              SizedBox(height: 10),
              Card(
                elevation: 1,
                color: Colors.deepPurple.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Container(
                  width: double.infinity,
                  height: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        // child: Image.network(
                        //   this.imageUrl,
                        //   height: 250,
                        //   width: double.infinity,
                        //   fit: BoxFit.cover,
                        // ),
                        child: Container(
                          height: 140,
                          child: Image.asset(
                            'assets/images/sjj-brown-triangle-300.png',
                          ),
                        ),
                      ),
                      TimerWidget(
                        streamStartRound: this.scStartRound.stream,
                        scController: this.scController,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              TimerControl(
                  startRound: this.startRound,
                  resetRound: this.resetRound,
                  nextRound: this.nextRound,
                  streamController: this.scController.stream.asBroadcastStream(),
                  startRoundState: this.startRoundState)
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 45,
        height: 45,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9)
          ),
          onPressed: () {},
          child: Icon(Icons.settings_outlined),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
