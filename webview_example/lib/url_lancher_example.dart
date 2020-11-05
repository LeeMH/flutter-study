import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: RaisedButton(
            onPressed: _launchURL,
            child: Text('Show Flutter homepage'),
          ),
        ),
      ),
    ),
  );
}

_launchURL() async {
  const url =
      'https://m.map.naver.com/search2/site.nhn?query=%EC%95%84%EB%AA%A8%EC%A0%9C%EB%B9%8C%EB%94%A9&sm=hty&style=v5&code=20642229';
  if (await canLaunch(url)) {
    await launch(url, forceWebView: true, forceSafariVC: true);
  } else {
    throw 'Could not launch $url';
  }
}
