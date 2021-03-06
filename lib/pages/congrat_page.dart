import 'package:builderworkoutplanner/models/events.dart';
import 'package:builderworkoutplanner/models/time_helper.dart';
import 'package:builderworkoutplanner/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class CongratPage extends StatefulWidget {
  const CongratPage({Key? key}) : super(key: key);

  @override
  _CongratPageState createState() => _CongratPageState();
}

class _CongratPageState extends State<CongratPage> {
  final LocalStorage localStorage = new LocalStorage('dates');

  Map<DateTime, List<Event>> selectedEvents = {};
  int? weeksCount;

  setUp() async {
    await localStorage.ready;
    if (localStorage.getItem('date') != null) {
      Map userMap = localStorage.getItem('date');

      List dates = userMap['workedout'];
      // print('these are dates $dates');

      setState(() {
        dates.forEach((element) {
          var now = DateTime.parse(element);
          var createTime = '${DateTime(now.year, now.month, now.day)}Z';
          selectedEvents[DateTime.parse(createTime)] = [Event(title: 'event')];
        });
      });
      weeksCount =
          TimeHelper.workoutsCounter(selectedEvents.keys.toList())['Week'];

      print(selectedEvents.keys.toList());
    }
  }

  @override
  void initState() {
    setUp();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * .15,
                ),
                Text(
                  'Workout Done!',
                  style: TextStyle(
                      fontSize: size.height * .03, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: size.height * .15,
                ),
                Stack(
                  children: [
                    Center(
                      child: Container(
                        width: size.height * .32,
                        height: size.height * .32,
                        child: Image(
                          image: AssetImage("assets/images/prize.png"),
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        weeksCount != null ? '\n$weeksCount' : '\n0',
                        style: TextStyle(
                            fontSize: size.height * .1,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * .07,
                ),
                Text(
                  weeksCount != null ? 'DAY $weeksCount' : 'Day 0',
                  style: TextStyle(
                      fontSize: size.height * .03, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * .02),
                Text(
                  weeksCount != null
                      ? "Congratulation!\nYou've worked out $weeksCount day(s) this week"
                      : "Congratulation!\nYou've worked out 0 days this week",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: size.height * .02, fontWeight: FontWeight.w200),
                ),
              ],
            ),
            Positioned(
                bottom: size.height * .03,
                left: size.width * .1,
                right: size.width * .1,
                top: size.height * .9,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(Colors.blue[100]!.value.toInt()))),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: size.height * .025,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => HomePage(
                                  currIndex: 2,
                                )));
                  },
                ))
          ],
        ),
      ),
    );
  }
}
