import 'package:flutter/material.dart';
import 'package:todoapp/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.lime,
            textTheme: const TextTheme(
                headline1: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))),
        debugShowCheckedModeBanner: false,
        title: 'ToDo remainder',
        home: const App(categoryName: 'All todos',));
  }
}
