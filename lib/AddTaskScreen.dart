import 'package:flutter/material.dart';

import 'BLoCs/TodoBloc.dart';
import 'Models/Task.dart';

class AddTaskScreen extends StatelessWidget {
  final TodoBloc todoBloc;
  AddTaskScreen(this.todoBloc);
  @override
  Widget build(BuildContext context) {
    String newTaskTitle;

    return Container(
      color: Colors.transparent,
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
              'Add Task',
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
                'Add',
                style: TextStyle(color: Colors.white),
              ),
              color: Color(0xff00D207),
              onPressed: () {
                final newTodo = Todo(description: newTaskTitle);
                if (newTodo.description == null) {
                } else if (newTodo.description.isNotEmpty) {
                  /*Create new Todo object and make sure
                                    the Todo description is not empty,
                                    because what's the point of saving empty
                                    Todo
                                    */
                  todoBloc.addTodo(newTodo);

                  //dismisses the bottomsheet
                  Navigator.pop(context);
                }
                //}
              },
            )
          ],
        ),
      ),
    );
  }
}
