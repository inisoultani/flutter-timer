import 'dart:async';

import 'package:flutter/material.dart';

class RestAndRoundSetting extends StatefulWidget {
  final Stream<int> streamRestRoundDuration;
  final Stream<int> streamRoundTotal;
  final int defaultRestRoundDuration;
  final int defaultRoundTotal;
  final StreamController<bool> scEnableSetting;

  const RestAndRoundSetting(
      {Key? key,
      required this.streamRestRoundDuration,
      required this.streamRoundTotal,
      required this.defaultRestRoundDuration,
      required this.defaultRoundTotal,
      required this.scEnableSetting})
      : super(key: key);

  @override
  _RestAndRoundSettingState createState() => _RestAndRoundSettingState();
}

class _RestAndRoundSettingState extends State<RestAndRoundSetting> {
  bool isSettingEnabled = false;
  int restRoundDuration = 2;
  int roundTotal = 1;

  @override
  void initState() {
    super.initState();

    this.restRoundDuration = this.widget.defaultRestRoundDuration;
    this.roundTotal = this.widget.defaultRoundTotal;

    this.widget.streamRestRoundDuration.listen((newRestRoundDuration) {
      setState(() {
        this.restRoundDuration = newRestRoundDuration;
      });
    });

    this.widget.streamRoundTotal.listen((newRoundTotal) {
      setState(() {
        this.roundTotal = newRoundTotal;
      });
    });
  }

  void changeSettingStatus(bool? value) {
    if (value != null) {
      setState(() {
        this.isSettingEnabled = value;
      });
      this.widget.scEnableSetting.add(value);
    }
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.selected,
    };
    print(states.toString());
    if (states.any(interactiveStates.contains)) {
      return Colors.green;
    }
    return Colors.deepPurple.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
          clipBehavior: Clip.none,
          elevation: 1,
          color: Colors.deepPurple.shade700,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            trailing: Checkbox(
              onChanged: (value) => this.changeSettingStatus(value),
              value: this.isSettingEnabled,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              activeColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.av_timer,
                  color: Colors.white,
                  size: 30,
                ),
                Text(
                  '${this.restRoundDuration}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 40,
                ),
                Icon(
                  Icons.calendar_view_day_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                Text(
                  '${this.roundTotal}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
    );
  }
}
