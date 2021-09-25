import 'package:flutter/material.dart';

class RestAndRoundSetting extends StatefulWidget {
  const RestAndRoundSetting({Key? key}) : super(key: key);

  @override
  _RestAndRoundSettingState createState() => _RestAndRoundSettingState();
}

class _RestAndRoundSettingState extends State<RestAndRoundSetting> {
  bool isSettingEnabled = false;

  void changeSettingStatus(bool? value) {
    if (value != null) {
      setState(() {
        this.isSettingEnabled = value;
      });
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
                  '2',
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
                  '2',
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
