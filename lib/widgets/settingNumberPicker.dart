import 'package:flutter/material.dart';
import 'dart:async';
import 'package:numberpicker/numberpicker.dart';

class SettingNumberPicker extends StatefulWidget {
  final StreamController<int> scSetting;
  final int defaulValue;
  final int minValue;
  final int maxValue;
  final String title;

  const SettingNumberPicker(
      {Key? key,
      required this.scSetting,
      required this.defaulValue,
      required this.minValue,
      required this.maxValue,
      required this.title})
      : super(key: key);

  @override
  _SettingNumberPickerState createState() => _SettingNumberPickerState();
}

class _SettingNumberPickerState extends State<SettingNumberPicker> {
  int _currentValue = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      this._currentValue = this.widget.defaulValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: new Icon(Icons.timelapse),
          title: new Text(this.widget.title),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        Container(
            child: Column(
          children: [
            NumberPicker(
              value: this._currentValue,
              minValue: 1,
              maxValue: 30,
              step: 1,
              axis: Axis.horizontal,
              onChanged: (value) {
                setState(() {
                  this._currentValue = value;
                });
                this.widget.scSetting.add(value);
              },
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black26),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () => setState(() {
                    final newValue = this._currentValue - 1;
                    this._currentValue = newValue.clamp(
                        this.widget.minValue, this.widget.maxValue);
                    this.widget.scSetting.add(_currentValue);
                  }),
                ),
                Text(' '),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.deepPurple),
                  onPressed: () => setState(() {
                    final newValue = this._currentValue + 1;
                    this._currentValue = newValue.clamp(
                        this.widget.minValue, this.widget.maxValue);
                    this.widget.scSetting.add(_currentValue);
                  }),
                ),
              ],
            ),
          ],
        ))
      ],
    );
  }
}
