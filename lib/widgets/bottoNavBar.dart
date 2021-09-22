import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final Function resetRound;
  final Function nextRound;
  final int startRoundState;
  const BottomNavbar({Key? key, required this.resetRound, required this.nextRound, required this.startRoundState}) : super(key: key);

  Widget createNavbarButton(String toolTip, Widget icon, Function()? onPressed) {
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
      )
    );
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
            this.startRoundState == 1 ? () => this.resetRound() : null
          ),
          createNavbarButton(
            'Next Round', 
            Icon(Icons.double_arrow), 
            () => this.nextRound()
          ),
          createNavbarButton(
            'Settings', 
            Icon(Icons.settings), 
            () => null
          ),
        ],
      ),
    );
  }
}
