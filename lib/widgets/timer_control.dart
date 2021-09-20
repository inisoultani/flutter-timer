import 'package:flutter/material.dart';
import 'dart:async';

class TimerControl extends StatelessWidget {
  // final Function startTimer;
  final Function startRound;
  final Function resetRound;
  final bool isStartRound;

  const TimerControl(
      {Key? key, required this.startRound, required this.isStartRound, required this.resetRound})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('rebuild timer-controller');
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => this.startRound(),
              child: Icon(
                this.isStartRound ? Icons.pause : Icons.play_arrow,
                size: 50,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
            ),
            ElevatedButton(
              onPressed: () => this.resetRound(),
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
              onPressed: () {},
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
