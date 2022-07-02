import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/rep/models/todo.dart';
import 'package:todoapp/rep/rep.dart';
import 'package:todoapp/rep/models/category.dart';
import 'package:todoapp/src/app.dart';

class NewTodo extends StatefulWidget {
  const NewTodo({Key? key, this.todo, required this.update}) : super(key: key);
  final Todo? todo;
  final bool update;
  @override
  State<NewTodo> createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  var dropdownvalue = 'Select a category';
  List<Category> list = <Category>[];
  List<DropdownMenuItem> listItems = <DropdownMenuItem>[
    const DropdownMenuItem(
      child: Text('Without category'),
      value: 'none',
    )
  ];
  @override
  void initState() {
    super.initState();
    _categoriesList();
  }

  _categoriesList() async {
    list = await allCategorys('category');
    setState(() {
      for (var element in list) {
        listItems.add(DropdownMenuItem(
          child: Text(element.name),
          value: element.name,
        ));
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add new task',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: widget.update
                  ? () async {
                      if (_formKey.currentState!.validate()) {
                        int? id = widget.todo?.id;
                        await updateTable(
                            Todo( id! , _titleController.text, _dateController.text,
                                _timeController.text, dropdownvalue, 1),
                            'todo');
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const App(categoryName: 'All todos',)));
                      }
                    }
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        await insertObject(
                            Todo(0, _titleController.text, _dateController.text,
                                _timeController.text, dropdownvalue, 1),
                            'todo');
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const App(categoryName: 'All todos',)));
                      }
                    },
              icon: const Icon(
                Icons.done,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'to do...',
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: _dateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'select date...',
                    prefixIcon: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return DatePickerDialog(
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 100)));
                            }).then((date) {
                          setState(() {
                            _dateController.text =
                                DateFormat('yyyy-MM-dd').format(date);
                          });
                        });
                      },
                      child: const Icon(Icons.calendar_today),
                    )),
              ),
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: _timeController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'alarme time',
                    label: const Text('Alarme '),
                    prefixIcon: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return TimePickerDialog(
                                initialTime: TimeOfDay(
                                    hour: DateTime.now().hour,
                                    minute: DateTime.now().minute),
                              );
                            }).then((time) {
                          setState(() {
                            _timeController.text = time.format(context);
                            // _timeController.text = time.toString();
                          });
                        });
                      },
                      child: const Icon(Icons.calendar_today),
                    )),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: DropdownButtonFormField<dynamic>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('category'),
                  items: listItems,
                  onChanged: (value) {
                    setState(() {
                      dropdownvalue = value.toString();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
