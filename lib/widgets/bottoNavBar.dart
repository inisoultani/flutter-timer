import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class BottomNavbar extends StatefulWidget {
  final Function resetRound;
  final Function nextRound;
  final int startRoundState;
  const BottomNavbar(
      {Key? key,
      required this.resetRound,
      required this.nextRound,
      required this.startRoundState})
      : super(key: key);

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _roundDuration = 5; // minutes

  Widget createNavbarButton(
      String toolTip, Widget icon, Function()? onPressed) {
    return Material(
        //borderRadius: BorderRadius.circular(25),
        shape: CircleBorder(),
        child: IconButton(
          onPressed: onPressed,
          color: Colors.deepPurple.shade800,
          tooltip: toolTip,
          iconSize: 30,
          splashRadius: 20,
          highlightColor: Colors.deepPurple.shade300,
          icon: icon,
        ));
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: new Icon(Icons.photo),
                title: new Text('Change Logo'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.timelapse),
                title: new Text('Round Duration'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Container(
                child: Column(
                  children: [
                      NumberPicker(
                      value: this._roundDuration,
                      minValue: 1,
                      maxValue: 30,
                      step : 1,
                      axis: Axis.horizontal,
                      onChanged: (value) {
                        setState(() {
                          this._roundDuration = value;
                        });
                      },
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black26),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => setState(() {
                            final newValue = _roundDuration - 1;
                            _roundDuration = newValue.clamp(0, 100);
                          }),
                        ),
                        Text('Current Round Duration : $_roundDuration'),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => setState(() {
                            final newValue = _roundDuration + 2;
                            _roundDuration = newValue.clamp(0, 100);
                          }),
                        ),
                      ],
                    ),
                  ],
                )
              ),
            ],
          );
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Optional
        mainAxisAlignment:
            MainAxisAlignment.spaceAround, // Change to your own spacing
        children: [
          SizedBox(
            width: 10,
          ),
          createNavbarButton(
              'Reset Timer',
              Icon(Icons.restore_outlined),
              this.widget.startRoundState == 1
                  ? () => this.widget.resetRound()
                  : null),
          createNavbarButton('Next Round', Icon(Icons.double_arrow),
              () => this.widget.nextRound()),
          createNavbarButton(
              'Settings', Icon(Icons.settings), () => openBottomSheet(context)),
        ],
      ),
    );
  }
}
