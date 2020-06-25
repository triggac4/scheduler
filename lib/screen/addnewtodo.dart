import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:worldclock/util/databaseHelper.dart';
import '../models/todoModel.dart';

class AddNewToDO extends StatefulWidget {
  static const routename = '/addnewtodo';
  @override
  _AddNewToDOState createState() => _AddNewToDOState();
}

class _AddNewToDOState extends State<AddNewToDO> {
  DatabaseHelper helper = DatabaseHelper();
  var form = GlobalKey<FormState>();
  TodoModel model;
  Map<String, dynamic> todo;
  bool init = true;
  DateTime date = DateTime.now();

  Widget showmedatepicker(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
      boxShadow: <BoxShadow>[
        BoxShadow(color:Colors.black,
        offset:Offset(3,5),
        blurRadius: 7
        )
      ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
              child: CupertinoDatePicker(
          
          onDateTimeChanged: (datez) {
            if (datez == null) {
              return;
            }
            setState(() {
              date = datez;
            });
          },
          initialDateTime:
              todo['item'] == null ? DateTime.now() : todo['item'].date,
          maximumDate: null,
          maximumYear: null,
          mode: CupertinoDatePickerMode.date,
          minimumDate: DateTime(2017),
          minimumYear: 2017,
          backgroundColor: Colors.blue[900],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (init) {
      todo = ModalRoute.of(context).settings.arguments as Map;
      date = todo['item'] == null ? DateTime.now() : todo['item'].date;
      valuez = todo['item'] == null ? 'not urgent' : todo['item'].urgency;
      model = TodoModel(
          date: date, description: '', id: null, title: '', urgency: valuez);
      super.didChangeDependencies();
    }
    init = false;
  }

  verify() {
    if (!form.currentState.validate()) {
      return;
    } else {
      form.currentState.save();
      if (todo['item'] == null) {
        helper.insert(model).then((val) {
          setState(() {
            todo['function']();
          });
         
          Navigator.of(context).pop();
          
        });
      } else {
        model = TodoModel(
          id: todo['item'].id,
          urgency: valuez,
          title: model.title,
          description: model.description,
          date: date,
        );
        todo['instance'].update(model).then((_) {
          setState(() {
          todo['function']();
        
          });
        });
        Navigator.of(context).pop();
        
      }
    }
  }

  String valuez = 'not urgent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text('To Do List'),
        elevation: 0.0,
      ),
      body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), bottomLeft: Radius.circular(90)),
            gradient: LinearGradient(
                colors: [Colors.black, Colors.blue[900]],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
          child: Form(
              key: form,
              child: ListView(
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    initialValue:
                        todo['item'] == null ? null : todo['item'].title,
                    validator: (val) {
                      if (val == '') {
                        return 'please write a title';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      model = TodoModel(
                        urgency: valuez,
                        title: val,
                        id: model.id,
                        description: model.description,
                        date: date,
                      );
                    },
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.amber),
                      labelText: 'Title',
                      errorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(50)),
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(50)),
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(50)),
                          borderSide:
                              BorderSide(width: 2, color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(50)),
                          borderSide:
                              BorderSide(width: 2, color: Colors.black)),
                      filled: true,
                      fillColor: Colors.blue[900],
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    initialValue:
                        todo['item'] == null ? null : todo['item'].description,
                    onSaved: (val) {
                      model = TodoModel(
                        urgency: valuez,
                        title: model.title,
                        id: model.id,
                        description: val,
                        date: date,
                      );
                    },
                    validator: (val) {
                      if (val == '') {
                        return 'please write a title';
                      } else if (val.length < 10) {
                        return 'please input 10 characters';
                      } else {
                        return null;
                      }
                    },
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.amber),
                      errorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(50)),
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(50)),
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      labelText: 'description',
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(50)),
                          borderSide:
                              BorderSide(width: 2, color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(50)),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.black,
                          )),
                      filled: true,
                      fillColor: Colors.blue[900],
                    ),
                    textInputAction: TextInputAction.newline,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                                              child: Container(
                            height: 200,
                            width: 400,
                            child: showmedatepicker(context)),
                      ),
                      
                    ],
                  ),
                  SizedBox(height:10),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.amber,
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(date),
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 100, left: 100),
                    padding: EdgeInsets.only(left: 10),
                    color: Colors.amber,
                    child: DropdownButton(
                      items: [
                        DropdownMenuItem(
                          child: Text('urgent',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          value: 'urgent',
                        ),
                        DropdownMenuItem(
                            child: Text(
                              'not urgent',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            value: 'not urgent'),
                      ],
                      value: valuez,
                      style: TextStyle(color: Colors.white),
                      onChanged: (va) {
                        setState(() {
                          valuez = va;
                        });
                        print(valuez);
                      },
                    ),
                  ),
                ],
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          verify();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future popscreen(context) {
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Text('added'),
          content: Text('your todo has been added'),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  return Navigator.of(context).pop();
                },
                child: Text('ok'))
          ],
        ));
  }
}
