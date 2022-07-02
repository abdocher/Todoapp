import 'package:todoapp/rep/models/category.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/rep/rep.dart';
import 'package:todoapp/src/app.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);
  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  List<Category> list = <Category>[];
  @override
  void initState() {
    super.initState();
    _categoriesList();
  }

  _categoriesList() async {
    var list1 = await allCategorys('category');
    setState(() {
      list = list1;
    });
  }

  _showDialogDelete(BuildContext context, int id) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                  style: TextButton.styleFrom(primary: Colors.blue),
                ),
                TextButton(
                  onPressed: () async {
                    await deleteRecord(id, 'category');
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Categories()));
                  },
                  child: const Text('Delete'),
                  style: TextButton.styleFrom(primary: Colors.red),
                ),
              ],
              title: const Text('Delete'),
              content: const SingleChildScrollView(
                child: Text('Delete Category ?'),
              ));
        });
  }

  _showDialogUpdate(BuildContext context, int id, Category theCategory) {
    _nameController.text = theCategory.name;
    _descController.text = theCategory.description;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
                style: TextButton.styleFrom(primary: Colors.blue),
              ),
              TextButton(
                onPressed: () async {
                  var category =
                      Category(id, _nameController.text, _descController.text);
                  await updateTable(category, 'category');
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Categories()));
                },
                child: const Text('Save'),
                style: TextButton.styleFrom(primary: Colors.red),
              ),
            ],
            title: const Text('Categories'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'category name...',
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    hintText: 'category description...',
                    labelText: 'Description',
                  ),
                )
              ],
            )),
          );
        });
  }

  _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
                style: TextButton.styleFrom(primary: Colors.blue),
              ),
              TextButton(
                onPressed: () async {
                  var category =
                      Category(0, _nameController.text, _descController.text);
                  await insertObject(category, 'category');
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Categories()));
                },
                child: const Text('Save'),
                style: TextButton.styleFrom(primary: Colors.red),
              ),
            ],
            title: const Text('Categories'),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'category name...',
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    hintText: 'category description...',
                    labelText: 'Description',
                  ),
                )
              ],
            )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: ((context) => const App(categoryName: 'All todos',))),
          ),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text('Categories', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(
              
              title: Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 218, 218, 218), width: 0.5, style: BorderStyle.solid),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Category theCategory = Category(
                              list[index].id,
                              list[index].name,
                              list[index].description,
                            );
                            _showDialogUpdate(
                                context, list[index].id, theCategory);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.green,
                          )),
                      Text(list[index].name),
                      IconButton(
                          onPressed: () {
                            _showDialogDelete(context, list[index].id);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ]),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
