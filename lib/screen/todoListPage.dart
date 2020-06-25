import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../util/databaseHelper.dart';
import '../models/todoModel.dart';
import './addnewtodo.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  var data = DatabaseHelper();
  List<TodoModel> todo = [];
  initState() {
    needful();
    super.initState();
  }

  needful() {
    data.todo().then((value) {
      setState(() {
        todo = value;
        print('needful');
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Column(
        children: <Widget>[
          AppBar(
            backgroundColor: Theme.of(context).primaryColorDark,
            elevation: 0,
            title: Text('todo List'),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(90)),
                gradient: LinearGradient(
                    colors: [Colors.black, Colors.blue[900]],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: todo.isEmpty
                  ? null
                  : Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: ListView.builder(
                        itemCount: todo.length,
                        itemBuilder: (ctx, i) {
                          return ClipRRect(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(50)),
                            child: Card(
                                child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    height: 50,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          todo[i].urgency == 'urgent'
                                              ? Icon(
                                                  Icons.timer,
                                                  size: 30,
                                                )
                                              : Icon(Icons.timer_off, size: 30),
                                          SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                todo[i].title,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Text(DateFormat('yyyy-MM-dd')
                                                  .format(todo[i].date))
                                            ],
                                          ),
                                          Spacer(),
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            color: Colors.blue[800],
                                            onPressed: () {
                                              print(todo[i].id);
                                              Navigator.of(context).pushNamed(
                                                  AddNewToDO.routename,
                                                  arguments: {
                                                    'todo': todo,
                                                    'item': todo[i],
                                                    'instance': data,
                                                    'function': needful
                                                  });
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            color: Theme.of(context).errorColor,
                                            onPressed: () {
                                              setState(() {
                                                data.delete(todo[i]);
                                                needful();
                                              });
                                            },
                                          )
                                        ]))),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            print(todo);
            Navigator.of(context).pushNamed(AddNewToDO.routename, arguments: {
              'todo': todo,
              'item': null,
              'instance': data,
              'function': needful
            });
          },
          child: Icon(Icons.add)),
    );
  }
}
