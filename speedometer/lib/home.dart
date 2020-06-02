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
  double minTime = 0.0;
  double maxTime = 0.0;
  double ascSecond = 0.0;
  double descSecond = 0.0;

  double lastPositionSpeed = 0;
  double currentPositionSpeed = 0;

  @override
  void initState() {
    minTime = 0.0;
    maxTime = 0.0;
    ascSecond = 0.0;
    descSecond = 0.0;
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
        //check if speed = 10 kmh == 2.777 ms(min speed) calculate time
        // if(double.parse(currentVelocity) == 2.777){
        if (currentPositionSpeed >= 0.1) {
          setState(() {
            minTime = position.timestamp.second == null
                ? 0
                : position.timestamp.second.toDouble();
          });
        }
        // if(double.parse(currentVelocity) == currentVelocity){ //==30
        if (currentPositionSpeed >= 0.5) {
          setState(() {
            maxTime = position.timestamp.second == null
                ? 0
                : position.timestamp.second.toDouble();
          });
        }
        setState(() {
          ascSecond = (maxTime - minTime).abs();
        });
      }
      if (currentPositionSpeed < lastPositionSpeed) {
        //accreleration is decreasing
        if (currentPositionSpeed >= 0.5) {
          //== 30
          setState(() {
            minTime = position.timestamp.second == null
                ? 0
                : position.timestamp.second.toDouble();
          });
        }
        // if(double.parse(currentVelocity) == currentVelocity){ //==30
        if (currentPositionSpeed >= 0.1) {
          //10
          setState(() {
            maxTime = position.timestamp.second == null
                ? 0
                : position.timestamp.second.toDouble();
          });
        }
        setState(() {
          descSecond = (maxTime - minTime).abs();
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
