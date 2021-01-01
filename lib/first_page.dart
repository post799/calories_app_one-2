import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main.dart';
import 'main_page.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  double activityScore = 0;
  int totalScore = 0;
  String result = '';
  double age = 0;
  double weight = 0;
  double height = 0;
  int initGender = 2;
  int initSystem = 2;
  int initActivity = 5;

  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  String getAge = '';
  String getWeight = '';
  String getHeight = '';
  String lbs = 'Lbs';
  String inches = 'Inches';

  @override
  void initState() {
    super.initState();
    restore();
  }

  restore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      result = (prefs.getString('myResult') ?? '');
      initGender = (prefs.getInt('genderLabel') ?? 2);
      initSystem = (prefs.getInt('systemLabel') ?? 2);
      initActivity = (prefs.getInt('activityLabel') ?? 5);
      activityScore = (prefs.getDouble('activityScore') ?? 0);
      getAge = (prefs.getString('ageNumber') ?? '');
      getWeight = (prefs.getString('weightNumber') ?? '');
      getHeight = (prefs.getString('heightNumber') ?? '');
      ageController.text = getAge;
      weightController.text = getWeight;
      heightController.text = getHeight;
    });
  }

  reset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      getHeight = '';
      getWeight = '';
      getAge = '';
      initSystem = 2;
      initGender = 2;
      initActivity = 5;
      ageController.clear();
      weightController.clear();
      heightController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                'Your Gender',
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToggleSwitch(
                    minWidth: 130.0,
                    minHeight: 40.0,
                    initialLabelIndex: initGender,
                    cornerRadius: 20.0,
                    icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    labels: ['Male', 'Female'],
                    fontSize: 20,
                    iconSize: 30.0,
                    activeBgColors: [
                      Colors.blue,
                      Colors.pink[400],
                      Colors.purple
                    ],
                    onToggle: (index) {
                      if (index == 0) {
                        initGender = 0;
                      } else {
                        initGender = 1;
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Measuring System',
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
              SizedBox(
                height: 4,
              ),
              ToggleSwitch(
                minWidth: 130.0,
                minHeight: 40.0,
                initialLabelIndex: initSystem,
                cornerRadius: 20.0,
                activeFgColor: Colors.white,
                fontSize: 20,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                labels: ['Imperial', 'Metric'],
                iconSize: 30.0,
                activeBgColors: [
                  Colors.brown[900],
                  Colors.black,
                  Colors.purple
                ],
                onToggle: (index) {
                  setState(() {
                    if (index == 0) {
                      initSystem = 0;
                      lbs = 'Lbs';
                      inches = 'Inches';
                    } else {
                      initSystem = 1;
                      lbs = 'KG';
                      inches = 'CM';
                    }
                  });
                },
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Your Age',
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 80,
                    child: TextField(
                      controller: ageController,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: 35,
                    width: 80,
                    child: Text(
                      'Years',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Your Weight',
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 80,
                    child: TextField(
                      controller: weightController,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: 35,
                    width: 90,
                    child: Text(
                      '$lbs',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Your Height',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 80,
                    child: TextField(
                      controller: heightController,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: 35,
                    width: 80,
                    child: Text(
                      '$inches',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Lifestyle',
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToggleSwitch(
                    minWidth: 160.0,
                    minHeight: 45.0,
                    initialLabelIndex: initActivity,
                    cornerRadius: 10.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    labels: [
                      '   Not\n Active',
                      ' Slightly\n Active',
                      'Moderately\n   Active',
                      'Active',
                      '  Very\n Active'
                    ],
                    fontSize: 9,
                    activeBgColors: [
                      Colors.indigo[900],
                      Colors.indigo[900],
                      Colors.indigo[900],
                      Colors.indigo[900],
                      Colors.indigo[900],
                    ],
                    onToggle: (index) {
                      if (index == 0) {
                        activityScore = 1.2;
                        initActivity = 0;
                      } else if (index == 1) {
                        activityScore = 1.375;
                        initActivity = 1;
                      } else if (index == 2) {
                        activityScore = 1.55;
                        initActivity = 2;
                      } else if (index == 3) {
                        activityScore = 1.725;
                        initActivity = 3;
                      } else if (index == 4) {
                        activityScore = 1.9;
                        initActivity = 4;
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    age = double.parse(ageController.value.text);
                    weight = double.parse(weightController.value.text);
                    height = double.parse(heightController.value.text);
                    calculateCalories(age, weight, height);
                    prefs.setString('myResult', result);
                    prefs.setInt('genderLabel', initGender);
                    prefs.setInt('systemLabel', initSystem);
                    prefs.setInt('activityLabel', initActivity);
                    prefs.setDouble('activityScore', activityScore);
                    getAge = ageController.text;
                    prefs.setString('ageNumber', getAge);
                    getWeight = weightController.text;
                    prefs.setString('weightNumber', getWeight);
                    getHeight = heightController.text;
                    prefs.setString('heightNumber', getHeight);
                    prefs.setString('myResult', result);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainPage(value: result)));
                  });
                },
                child: Text('Calculate'),
              ),
              RaisedButton(
                onPressed: reset,
                child: Text('Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateCalories(double age, double weight, double height) {
    if (initGender == 0 && initSystem == 0) {
      double finalresult =
          ((4.536 * weight) + (15.88 * height) - (5 * age) + 5) * activityScore;

      String calories = finalresult.toStringAsFixed(0);
      setState(() {
        result = calories;
      });
    } else if (initGender == 1 && initSystem == 0) {
      double finalresult =
          ((4.536 * weight) + (15.88 * height) - (5 * age) - 161) *
              activityScore;
      String calories = finalresult.toStringAsFixed(0);
      setState(() {
        result = calories;
      });
    } else if (initGender == 0 && initSystem == 1) {
      double finalresult =
          ((10 * weight) + (6.25 * height) - (5 * age) + 5) * activityScore;
      String calories = finalresult.toStringAsFixed(0);
      setState(() {
        result = calories;
      });
    } else if (initGender == 1 && initSystem == 1) {
      double finalresult =
          ((10 * weight) + (6.25 * height) - (5 * age) - 161) * activityScore;
      String calories = finalresult.toStringAsFixed(0);
      setState(() {
        result = calories;
      });
    }
  }
}
