import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'person_model.dart';
import 'main_page.dart';

class PersonPage extends StatefulWidget {
  @override
  _personPageState createState() => _personPageState();
}

class _personPageState extends State<PersonPage> {
  String minusCalories;
  String foodName2;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  //Make the initialization

  Future<List<Person>> persons;

  String _foodName;
  String _foodCalories;

  int personIdForUpdate;
  DBHelper dbHelper;

  final _foodNameController = TextEditingController();
  final _foodCaloriesController = TextEditingController();

//also of the database
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshpersonList();
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
      appBar: AppBar(
        title: Text('Save Info App'),
        actions: <Widget>[],
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formStateKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    onSaved: (value) {
                      _foodName = value;
                    },
                    controller: _foodNameController,
                    decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.blue,
                                width: 2,
                                style: BorderStyle.solid)),
                        // hintText: "Person Name",
                        labelText: "Food Name",
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.blue,
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    onSaved: (value) {
                      _foodCalories = value;
                    },
                    keyboardType: TextInputType.number,
                    controller: _foodCaloriesController,
                    decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.blue,
                                width: 2,
                                style: BorderStyle.solid)),
                        // hintText: "Person Name",
                        labelText: "Calories",
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.blue,
                        )),
                  ),
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
                      onPressed: () {
                        if (_formStateKey.currentState.validate()) {
                          _formStateKey.currentState.save();
                          dbHelper.add(Person(null, _foodName, _foodCalories));
                        }

                        _foodNameController.text = '';
                        _foodCaloriesController.text = '';
                        refreshpersonList();
                        foodName2 = _foodName;
                        minusCalories = _foodCalories;
                        Navigator.pop(context, minusCalories);
                      },
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      child: Text(
                        ('CLEAR'),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _foodNameController.text = '';
                        _foodCaloriesController.text = '';
                        setState(() {
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
              label: Text('Food Name'),
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
                          personIdForUpdate = person.id;
                        });
                        _foodNameController.text = person.name;
                        _foodCaloriesController.text = person.phone;
                      },
                    ),
                    DataCell(
                      Text(person.phone),
                      onTap: () {
                        setState(() {
                          personIdForUpdate = person.id;
                        });
                        _foodNameController.text = person.name;
                        _foodCaloriesController.text = person.phone;
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
