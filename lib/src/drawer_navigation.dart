import 'package:flutter/material.dart';
import 'package:todoapp/rep/models/category.dart';
import 'package:todoapp/rep/rep.dart';

import 'package:todoapp/src/app.dart';
import 'package:todoapp/src/categories.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[400],
            child: const Text(
              ' To Do ',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          ListTile(
              title: const Text('ToDo List'),
              leading: const Icon(Icons.home),
              onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: ((context) => const App(
                              categoryName: 'All todos',
                            ))),
                  )),
          ListTile(
            title: ExpansionTile(
              title: const Text('Categories'),
              children: <Widget>[
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(list[index].name),
                          onTap: () => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: ((context) =>  App(
                                          categoryName: list[index].name,
                                        ))),
                              ));
                    })
              ],
            ),
            leading: const Icon(Icons.view_list),
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: ((context) => const Categories())),
            ),
          ),
        ],
      ),
    );
  }
}
