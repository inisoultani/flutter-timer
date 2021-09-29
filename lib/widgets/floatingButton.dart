import 'package:flutter/material.dart';

class StartFloatingButton extends StatelessWidget {
  final Function startRound;
  final int startRoundState;
  const StartFloatingButton(
      {Key? key, required this.startRound, required this.startRoundState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('startRoundState :  $startRoundState');
    return SizedBox(
      width: 55,
      height: 55,
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        onPressed: this.startRoundState != 2 ? () => this.startRound() : null,
        child: Icon(this.startRoundState == 1 ? Icons.pause : Icons.play_arrow),
        backgroundColor: this.startRoundState == 2 ? Colors.grey : Colors.green,
      ),
    );
  }
}
