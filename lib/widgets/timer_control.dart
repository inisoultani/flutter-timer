import 'package:flutter/material.dart';
import 'dart:async';

class TimerControl extends StatelessWidget {
  // final Function startTimer;
  final Function startRound;
  final Function resetRound;
  final Function nextRound;
  int isStartRound;
  final Stream<int> streamController;

  TimerControl(
      {Key? key,
      required this.startRound,
      required this.isStartRound,
      required this.resetRound,
      required this.nextRound,
      required this.streamController}) {
    // this.streamController.listen((event) {
    //   print('event : $event');
    //   switch (event) {
    //     case 1:
    //       this.isStartRound = false;
    //       break;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild timer-controller : ${this.isStartRound}');
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: this.isStartRound == 2 ? null : () => this.startRound(),
              child: Icon(
                this.isStartRound == 1 ? Icons.pause : Icons.play_arrow,
                size: 50,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
            ),
            ElevatedButton(
              onPressed: this.isStartRound == 1 ? () => this.resetRound() : null,
              child: Icon(
                Icons.autorenew_sharp,
                size: 50,
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.yellow.shade700),
              ),
            ),
            ElevatedButton(
              onPressed: () => this.nextRound(),
              child: Icon(
                Icons.double_arrow,
                size: 50,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
