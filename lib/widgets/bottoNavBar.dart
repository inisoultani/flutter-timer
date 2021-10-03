import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer/widgets/settingNumberPicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class BottomNavbar extends StatefulWidget {
  final Function resetRound;
  final Function nextRound;
  final int startRoundState;
  final StreamController<String> scBJJLogo;
  final StreamController<int> scRoundDuration;
  final StreamController<int> scRoundsTotal;
  final StreamController<int> scRestRoundDuration;
  final StreamController<MaterialColor> scColor;
  const BottomNavbar(
      {Key? key,
      required this.resetRound,
      required this.nextRound,
      required this.startRoundState,
      required this.scBJJLogo,
      required this.scRoundDuration,
      required this.scRestRoundDuration,
      required this.scColor,
      required this.scRoundsTotal})
      : super(key: key);

  static Map<int, Color> generateColorMap(int r, int g, int b) {
    return {
      50: Color.fromRGBO(r, g, b, .55),
      100: Color.fromRGBO(r, g, b, .60),
      200: Color.fromRGBO(r, g, b, .65),
      300: Color.fromRGBO(r, g, b, .70),
      400: Color.fromRGBO(r, g, b, .75),
      500: Color.fromRGBO(r, g, b, .80),
      600: Color.fromRGBO(r, g, b, .85),
      700: Color.fromRGBO(r, g, b, .90),
      800: Color.fromRGBO(r, g, b, .95),
      900: Color.fromRGBO(r, g, b, 1),
    };
  }

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int roundDuration = 5;
  int restRoundDuration = 2;
  int totalRounds = 1;
  MaterialColor currentColor = Colors.deepPurple;
  File? selectedFile;
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  @override
  void initState() {
    print('_BottomNavbarState init');
    super.initState();
    this
        .widget
        .scRoundDuration
        .stream
        .asBroadcastStream()
        .listen((newRoundDuration) {
      print(
          'current duration : $roundDuration with new duration  $newRoundDuration');
      setState(() {
        this.roundDuration = newRoundDuration;
      });
    });

    this
        .widget
        .scRestRoundDuration
        .stream
        .asBroadcastStream()
        .listen((newRestRoundDuration) {
      print(
          'current duration : $newRestRoundDuration with new duration  $newRestRoundDuration');
      setState(() {
        this.restRoundDuration = newRestRoundDuration;
      });
    });

    this
        .widget
        .scRoundsTotal
        .stream
        .asBroadcastStream()
        .listen((newTotalRounds) {
      print(
          'current duration : $newTotalRounds with new duration  $newTotalRounds');
      setState(() {
        this.totalRounds = newTotalRounds;
      });
    });
  }

  Widget createNavbarButton(
      String toolTip, Widget icon, Function()? onPressed) {
    return Material(
        //borderRadius: BorderRadius.circular(25),
        shape: CircleBorder(),
        color: Colors.grey.shade100,
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

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future selectLogoToUse() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png']);

      if (result != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
        });
        print('file path : ${selectedFile?.path}');
        print('file uri : ${selectedFile?.uri}');

        final directory = await getApplicationDocumentsDirectory();
        String newFileName = '${directory.path}/logo-${getRandomString(4)}.png';
        print('destination file : $newFileName');
        selectedFile!.copy(newFileName);
        this.widget.scBJJLogo.add(newFileName);
        /*
        I/flutter (21249): file path : /data/user/0/com.example.flutter_timer/cache/file_picker/images.jpeg
        I/flutter (21249): file uri : file:///data/user/0/com.example.flutter_timer/cache/file_picker/images.jpeg
        I/flutter (21249): destination file : /data/user/0/com.example.flutter_timer/app_flutter/logo111.png
        */
      } else {
        print('user canceled the file selection');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  

  void changeColor(Color color) {
    //color.
    print('test');
    MaterialColor customMaterialColor = MaterialColor(
        0xFFFFFF, BottomNavbar.generateColorMap(color.red, color.green, color.blue));
    setState(() => currentColor = customMaterialColor);
    this.widget.scColor.add(customMaterialColor);
    print('navbar costom color : $currentColor');
  }

  void showColorPickerDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select a color'),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: currentColor,
                onColorChanged: changeColor,
                availableColors: [
                  Colors.red,
                  Colors.green,
                  Colors.deepOrange,
                  Colors.deepPurple,
                  Colors.blue,
                  Colors.grey,
                  Colors.blueGrey,
                  Colors.brown
                ],
              ),
            ),
          );
        });
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        context: context,
        isScrollControlled: true,
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
                    //Navigator.pop(context);
                    selectLogoToUse();
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.color_lens),
                  title: new Text('Change Color'),
                  onTap: () {
                    //Navigator.pop(context);
                    showColorPickerDialog(context);
                  },
                ),
                SettingNumberPicker(
                    scSetting: this.widget.scRoundDuration,
                    defaulValue: this.roundDuration,
                    minValue: 1,
                    maxValue: 30,
                    icon: Icons.timelapse,
                    title: 'Round Duration'),
                SettingNumberPicker(
                    scSetting: this.widget.scRestRoundDuration,
                    defaulValue: this.restRoundDuration,
                    minValue: 1,
                    maxValue: 5,
                    icon: Icons.timelapse,
                    title: 'Rest Round Duration'),
                SettingNumberPicker(
                    scSetting: this.widget.scRoundsTotal,
                    defaulValue: this.totalRounds,
                    minValue: 1,
                    maxValue: 15,
                    icon: Icons.calendar_view_day_rounded,
                    title: 'Rounds'),
                
              ],
            );
          });
        });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     color: Colors.white,
  //     padding: EdgeInsets.all(15.0),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start, // Optional
  //       mainAxisAlignment:
  //           MainAxisAlignment.spaceAround, // Change to your own spacing
  //       children: [
  //         SizedBox(
  //           width: 10,
  //         ),
  //         createNavbarButton(
  //             'Reset Timer',
  //             Icon(Icons.restore_outlined),
  //             this.widget.startRoundState == 1
  //                 ? () => this.widget.resetRound()
  //                 : null),
  //         createNavbarButton('Next Round', Icon(Icons.double_arrow),
  //             () => this.widget.nextRound()),
  //         createNavbarButton(
  //             'Settings', Icon(Icons.settings), () => openBottomSheet(context)),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BottomAppBar(
      //bottom navigation bar on scaffold
      color: Colors.grey.shade100,
      shape: CircularNotchedRectangle(), //shape of notch
      notchMargin: 6, //notche margin between floating button and bottom appbar
      child: Row(
        //children inside bottom appbar
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
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
