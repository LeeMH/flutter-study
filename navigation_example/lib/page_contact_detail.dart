import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactDetailPage extends StatelessWidget {
  static const String routeName = '/contact';

  final Contact _contact;

  ContactDetailPage(this._contact);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_contact.displayName ?? ''),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Name'),
            trailing: Text(_contact.givenName ?? ''),
          ),
          ListTile(
            title: Text('Pones'),
            trailing: Text(
                _contact.phones.isNotEmpty ? _contact.phones.first.value : ''),
          ),
          ListTile(
            title: Text('Email'),
            trailing: Text(
                _contact.phones.isNotEmpty ? _contact.emails.first.value : ''),
          )
        ],
      ),
    );
  }
}
