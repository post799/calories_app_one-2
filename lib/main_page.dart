import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'first_page.dart';
import 'main.dart';
import 'db_helper.dart';
import 'person_model.dart';

class MainPage extends StatefulWidget {
  String value;
  MainPage({Key key, @required this.value}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState(value);
}

class _MainPageState extends State<MainPage> {
  int dayOfWeek = 5;
  int weightLoss = 3;

  String value;
  String mainValue;
  String newValue;
  double resultNumber;
  // double resultNumber2;
  // double resultNumber3;
  String fast;
  String medium;
  String maintain;
  double newCalories;
  double oldCalories;
  double resultCalories;
  double tabNumber;
  String totalCalories;
  String newValue2;
  //
  double caloriesAte = 0;
  String consumedCaloriesText = '0';

  _MainPageState(
    this.value,
  );

  restoreMain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // weightLoss = (prefs.getInt('loseWeight')) ?? 2;
      // value = (prefs.getString('myValue')) ?? value;

      mainValue = (prefs.getString('mainValue')) ?? value;
      newValue2 = (prefs.getString('newValue'));
      newValue = newValue2 ?? mainValue;
      consumedCaloriesText = (prefs.getString('consumedCaloriesText')) ?? '0';
      caloriesAte = (prefs.getDouble('caloriesAte')) ?? 0;
      print('newValue:$newValue ');
      print('mainValue: $mainValue');
    });
  }

  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  //Make the initialization

  Future<List<Person>> persons;

  String _personName;
  String _personPhone;

  bool isUpdate = false;
  int personIdForUpdate;
  DBHelper dbHelper;

  final _personNameController = TextEditingController();
  final _personPhoneController = TextEditingController();

//also of the database
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshpersonList();
    restoreMain();
  }

