import 'dart:io';

import 'package:builderworkoutplanner/data.dart';
import 'package:builderworkoutplanner/pages/app_plans_page.dart';
import 'package:builderworkoutplanner/pages/calendar_page.dart';
import 'package:builderworkoutplanner/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import '../data.dart';
import 'main_page_widget.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  final int? currIndex;
  const HomePage({Key? key, this.currIndex}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndext = 0;
  List<Widget> bars = [
    MainPageWidget(),
    AppPlans(),
    CalendarPage(),
    SettingsPage()
  ];
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    initializeDatabase();
    setState(() {
      if (widget.currIndex != null) {
        currentIndext = widget.currIndex!;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(thirdColor),
          unselectedItemColor: Colors.grey[500],
          type: BottomNavigationBarType.shifting,
          showSelectedLabels: false,
          currentIndex: currentIndext,
          onTap: (value) {
            setState(() {
              currentIndext = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_run_rounded),
              label: "Plans",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "Calendar",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
        body: bars[currentIndext]);
  }

  Future initializeDatabase() async {
    var databasesPath = await getDatabasesPath();

    var path = join(databasesPath, "x.db");
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "db/x.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }
  }
}
