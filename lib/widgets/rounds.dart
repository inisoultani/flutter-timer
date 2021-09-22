import 'package:flutter/material.dart';

class Rounds extends StatefulWidget {
  final Stream<int> streamNextRound;
  const Rounds({Key? key, required this.streamNextRound}) : super(key: key);

  @override
  _RoundsState createState() => _RoundsState();
}

class _RoundsState extends State<Rounds> {
  int roundsCount = 0;

  @override
  void initState() {
    super.initState();

    this.widget.streamNextRound.listen((round) {
      setState(() {
        this.roundsCount += 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellow.shade800.withOpacity(0.6), Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
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
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              '${this.roundsCount}',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ]),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellow.shade800.withOpacity(0.6), Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            //borderRadius: BorderRadius.circular(5),
          ),
        ),
        SizedBox(height: 2),
        Container(
          width: 120,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellow.shade800.withOpacity(0.6), Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
          ),
          child: Icon(
            Icons.star,
            size: 15,
          ),
        )
      ],
    );
  }
}
