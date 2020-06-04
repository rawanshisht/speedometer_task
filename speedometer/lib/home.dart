import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime minTime = DateTime.now();
  DateTime maxTime = DateTime.now();
  int ascSecond = 0;
  int descSecond = 0;

  double lastPositionSpeed = 0;
  double currentPositionSpeed = 0;
  DateTime ascSecondtemp;

  Duration difference1;
  Duration difference2;

  @override
  void initState() {
    minTime = DateTime.now();
    maxTime = DateTime.now();
    lastPositionSpeed = 0;
    currentPositionSpeed = 0;

    getSpeed();
    super.initState();
  }

  String initialVelocity = "10";
  String finalVelocity = "30";
  var geolocator = Geolocator();
  var options = LocationOptions(accuracy: LocationAccuracy.high);

  void getSpeed() async {
    geolocator.getPositionStream(options).listen((Position position) {
      var speed = double.parse((position.speed).toStringAsFixed(2));
      setState(() {
        currentPositionSpeed = position.speed == null ? 0 : speed;
      });
      var lastPosition = geolocator
          .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high)
          .then((value) {
        setState(() {
          lastPositionSpeed = value.speed;
        });
      });
      if (currentPositionSpeed > lastPositionSpeed) {
        //accreleration is increasing
        //check if speed = 10 kmh == 2.777 ms(min speed) calculate time tolerance (9 to 11)
        // if (currentPositionSpeed >= 0.1) {
        if (currentPositionSpeed >= 2.5 && currentPositionSpeed <= 3.05556) {
          setState(() {
            minTime = position.timestamp == null ? 0 : position.timestamp;
          });
        }
        // if(double.parse(currentVelocity) == 8.33){ //==30kmh
        if (currentPositionSpeed >= 0.5) {
          setState(() {
            maxTime = position.timestamp == null ? 0 : position.timestamp;
          });
        }
        setState(() {
          ascSecond = maxTime.difference(minTime).inSeconds.abs();
        });
      }
      if (currentPositionSpeed < lastPositionSpeed) {
        //accreleration is decreasing
        // if(double.parse(currentVelocity) == 8.33){ //==30kmh
        // if (currentPositionSpeed >= 0.5) {
        if (currentPositionSpeed >= 8.05556 &&
            currentPositionSpeed <= 8.61111) {
          //== 30
          setState(() {
            minTime = position.timestamp == null ? 0 : position.timestamp;
          });
        }
        //check if speed = 10 kmh == 2.777 ms(min speed) calculate time
        if (currentPositionSpeed >= 0.1) {
          //10
          setState(() {
            maxTime = position.timestamp == null ? 0 : position.timestamp;
          });
        }
        setState(() {
          descSecond = maxTime.difference(minTime).inSeconds.abs();
          print(descSecond);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(80.0),
                child: Column(
                  children: [
                    Text(
                      "Current Speed",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      "${currentPositionSpeed}",
                      style: TextStyle(
                        fontSize: 100,
                        fontFamily: "Digital",
                        color: Colors.green,
                      ),
                    ),
                    Text("kmh",
                        style: TextStyle(
                          fontSize: 30,
                        ))
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(80.0),
              child: Column(children: [
                Text("From ${initialVelocity} to ${finalVelocity}",
                    style: TextStyle(
                      fontSize: 30,
                    )),
                Text("${ascSecond}",
                    style: TextStyle(
                      fontSize: 70,
                      fontFamily: "Digital",
                      color: Colors.green,
                    )),
                Text("Seconds",
                    style: TextStyle(
                      fontSize: 30,
                    )),
              ]),
            ),
            Text("From ${finalVelocity} to ${initialVelocity}",
                style: TextStyle(
                  fontSize: 30,
                )),
            Text("${descSecond}",
                style: TextStyle(
                  fontSize: 70,
                  fontFamily: "Digital",
                  color: Colors.green,
                )),
            Text("Seconds",
                style: TextStyle(
                  fontSize: 30,
                )),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
