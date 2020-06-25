import 'package:flutter/material.dart';

import './screen/todoListPage.dart';
import './screen/addnewtodo.dart';

void main() {
  runApp(
 MyApp()   
 );
}
class MyApp extends StatelessWidget{
@override
Widget build(BuildContext context){
  return    MaterialApp(
    home: TodoListScreen(),
    theme: ThemeData(primaryColor: Colors.blue, accentColor: Colors.amber),
    routes:{AddNewToDO.routename:(ctx)=>AddNewToDO()

    }
  );
}
}