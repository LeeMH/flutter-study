import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'page_contact_detail.dart';
import 'page_contact_list.dart';

void main() => runApp(ContactsDemoV3());

class ContactsDemoV3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContactListPage(),
      onGenerateRoute: (RouteSettings settings) {
        if (ContactDetailPage.routeName == settings.name) {
          Contact c = settings.arguments;
          print(c.toString());
          return MaterialPageRoute(builder: (context) => ContactDetailPage(c));
        }

        return _noWay;
      },
    );
  }

  final MaterialPageRoute _noWay = MaterialPageRoute(
      builder: (_) => Scaffold(
              body: Center(
            child: Text('경로가 없습니다.'),
          )));
}
