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
  double currentPositionSpeed = 0;

  int inc = 0;
  int dec = 0;
  int minTime = 0;
  int maxTime = 0;

  int _counterInc = 0;
  int _counterDec = 0;
  Timer _timerInc;
  Timer _timerDec;

  @override
  void initState() {
    minTime = 0;
    maxTime = 0;

    _counterInc = 0;
    _counterDec = 0;

    _timerInc = null;
    _timerDec = null;
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
      // if (currentPositionSpeed >= 0.1 && inc == 0) {
      if (currentPositionSpeed >= 2.5 &&
          currentPositionSpeed <= 3.05556 &&
          inc == 0 &&
          dec == 0) {
        //arround 10
        inc = 1;
        dec = 0;
        if (_timerInc != null) {
          _timerInc.cancel();
        }
        _timerInc = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            if (_counterInc >= 0) {
              _counterInc++;
            } else {
              _timerInc.cancel();
            }

            minTime = _counterInc;
          });
          print("INC: ${_counterInc}");
        });
      }
      // if ((currentPositionSpeed < 0.1 || currentPositionSpeed > 0.2) &&
      //     inc == 1) {
      if ((currentPositionSpeed < 2.77778 || currentPositionSpeed > 8.33333) &&
          inc == 1) {
        // mn 0 le 10 or > 30
        inc = 0;
        dec = 0;

        if (_timerInc != null) {
          _timerInc.cancel();
        }
        _counterInc = 0;
        setState(() {
          minTime = 0;
        });
      }
      // if (currentPositionSpeed >= 0.2 && dec == 0) {
      if (currentPositionSpeed >= 8.05556 &&
          currentPositionSpeed <= 8.61111 &&
          dec == 0 &&
          inc == 0) {
        //around 30
        dec = 1;
        inc = 0;
        if (_timerDec != null) {
          _timerDec.cancel();
        }
        _timerDec = Timer.periodic(Duration(seconds: 1), (timer) async {
          setState(() {
            if (_counterDec >= 0) {
              _counterDec++;
            } else {
              _timerDec.cancel();
            }
            maxTime = _counterDec;
          });
          print("DEC: ${_counterDec}");
        });
      }
      // if ((currentPositionSpeed <= 0.1) && dec == 1) {
      if ((currentPositionSpeed < 2.77778 || currentPositionSpeed > 8.33333) &&
          dec == 1) {
        dec = 0;
        inc = 0;
        if (_timerDec != null) {
          _timerDec.cancel();
        }
        _counterDec = 0;
        setState(() {
          maxTime = 0;
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
                Text("${minTime}",
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
            Text("${maxTime}",
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
