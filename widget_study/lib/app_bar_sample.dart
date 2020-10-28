import 'package:flutter/material.dart';

void main() => runApp(AppBarExample());

class AppBarExample extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: ABStatelessWidget(),
    );
  }
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final SnackBar snackBar = const SnackBar(
  content: Text('Showing Snackbar'),
);

void openPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Next Page')),
        body: const Center(
          child: Text('this is the next page',
              style: TextStyle(
                fontSize: 24,
              )),
        ),
      );
    }),
  );
}

class ABStatelessWidget extends StatelessWidget {
  ABStatelessWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('AppBar Demo'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              //ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Next Page',
            onPressed: () {
              openPage(context);
            },
          ),
        ],
      ),
      body: const Center(
          child: Text(
        'This is the home page',
        style: TextStyle(fontSize: 24),
      )),
    );
  }
}
