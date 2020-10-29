import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(GetMaterialApp(home: Sample2()));

class Sample2 extends StatelessWidget {
  final controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetX<Controller>(
              builder: (_) => Text('clicks: ${controller.count}'),
            ),
            RaisedButton(
              child: Text('Next Route'),
              onPressed: () {
                print('click!!!!');
                Get.to(Second());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => controller.increment(),
      ),
    );
  }
}

class Second extends StatelessWidget {
  final Controller ctrl = Get.find();
  @override
  Widget build(context) {
    return Scaffold(body: Center(child: Text("${ctrl.count}")));
  }
}

class Controller extends GetxController {
  var count = 0.obs;
  void increment() {
    count++;
  }
}