//fetch persons list
  refreshpersonList() {
    setState(() {
      persons = dbHelper.getPerson();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Text('Your Nutrition Info'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FirstPage()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleSwitch(
                minWidth: 130.0,
                minHeight: 40.0,
                initialLabelIndex: dayOfWeek,
                cornerRadius: 10.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Color(0xff444c91),
                inactiveFgColor: Color(0xffe6e7f0),
                labels: [
                  'M',
                  'T',
                  'W',
                  'T',
                  'F',
                  'S',
                  'S',
                ],
                fontSize: 30,
                activeBgColors: [
                  Colors.indigo[900],
                  Colors.indigo[900],
                  Colors.indigo[900],
                  Colors.indigo[900],
                  Colors.indigo[900],
                  Colors.indigo[900],
                  Colors.indigo[900],
                ],
                onToggle: (index) {
                  if (index == 0) {
                    dayOfWeek = 0;
                  } else if (index == 1) {
                    dayOfWeek = 1;
                  } else if (index == 2) {
                    dayOfWeek = 2;
                  } else if (index == 3) {
                    dayOfWeek = 3;
                  } else if (index == 4) {
                    dayOfWeek = 4;
                  } else if (index == 5) {
                    dayOfWeek = 5;
                  } else if (index == 6) {
                    dayOfWeek = 6;
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    '0',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                  Text(
                    ' Fitness\nCalories',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$newValue',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                  ),
                  Text(
                    'Calories\n    Left',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$consumedCaloriesText',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                  Text(
                    '  Calories\nConsumed',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleSwitch(
                minWidth: 130.0,
                minHeight: 40.0,
                initialLabelIndex: weightLoss,
                cornerRadius: 10.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Color(0xff444c91),
                inactiveFgColor: Color(0xffe6e7f0),
                labels: [
                  ' Lose It\n  Fast',
                  ' Lose\nWeight',
                  'Maintain\n Weight',
                ],
                fontSize: 15,
                activeBgColors: [
                  Colors.indigo[900],
                  Colors.indigo[900],
                  Colors.indigo[900],
                ],
                onToggle: (index) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    tabNumber = double.parse(mainValue);
                    if (index == 0) {
                      weightLoss = index;
                      resultNumber = ((tabNumber * 0.6) - caloriesAte);
                      fast = resultNumber.toStringAsFixed(0);
                      newValue = fast;
                      //
                      // prefs.setString('fast', fast);
                      prefs.setString(
                          'consumedCaloriesText', consumedCaloriesText);
                      prefs.setString('newValue', newValue);
                      // prefs.setInt('loseWeight', weightLoss);
                      // prefs.setString('myValue', value);
                      // prefs.setString('mainValue', mainValue);
                    } else if (index == 1) {
                      weightLoss = index;
                      resultNumber = ((tabNumber * 0.8) - caloriesAte);
                      medium = resultNumber.toStringAsFixed(0);
                      newValue = medium;
                      //
                      // prefs.setString('medium', medium);
                      // prefs.setString('myValue', value);
                      prefs.setString(
                          'consumedCaloriesText', consumedCaloriesText);
                      prefs.setString('newValue', newValue);
                      // prefs.setInt('loseWeight', weightLoss);
                      // prefs.setString('mainValue', mainValue);
                    } else if (index == 2) {
                      weightLoss = index;
                      resultNumber = ((tabNumber * 1) - caloriesAte);

                      maintain = resultNumber.toStringAsFixed(0);
                      newValue = maintain;
                      //
                      // prefs.setString('maintain', maintain);
                      // prefs.setString('myValue', value);

                      // prefs.setInt('loseWeight', weightLoss);
                      // prefs.setString('mainValue', mainValue);
                    }
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Form(
            key: _formStateKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 40,
                      width: 200,
                      child: TextFormField(
                        onSaved: (value2) {
                          _personName = value2;
                        },
                        controller: _personNameController,
                        decoration: InputDecoration(
                            filled: true,
                            focusedBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                    style: BorderStyle.solid)),
                            // hintText: "Person Name",
                            hintText: 'Food Name',
                            fillColor: Color(0xffe3e6e5),
                            labelStyle: TextStyle(
                              color: Colors.blue,
                            )),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 120,
                      child: TextFormField(
                        onSaved: (value2) {
                          _personPhone = value2;
                        },
                        keyboardType: TextInputType.number,
                        controller: _personPhoneController,
                        decoration: InputDecoration(
                            filled: true,
                            focusedBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                    style: BorderStyle.solid)),
                            // hintText: "Person Name",
                            hintText: 'Calories',
                            fillColor: Color(0xffe3e6e5),
                            labelStyle: TextStyle(
                              color: Colors.blue,
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      color: Colors.indigo[900],
                      child: Text(
                        ('ADD'),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (_formStateKey.currentState.validate()) {
                            _formStateKey.currentState.save();
                            dbHelper
                                .add(Person(null, _personName, _personPhone));

                            // //Calculating calories after new food entry
                            newCalories = double.parse(_personPhone);
                            oldCalories = double.parse(newValue);
                            resultCalories = oldCalories - newCalories;
                            totalCalories = resultCalories.toStringAsFixed(0);
                            newValue = totalCalories;
                            //
                            // //Calculating calories ate
                            //
                            caloriesAte = newCalories + caloriesAte;

                            consumedCaloriesText =
                                caloriesAte.toStringAsFixed(0);
                            //
                            // //saving everything in shared prefs
                            prefs.setDouble('caloriesAte', caloriesAte);
                            prefs.setString(
                                'consumedCaloriesText', consumedCaloriesText);
                            prefs.setString('mainValue', mainValue);
                            prefs.setString('newValue', newValue);
                            // prefs.setString('myValue', value);
                            print('mainValue: $mainValue');
                            print('newValue: $newValue');
                            print('caloriesAte: $caloriesAte');
                            print(
                                'consumedCaloriesText: $consumedCaloriesText');
                          }

                          _personNameController.text = '';
                          _personPhoneController.text = '';
                          refreshpersonList();
                        });
                      },
                    ),
                    RaisedButton(
                      color: Colors.indigo[900],
                      child: Text(
                        ('CLEAR'),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _personNameController.text = '';
                        _personPhoneController.text = '';
                        setState(() {
                          isUpdate = false;
                          personIdForUpdate = null;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: 5.0,
          ),
          Expanded(
            child: FutureBuilder(
              future: persons,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return generateList(snapshot.data);
                }
                if (snapshot.data == null || snapshot.data.length == 0) {
                  return Text('No Person Found');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  //Generate the list view from the data
  SingleChildScrollView generateList(List<Person> persons) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Name'),
            ),
            DataColumn(
              label: Text('Calories'),
            ),
            DataColumn(
              label: Text(''),
            )
          ],
          rows: persons
              .map(
                (person) => DataRow(
                  cells: [
                    DataCell(
                      Text(person.name),
                      onTap: () {
                        setState(() {
                          isUpdate = true;
                          personIdForUpdate = person.id;
                        });
                        _personNameController.text = person.name;
                        _personPhoneController.text = person.phone;
                      },
                    ),
                    DataCell(
                      Text(person.phone),
                      onTap: () {
                        setState(() {
                          isUpdate = true;
                          personIdForUpdate = person.id;
                        });
                        _personNameController.text = person.name;
                        _personPhoneController.text = person.phone;
                      },
                    ),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          dbHelper.delete(person.id);
                          refreshpersonList();
                        },
                      ),
                    )
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
