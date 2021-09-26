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
      print('next round : $round');
      setState(() {
        this.roundsCount += 1;
      });
    });
  }

  LinearGradient generateGradient() {
    return LinearGradient(
              colors: [Colors.black45.withOpacity(0.6), Colors.black],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            );
  }

  Widget starDecoration(BorderRadius borderRadius) {
    return Container(
      width: 120,
      height: 20,
      decoration: BoxDecoration(
        gradient: generateGradient(),
        borderRadius: borderRadius,
      ),
      child: Icon(Icons.star, size: 15, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        starDecoration(BorderRadius.only(
            topLeft: Radius.circular(5), topRight: Radius.circular(5))),
        SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.all(15),
          width: 120,
          child: Column(children: [
            Text(
              'ROUND',
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,fontFamily: 'ChunkFive'),
            ),
            SizedBox(height: 5),
            Text(
              '${this.roundsCount}',
              style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  height: 0.84,
                  //backgroundColor: Colors.red,
                  fontFamily: 'ChunkFive'),
            ),
          ]),
          decoration: BoxDecoration(
            gradient: generateGradient(),
            //borderRadius: BorderRadius.circular(5),
          ),
        ),
        SizedBox(height: 2),
        starDecoration(BorderRadius.only(
            bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)))
      ],
    );
  }
}
