import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timer/widgets/timer.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
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
                    Timer()
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {}, 
                      child: Icon(Icons.pause, size: 50,) 
                    ),
                    ElevatedButton(
                      onPressed: () {}, 
                      child: Icon(Icons.autorenew_sharp, size: 50,) 
                    ),
                     ElevatedButton(
                      onPressed: () {}, 
                      child: Icon(Icons.double_arrow, size: 50,) 
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
