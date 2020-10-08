import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String URL_PREFIX = 'http://swopenapi.seoul.go.kr/api/subway/';
const String USER_KEY = 'sample';
const String URL_SUFFIX = '/json/realtimeStationArrival/0/5/';
const String DEFAULT_STATION = '광화문';
const int STATUS_OK = 200;

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class SubwayArrival {
  int _rowNum;
  String _subwayId;
  String _trainLineName;
  String _subwayHeading;
  String _arvlMsg2;

  SubwayArrival(this._rowNum, this._subwayId, this._trainLineName,
      this._subwayHeading, this._arvlMsg2);

  int get rowNum => _rowNum;
  String get subwayId => _subwayId;
  String get trainLineName => _trainLineName;
  String get subwayHeading => _subwayHeading;
  String get arvlMsg2 => _arvlMsg2;
}

class MainPageState extends State<MainPage> {
  int _rowNum;
  String _subwayId;
  String _trainLineName;
  String _subwayHeading;
  String _arvlMsg2;

  String _buildUrl(String station) {
    StringBuffer sb = StringBuffer();
    sb.write(URL_PREFIX);
    sb.write(USER_KEY);
    sb.write(URL_SUFFIX);
    sb.write(station);

    print(sb.toString());

    return sb.toString();
  }

  _httpGet(String url) async {
    var response = await http.get(_buildUrl(DEFAULT_STATION));
    String responseBody = response.body;

    var json = jsonDecode(responseBody);
    Map<String, dynamic> errorMessage = json['errorMessage'];

    if (errorMessage['status'] != STATUS_OK) {
      setState(() {
        final String errMessage = errorMessage['message'];
        _rowNum = -1;
        _subwayId = '';
        _trainLineName = '';
        _subwayHeading = '';
        _arvlMsg2 = errMessage;
      });

      return;
    }

    List<dynamic> realtimeArrivalList = json['realtimeArrivalList'];
    final int cnt = realtimeArrivalList.length;

    List<SubwayArrival> list = List.generate(cnt, (int ii) {
      Map<String, dynamic> item = realtimeArrivalList[ii];
      return SubwayArrival(item['rowNum'], item['subwayId'],
          item['trainLineNm'], item['subwayHeading'], item['arvlMsg2']);
    });

    SubwayArrival first = list[0];

    setState(() {
      _rowNum = first.rowNum;
      _subwayId = first.subwayId;
      _trainLineName = first.trainLineName;
      _subwayHeading = first.subwayHeading;
      _arvlMsg2 = first.arvlMsg2;
    });
  }

  @override
  void initState() {
    super.initState();
    _httpGet(_buildUrl(DEFAULT_STATION));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('지하철 실시간 정보'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('rowNum : $_rowNum'),
              Text('subwayId : $_subwayId'),
              Text('tranLineName : $_trainLineName'),
              Text('subwayHeading : $_subwayHeading'),
              Text('arvlMsg2 : $_arvlMsg2'),
            ],
          ),
        ));
  }
}
