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
  String newValue;
  double newNumber;
  double resultNumber;
  String fast;
  String medium;
  String maintain;
  double newCalories;
  double oldCalories;
  double resultCalories;
  String totalCalories;
  int newCalories2;
  int finalNumber;
  String caloriesAte;
  String defaultString = '0';
  int newAteCalories = 0;

  _MainPageState(this.value);

  restoreMain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      value = (prefs.getString('myValue')) ?? (prefs.getString('myResult'));
      newValue = (prefs.getString('newValue')) ?? value;
      weightLoss = 2;
      caloriesAte = (prefs.getString('caloriesAte')) ?? defaultString;
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
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
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
                    '$caloriesAte',
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
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
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
                    if (index == 0) {
                      weightLoss = 0;
                      newNumber = double.parse(value);
                      resultNumber = newNumber * 0.6;
                      fast = resultNumber.toStringAsFixed(0);
                      newValue = fast;
                      prefs.setString('myValue', value);
                      prefs.setString('newValue', newValue);
                      prefs.setInt('loseWeight', weightLoss);
                    } else if (index == 1) {
                      weightLoss = 1;
                      newNumber = double.parse(value);
                      resultNumber = newNumber * 0.8;
                      medium = resultNumber.toStringAsFixed(0);
                      newValue = medium;
                      prefs.setString('myValue', value);
                      prefs.setString('newValue', newValue);
                      prefs.setInt('loseWeight', weightLoss);
                    } else if (index == 2) {
                      weightLoss = 2;
                      newNumber = double.parse(value);
                      resultNumber = newNumber * 1;
                      maintain = resultNumber.toStringAsFixed(0);
                      newValue = maintain;
                      prefs.setString('myValue', value);
                      prefs.setString('newValue', newValue);
                      prefs.setInt('loseWeight', weightLoss);
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
                      color: Colors.blue,
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

                            newCalories = double.parse(_personPhone);
                            oldCalories = double.parse(newValue);
                            resultCalories = oldCalories - newCalories;
                            totalCalories = resultCalories.toStringAsFixed(0);
                            newValue = totalCalories;
                            value = totalCalories;

                            newAteCalories = int.parse(caloriesAte);

                            newCalories2 = newCalories.toInt();
                            finalNumber = newCalories2 + newAteCalories;
                            caloriesAte = finalNumber.toString();
                            prefs.setString('caloriesAte', caloriesAte);
                            prefs.setString('myValue', value);
                            prefs.setString('newValue', newValue);
                          }

                          _personNameController.text = '';
                          _personPhoneController.text = '';
                          refreshpersonList();
                        });
                      },
                    ),
                    RaisedButton(
                      color: Colors.blue,
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
