import 'package:todoapp/rep/models/alarms.dart';
import 'package:todoapp/rep/models/todo.dart';
import 'package:todoapp/rep/rep.dart';
import 'newtodo.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/src/drawer_navigation.dart';

class App extends StatefulWidget {
  const App({Key? key,required this.categoryName}) : super(key: key);
  final String categoryName;
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<Todo> list = <Todo>[];

  @override
  void initState() {
    super.initState();
    setState(() {
      _todoList();
    });
  }

  _setIsDone(bool isDone) {
    if (isDone) {
      return 1;
    } else {
      return 0;
    }
  }

  bool _checkIsDone(int isDone) {
    if (isDone == 1) {
      return true;
    } else {
      return false;
    }
  }

  _todoList() async {
    var list1 = await allTodos(widget.categoryName);
    setState(() {
      list = list1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          widget.categoryName,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => NewTodo(
                          todo: list[index],
                          update: true,
                        ))));
              },
              onLongPress: (() {
                showMenu(
                    context: context,
                    items: <PopupMenuEntry>[
                      PopupMenuItem(
                          onTap: () {
                            deleteRecord(list[index].id, 'todo');
                            setState(() {
                              _todoList();
                            });
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ))
                    ],
                    position: RelativeRect.fill);
              }),
              title: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 218, 218, 218),
                        width: 0.5,
                        style: BorderStyle.solid),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Column(children: [
                  Text(
                    list[index].title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        DateFormat('EEE, MMM d')
                            .format(DateTime.parse(list[index].date)),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Text(
                        list[index].time,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Row(children: [
                        Icon(list[index].isOutOfDate() || !_checkIsDone(list[index].isDone)
                            ? Icons.alarm_off
                            : Icons.alarm_on),
                        Switch(
                            value: _checkIsDone(list[index].isDone) ||
                                list[index].isOutOfDate(),
                            onChanged: list[index].isOutOfDate()
                                ? null
                                : (bool val) {
                                    setState(() {
                                      list[index].isDone = _setIsDone(val);
                                      updateTable(list[index], 'todo');
                                      val
                                          ? setAlarm(
                                              list[index].title,
                                              Alarm(list[index].date,
                                                  list[index].time),
                                              list[index].id)
                                          : deleteAlarm(list[index].id);
                                    });
                                  }),
                      ])
                    ],
                  ),
                ]),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => const NewTodo(
                    update: false,
                  ))));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      drawer: const DrawerNavigation(),
    );
  }
}
