import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final timerWidgetGlobalKey = GlobalKey<TimerWidgetState>();
  Icon startButtonIcon = Icon(Icons.play_arrow);
  bool isStartRound = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  void startRound() {
    setState(() {
      this.isStartRound = !this.isStartRound;
    });
    print('homescreen startRound : ${this.isStartRound}');
    this.scStartRound.add(this.isStartRound ? 1 : 0);
  }

  void resetRound() {
    print('resetRound : ${this.isStartRound}');
    if(this.isStartRound) {
       this.scStartRound.add(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
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
                          ),
                        ),
                        Text(
                          DateFormat('h:mm a').format(DateTime.now()),
                          style: TextStyle(
                            fontSize: 45,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 120,
                          height: 20,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.yellow.shade800.withOpacity(0.6),
                                Colors.yellow
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.star,
                            size: 15,
                          ),
                        ),
                        SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.all(15),
                          width: 120,
                          child: Column(children: [
                            Text(
                              'ROUND',
                              style: Theme.of(context).textTheme.title,
                            ),
                            Text(
                              '5',
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ]),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.yellow.shade800.withOpacity(0.6),
                                Colors.yellow
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        SizedBox(height: 2),
                        Container(
                          width: 120,
                          height: 20,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.yellow.shade800.withOpacity(0.6),
                                Colors.yellow
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.star,
                            size: 15,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 5,
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
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            TimerControl(
                startRound: this.startRound, 
                resetRound: this.resetRound,
                isStartRound: this.isStartRound)
          ],
        ),
      ),
    );
  }
}
