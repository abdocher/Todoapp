
import 'package:flutter/material.dart';


class MyShowWidget extends StatefulWidget {
  const MyShowWidget({Key? key,required this.categoryName}) : super(key: key);
final String categoryName;
  @override
  State<MyShowWidget> createState() => _MyShowWidgetState();
}

class _MyShowWidgetState extends State<MyShowWidget> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName),
      elevation: 0,
      ),
    );
  }
}
