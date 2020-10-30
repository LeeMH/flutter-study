import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: '/home',
    defaultTransition: Transition.native,
    translations: MyTranslations(),
    locale: Locale('pt', 'BR'),
    getPages: [
      //Simple page
      GetPage(name: '/home', page: () => First()),

      // GetPage with custom transitions and bindings
      GetPage(
        name: '/second',
        page: () => Second(),
        customTransition: SizeTransitions(),
        binding: SampleBind(),
      ),

      // GetPage with default transitions
      GetPage(
        name: 'third',
        //transition: Transition.cupertino,
        page: () => Third(),
      ),
    ],
  ));
}

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'title': 'Hello World %s',
        },
        'en_US': {
          'title': 'from US, first=%s, second=%s',
        },
        'pt': {
          'title': 'Ola de Portugal',
        },
        'pt_BR': {
          'title': 'Ola do Brasil',
        }
      };
}

class Controller extends GetxController {
  var count = 0.obs;
  void increment() {
    count++;
    update();
  }
}

class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.snackbar("hi", "I'm modern snackbar");
          },
        ),
        title: Text("title".trArgs(['John', 'Mike'])),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<Controller>(
              init: Controller(),
              //You can initialize your controller hrere the first time.
              //Don't use init in your other GetBuilders of same controller
              builder: (_) => Text('clicks: ${_.count}'),
            ),
            RaisedButton(
              child: Text('Next Route'),
              onPressed: () {
                Get.toNamed('/second');
              },
            ),
            RaisedButton(
              child: Text('Change locale to English'),
              onPressed: () {
                Get.updateLocale(Locale('en', ''));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.find<Controller>().increment();
        },
      ),
    );
  }
}

class Second extends GetView<ControllerX> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('second Route'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<Controller>(
              builder: (_) => Text('clicks: ${_.count}'),
            ),
            GetX<ControllerX>(
              builder: (_) {
                print('count1 rebuild');
                return Text('${_.count1} ==> ${controller.count1}');
              },
            ),
            GetX<ControllerX>(
              builder: (_) {
                print('count2 rebuild');
                return Text('${controller.count2}');
              },
            ),
            GetX<ControllerX>(
              builder: (_) {
                print('sum rebuild');
                return Text('${_.sum}');
              },
            ),
            GetX<ControllerX>(
              builder: (_) => Text('Name: ${controller.user.value.name}'),
            ),
            GetX<ControllerX>(
              builder: (_) => Text('Age: ${_.user.value.age}'),
            ),
            RaisedButton(
              child: Text('Go to last page'),
              onPressed: () {
                Get.toNamed('/third', arguments: ['arguments of second', 1]);
              },
            ),
            RaisedButton(
              child: Text('Back page and open snackbar'),
              onPressed: () {
                Get.back();
                Get.snackbar(
                  'user 123',
                  'Successfully created',
                );
              },
            ),
            RaisedButton(
              child: Text('Increment count1'),
              onPressed: () {
                Get.find<ControllerX>().increment();
              },
            ),
            RaisedButton(
              child: Text('Increment count2'),
              onPressed: () {
                Get.find<ControllerX>().increment2();
              },
            ),
            RaisedButton(
              child: Text('Update name'),
              onPressed: () {
                Get.find<ControllerX>().updateUser();
              },
            ),
            RaisedButton(
              child: Text('Dispose worker'),
              onPressed: () {
                Get.find<ControllerX>().disposeWorker();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Third extends GetView<ControllerX> {
  @override
  Widget build(Object context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.incrementList();
        },
      ),
      appBar: AppBar(
        title: Text('Third ${Get.arguments[0]}, ${Get.arguments[1]}'),
      ),
      body: Center(
        child: Obx(
          () => ListView.builder(
            itemCount: controller.list.length,
            itemBuilder: (context, index) {
              return Text('${controller.list[index]}');
            },
          ),
        ),
      ),
    );
  }
}

class SampleBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControllerX>(() => ControllerX());
  }
}

class User {
  User({this.name = 'Name', this.age = 0});

  String name;
  int age;
}

class ControllerX extends GetxController {
  final count1 = 1.obs;
  final count2 = 2.obs;
  final list = [56].obs;
  final user = User().obs;

  updateUser() {
    user.update((value) {
      value.name = 'Jose';
      value.age = 30;
    });
  }

  /// made this if you need cancel you worker
  Worker _ever;

  @override
  onInit() async {
    /// Called every time the variable $_ is changed
    _ever = ever(count1, (_) => print("$_ has been changed (ever)"));

    everAll([count1, count2], (_) => print("$_ has been changed (everAll)"));

    /// Called first time the variable $_ is changed
    once(count1, (_) => print("$_ was changed once (once)"));

    /// Anti DDos - Called every time the user stops typing for 1 second, for example.
    debounce(count1, (_) => print("debouce$_ (debounce)"),
        time: Duration(seconds: 1));

    /// Ignore all changes within 1 second.
    interval(count1, (_) => print("interval $_ (interval)"),
        time: Duration(seconds: 1));
  }

  int get sum => count1.value + count2.value;

  increment() => count1.value++;

  increment2() => count2.value++;

  disposeWorker() {
    _ever.dispose();
    // or _ever();
  }

  incrementList() => list.add(75);
}

class SizeTransitions extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve curve,
      Alignment alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return Align(
      alignment: Alignment.center,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: curve,
        ),
        child: child,
      ),
    );
  }
}
