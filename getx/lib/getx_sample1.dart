import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(Sample1());

class Sample1 extends StatelessWidget {
  var count = 0.obs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('counter'),
        ),
        body: Center(
          child: Obx(() => Text("$count")),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => count++,
        ),
      ),
    );
  }
}
