import 'package:flutter/material.dart';

import 'BLoCs/TodoBloc.dart';
import 'Models/Task.dart';

class SearchScreen extends StatelessWidget {
  final TodoBloc todoBloc;
  SearchScreen(this.todoBloc);
  @override
  Widget build(BuildContext context) {
    String newTaskTitle;

    return Container(
      color: Color(0xFF757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Search for...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xff00D207), fontSize: 30),
            ),
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff00D207)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff00D207)),
                ),
              ),
              onChanged: (newValue) {
                newTaskTitle = newValue;
              },
            ),
            FlatButton(
              child: Text(
                'Search',
                style: TextStyle(color: Colors.white),
              ),
              color: Color(0xff00D207),
              onPressed: () {
                todoBloc.getTodos(query: newTaskTitle);
                //dismisses the bottomsheet
                Navigator.pop(context);

                //}
              },
            )
          ],
        ),
      ),
    );
  }
}
