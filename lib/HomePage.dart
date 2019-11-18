import 'package:flutter/material.dart';
import 'package:todoey_app/AddTaskScreen.dart';
import 'package:todoey_app/searchmodule.dart';

import 'BLoCs/TodoBloc.dart';
import 'Models/Task.dart';

class HomePage extends StatelessWidget {
  final TodoBloc todoBloc = TodoBloc();
  DismissDirection _dismissDirection = DismissDirection.horizontal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff00D207),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 20.0),
                child: Column(
                  children: <Widget>[
                    logoRow(),
                    SizedBox(
                      height: 30.0,
                    ),
                    searchBar(context),
                  ],
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              listContainer(context)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffF8F8F8),
        child: Icon(
          Icons.add,
          size: 40,
          color: Colors.green,
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: (context) => AddTaskScreen(todoBloc));
        },
      ),
    );
  }

  Widget logo() {
    return CircleAvatar(
      backgroundColor: Color(0xffedf5f5),
      radius: 30.0,
      child: Icon(
        Icons.assignment_turned_in,
        size: 40,
        color: Color(0xff00D207),
      ),
    );
  }

  Widget logoRow() {
    return Row(
      children: <Widget>[
        logo(),
        SizedBox(
          width: 20.0,
        ),
        Text(
          'TODOEY',
          style: TextStyle(
              fontSize: 40,
              color: Color(0xffedf5f5),
              fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0, left: 10.0),
      child: TextField(
        autofocus: false,
        style: TextStyle(fontSize: 22.0, color: Color(0xFFbdc6cf)),
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.black12,
          hintStyle: TextStyle(color: Color(0xffF8F8F8)),
          labelStyle: TextStyle(color: Colors.white),
          hintText: 'Search...',
          suffixIcon: IconButton(
            icon: Icon(
              Icons.search,
              color: Color(0xffF8F8F8),
            ),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => SearchScreen(todoBloc));
            },
          ),
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(25.7),
          ),
        ),
      ),
    );
  }

  Widget listContainer(BuildContext context) {
    return Expanded(
      flex: 3,
      child: ClipRRect(
        child: Container(
            color: Color(0xffedf5f5),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: StreamBuilder(
                stream: todoBloc.todos,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
                  return getTodoS(snapshot);
                },
              ),
            )),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.0), topLeft: Radius.circular(40.0)),
      ),
    );
  }

  Widget getTodoS(AsyncSnapshot<List<Todo>> snapshot) {
    if (snapshot.hasData) {
      /*Also handles whenever there's stream
      but returned returned 0 records of Todo from DB.
      If that the case show user that you have empty Todos
      */
      return snapshot.data.length != 0
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemPosition) {
                Todo todo = snapshot.data[itemPosition];
                final Widget dismissibleCard = new Dismissible(
                  background: Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Deleting",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    color: Colors.redAccent,
                  ),
                  onDismissed: (direction) {
                    /*The magic
                    delete Todo item by ID whenever
                    the card is dismissed
                    */
                    todoBloc.deleteTodoById(todo.id);
                  },
                  direction: _dismissDirection,
                  key: new ObjectKey(todo),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey[200], width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        leading: InkWell(
                          onTap: () {
                            //Reverse the value
                            todo.isDone = !todo.isDone;
                            /*
                            Another magic.
                            This will update Todo isDone with either
                            completed or not
                          */
                            todoBloc.updateTodo(todo);
                          },
                          child: Container(
                            //decoration: BoxDecoration(),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: todo.isDone
                                  ? Icon(
                                      Icons.done,
                                      size: 26.0,
                                      color: Color(0xff00D007),
                                    )
                                  : Icon(
                                      Icons.check_box_outline_blank,
                                      size: 26.0,
                                      color: Color(0xff00D007),
                                    ),
                            ),
                          ),
                        ),
                        title: Text(
                          todo.description,
                          style: TextStyle(
                              fontSize: 16.5,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.w500,
                              decoration: todo.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                      )),
                );
                return dismissibleCard;
              },
            )
          : Container(
              child: Center(
              //this is used whenever there 0 Todo
              //in the data base
              child: noTodoMessageWidget(),
            ));
    } else {
      return Center(
        /*since most of our I/O operations are done
        outside the main thread asynchronously
        we may want to display a loading indicator
        to let the use know the app is currently
        processing*/
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    todoBloc.getTodos();
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Loading...",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget noTodoMessageWidget() {
    return Container(
      child: Text(
        "No todos yet, start adding some..",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }

  dispose() {
    todoBloc.dispose();
  }
}
